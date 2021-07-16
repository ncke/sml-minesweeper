signature GRID =
sig
  type 'a Grid
  val Make  : int -> int -> 'a -> 'a Grid
  val get   : 'a Grid -> int -> int -> 'a
  val set   : 'a Grid -> int -> int -> 'a -> 'a Grid
  val size  : 'a Grid -> int * int
  val valid : 'a Grid -> int * int -> bool
end

structure Grid: GRID =
struct

  type 'a Grid = 'a list list

  (* Construct a grid of x, y dimension. *)
  fun Make x y a = 
    let
      fun repeat 0 z = []
        | repeat n z = z :: repeat (n - 1) z
    in
      repeat y (repeat x a)
    end

  (* Get the item at the x, y coordinate. *)
  fun get (g : 'a Grid) x y = List.nth(List.nth(g, x), y)

  (* Returns a grid, setting the item at the x, y coordinate. *)
  fun set (g : 'a Grid) x y a =
    let 
      fun replace l n v = List.take(l, n) @ v :: List.drop(l, n + 1)
      val row = List.nth(g, y)
    in
      replace g y (replace row x a)
    end

  (* Returns the dimensions of the grid. *)
  fun size (g : 'a Grid) = (length (hd g), length g)

  (* Determines whether x, y is a valid coordinate inside the grid. *)
  fun valid (g : 'a Grid) (x, y) =
    let 
      val (x_size, y_size) = size g
    in
      x >= 0 andalso y >= 0 andalso x < x_size andalso y < y_size
    end

end

