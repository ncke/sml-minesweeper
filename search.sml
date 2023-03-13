signature SEARCH =
sig
  type SquareGrid
  type CountGrid
  val search : SquareGrid -> CountGrid -> (int * int) -> SquareGrid
end

functor SearchFn (structure S : SQUARE structure G : GRID) : SEARCH =
struct

  type SquareGrid = S.Square G.Grid
  type CountGrid = int G.Grid

  (* A coordinate is open water if there are no neighbouring mines. *)
  fun is_open_water c x y = G.get c x y = 0

  (* Coordinate can be neither already visited not prospected for a visit. *)
  fun can_visit visited prospects coord =
    let
      val is_same_coord = fn j => (fn k => j = k)
      val visited = List.exists (is_same_coord coord) visited
      val prospected = List.exists (is_same_coord coord) prospects
    in
      not visited andalso not prospected
    end

  (* Make a new grid that reveals a given square. *)
  fun reveal_sq g x y = G.set g x y (S.reveal (G.get g x y))

  (* Visit each square in the growable list of prospects *)
  fun search_recurse g c visited [] = g
    | search_recurse g c visited (coord :: prospects) =
        let
          val (x, y) = coord
          val will_recurse = is_open_water c x y
          val neighbours = G.adjacent g x y
          val new_p = List.filter (can_visit visited prospects) neighbours
          val next_p = if will_recurse then prospects @ new_p else prospects
        in
          search_recurse (reveal_sq g x y) c (coord :: visited) next_p
        end

  (* Search recursively to reveal open water. *)
  fun search g c coord = search_recurse g c [] [coord]

end
