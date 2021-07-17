signature PLAYER =
sig
  type Playable
  val play : Playable -> string -> Playable
end

functor PlayerFn (structure S : SQUARE structure G : GRID) : PLAYER =
struct

  type Playable = S.Square G.Grid

  (* An exception to indicate an uninterpretable string coordinate. *)
  exception BadCoordinate

  (* Converts a letter into an x-coordinate. *)
  fun letter_x letter =
    let
      val letters = String.explode("abcdefghijklmnopqrstuvwxyz")
      fun find n [] = raise BadCoordinate (* Expected a letter. *)
        | find n (lr :: ls) = if lr = letter then n else find (n + 1) ls
    in
      find 0 letters
    end

  (* Given a human-readable move, return its coordinate. *)
  fun move_coords move =
    let
      val row_letter = hd (String.explode(move))
      val row_int = letter_x row_letter
      val col_str = String.extract(move, 1, NONE)
      val col_int = case Int.fromString col_str of
                         SOME i => i
                       | NONE => raise BadCoordinate (* Expected a number. *)
    in
      (row_int, col_int)
    end

  (* Play a human readable move on the grid. *)
  fun play g move =
    let
      val (x, y) = move_coords move
      val sq = G.get g x y
    in
      G.set g x y (S.reveal sq)
    end

end

