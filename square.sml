signature SQUARE =
sig
  type Square
  val Make        : bool * bool -> Square
  val is_mined    : Square -> bool
  val is_revealed : Square -> bool
  val mine        : Square -> Square
  val reveal      : Square -> Square
end

structure Square: SQUARE =
struct
  type Square = {is_mined: bool, is_revealed: bool}
  fun Make(m : bool, r : bool) = {is_mined = m, is_revealed = r}

  fun is_mined(sq : Square) = #is_mined sq
  fun is_revealed(sq : Square) = #is_revealed sq

  fun mine(sq : Square) = {is_mined = true, is_revealed = is_revealed sq}
  fun reveal(sq : Square) = {is_mined = is_mined sq, is_revealed = true}
end

