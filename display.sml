signature DISPLAY =
sig
  type Displayable
  type Counted
  val display : Displayable -> Counted -> string 
end

functor DisplayFn (structure S : SQUARE structure G : GRID) : DISPLAY =
struct

  type Displayable = S.Square G.Grid
  type Counted = int G.Grid

  (* Represent zero mined neighbours as empty sea. *)
  fun number 0 = " "
    | number i = Int.toString(i)

  (* Returns the string representation for a revealed square. *)
  fun revealed square count =
    if S.is_mined square then "X" else number count

  (* Returns the string representation for the given coordinate. *)
  fun presentation grid counts (x, y) =
    let
      val square = G.get grid x y
      val count = G.get counts x y
    in
      revealed square count
      (*if S.is_revealed square then revealed square count else "."*)
    end

  (* Returns the string representation of the grid. *)
  fun display grid counts =
    let
      val (x_size, y_size) = G.size grid
      fun invert (x, y) = (x_size - 1 - x, y_size - 1 - y)
      fun present x y = presentation grid counts (invert (x, y))
      fun raster 0 0 s = s ^ (present 0 0)
        | raster 0 y s = raster (x_size - 1) (y - 1) (s ^ (present 0 y) ^ "\n")
        | raster x y s = raster (x - 1) y (s ^ (present x y))
    in
      raster (x_size - 1) (y_size - 1) ""
    end

end

