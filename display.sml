signature DISPLAY =
sig
  type Displayable
  type Counted
  val display : Displayable -> Counted -> string 
  val is_game_over : Displayable -> bool
end

functor DisplayFn (structure S : SQUARE structure G : GRID) : DISPLAY =
struct

  type Displayable = S.Square G.Grid
  type Counted = int G.Grid
  
  (* Returns true if a mine has been revealed by the player. *)
  fun is_game_over g = G.exists S.is_mined g 
 
  (* Returns the characters representing x-coordinates. *)
  fun top_line x_size = 
    let
      val letters = "abcdefghijklmnopqrstuvwxyz"
    in
      "   " ^ String.substring(letters, 0, x_size) ^ "\n"
    end

  (* Returns a string representing a y-coordinate. *)
  fun row_prefix y =
    let
      val shown = y + 1
      val coord = Int.toString(shown) ^ " "
    in
      if shown >= 10 then coord else " " ^ coord 
    end

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
      val gutter = if x = 0 then row_prefix y else ""
    in
      gutter ^ revealed square count
      (*if S.is_revealed square then revealed square count else "."*)
    end

  (* Returns the string representation of the grid. *)
  fun display grid counts =
    let
      val (x_size, y_size) = G.size grid
      fun invert (x, y) = (x_size - 1 - x, y_size - 1 - y)
      fun present x y = presentation grid counts (invert (x, y))
      fun raster 0 0 s = s ^ (present 0 0) ^ "\n"
        | raster 0 y s = raster (x_size - 1) (y - 1) (s ^ (present 0 y) ^ "\n")
        | raster x y s = raster (x - 1) y (s ^ (present x y))
    in
      raster (x_size - 1) (y_size - 1) (top_line x_size) 
    end

end

