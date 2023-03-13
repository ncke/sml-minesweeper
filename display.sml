signature DISPLAY =
sig
  type 'a Grid
  type Counted
  val display : 'a Grid -> Counted -> string 
  val is_game_over : 'a Grid -> bool
end

functor DisplayFn (structure S : SQUARE structure G : GRID) : DISPLAY =
struct

  type 'a Grid = S.Square G.Grid
  type Counted = int G.Grid

  (* Returns game over as true if a mine has been revealed by the player. *)
  fun is_game_over g = 
    let
      fun is_revealed_mine sq = S.is_mined sq andalso S.is_revealed sq
    in
      G.exists is_revealed_mine g 
    end

  (* Returns the characters representing x-coordinates. *)
  fun top_line x_size = 
    let
      val letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
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

  (* Returns the string representation for an unrevealed square. *)
  fun unrevealed square =
    if S.is_marked square then "?" else "."

  (* Returns the string representation for the given coordinate. *)
  fun presentation grid counts (x, y) =
    let
      val square = G.get grid x y
      val count = G.get counts x y
      val gutter = if x = 0 then row_prefix y else ""
    in
      if S.is_revealed square 
      then gutter ^ revealed square count 
      else gutter ^ unrevealed square
    end

  (* Returns the string representation of the grid. *)
  fun display_grid grid counts =
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

  (* Returns game statistics: total mines, mines remaining to mark. *)
  fun statistics grid =
    let
      val total = G.count S.is_mined grid
      val remaining = total - G.count S.is_marked grid
    in
      (total, remaining)
    end 

  (* Returns a string representation of the game state. *)
  fun display grid counts =
    let
      val grid_str = display_grid grid counts
      val (total, remaining) = statistics grid
      val remain_str = Int.toString(remaining)
      val stats_str = "\n" ^ remain_str ^ " mines remainng to find.\n"
      val game_over = if is_game_over grid then "\nGame Over!!!\n" else ""
    in
      grid_str ^ stats_str ^ game_over
    end

end
