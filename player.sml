signature PLAYER =
sig
  type SquareGrid
  type CountGrid
  val reveal : SquareGrid -> CountGrid -> string -> SquareGrid
  val mark : SquareGrid -> string -> SquareGrid
end

functor PlayerFn (structure S : SQUARE structure G : GRID) : PLAYER =
struct

  type SquareGrid = S.Square G.Grid
  type CountGrid = int G.Grid

  structure Search = SearchFn ( structure S = S structure G = G )
 
  (* An exception to indicate an uninterpretable string coordinate. *)
  exception BadCoordinate

  (* Converts a letter into an x-coordinate. *)
  fun x_from_letter letter =
    let
      val letters = String.explode("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
      fun find n [] = raise BadCoordinate (* Expected a letter. *)
        | find n (lr :: ls) = if lr = letter then n else find (n + 1) ls
    in
      find 0 letters
    end

  (* Given a human-readable move, return its coordinate. *)
  fun move_coords move =
    let
      val row_letter = hd (String.explode(move))
      val row_int = x_from_letter row_letter
      val col_str = String.extract(move, 1, NONE)
      val col_int = case Int.fromString col_str of
                         SOME i => i
                       | NONE => raise BadCoordinate (* Expected a number. *)
    in
      (row_int, col_int - 1)
    end

  (* Play a human readable move to reveal a square on the grid. *)
  fun reveal g c move = Search.search g c (move_coords move)

  fun mark_sq g x y = G.set g x y (S.mark (G.get g x y))

  fun mark g move =
    let
      val (x, y) = move_coords move
      val marked_grid = mark_sq g x y
    in
      marked_grid
    end

end
