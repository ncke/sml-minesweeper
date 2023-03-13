signature NEIGHBOURS =
sig
  type Countable
  type Counted 
  val Count : Countable -> Counted
end

functor NeighboursFn (structure S : SQUARE structure G : GRID) : NEIGHBOURS =
struct

  type Countable = S.Square G.Grid
  type Counted = int G.Grid

  (* Returns a list of squares adjacent to a coordinate. *)
  fun adjacent_squares g x y =
    let
      val adjacents = G.adjacent g x y
      fun get_square (x, y) = G.get g x y
    in
      List.map get_square adjacents
    end

  (* Update a grid with the neighbour count for coordinate x, y. *)
  fun neighbours g x y h =
    let
      val adjacents = adjacent_squares g x y
    in
      G.set h x y (length (List.filter S.is_mined adjacents))
    end

  (* Constructs a grid counting neighbouring squares that are mined. *)
  fun Count g =
    let
      val (x_size, y_size) = G.size g
      val h = G.Make x_size y_size 0
      fun counter 0 0 z = neighbours g 0 0 z
        | counter 0 y z = counter (x_size - 1) (y - 1) (neighbours g 0 y z)
        | counter x y z = counter (x - 1) y (neighbours g x y z)
    in
      counter (x_size - 1) (y_size - 1) h
    end

end

