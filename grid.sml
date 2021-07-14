signature GRID =
sig
  type 'a Grid
  val Make : int * int * 'a -> 'a Grid
  val get : 'a Grid * int * int -> 'a
  val set : 'a Grid * int * int * 'a -> 'a Grid
  val size : 'a Grid -> int * int
  val valid : 'a Grid * int * int -> bool
end

structure Grid: GRID =
struct
  type 'a Grid = 'a list list

  fun Make(x : int, y : int, a : 'a) = 
    let fun repeat(z, 0) = []
          | repeat(z, n) = z :: repeat(z, n - 1)
    in
      repeat(repeat(a, x), y)
    end

  fun get(g : 'a Grid, x : int, y : int) = List.nth(List.nth(g, x), y)

  fun set(g : 'a Grid, x : int, y : int, a : 'a) =
    let fun replace(l, n, v) = List.take(l, n) @ v :: List.drop(l, n + 1)
    in
      replace(g, y, replace(List.nth(g, y), x, a))
    end

  fun size(g : 'a Grid) = (length (hd g), length g)

  fun valid(g : 'a Grid, x : int, y : int) =
    let val sz = size(g)
    in
      (x >= 0) andalso (y >= 0) andalso (x < #1 sz) andalso (y < #2 sz)
    end

end

