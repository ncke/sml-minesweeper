signature SQUARE =
sig
  type Square
  val Empty       : unit -> Square
  val is_mined    : Square -> bool
  val is_revealed : Square -> bool
  val mine        : Square -> Square
  val reveal      : Square -> Square
end

structure Square: SQUARE =
struct
  
  type Square = {is_mined: bool, is_revealed: bool}

  (* Construct an ab initio square. *)
  fun Empty() = {is_mined = false, is_revealed = false}

  (* Determine whether the square contains a mine. *)
  fun is_mined (sq : Square) = #is_mined sq

  (* Determine whether the square is revealed to the player. *)
  fun is_revealed (sq : Square) = #is_revealed sq

  (* Returns the square set as containing a mine. *)
  fun mine (sq : Square) = {is_mined = true, is_revealed = is_revealed sq}

  (* Returns the square set as revealed to the player. *)
  fun reveal (sq : Square) = {is_mined = is_mined sq, is_revealed = true}

end

