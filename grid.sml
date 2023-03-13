signature GRID =
sig
  type 'a Grid
  val Make   : int -> int -> 'a -> 'a Grid
  val get    : 'a Grid -> int -> int -> 'a
  val set    : 'a Grid -> int -> int -> 'a -> 'a Grid
  val size   : 'a Grid -> int * int
  val valid  : 'a Grid -> int * int -> bool
  val exists : ('a -> bool) -> 'a Grid -> bool
  val count  : ('a -> bool) -> 'a Grid -> int
  val adjacent : 'a Grid -> int -> int -> (int * int) list
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
  fun get (g : 'a Grid) x y = List.nth(List.nth(g, y), x)

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

  (* Applies f to each element, returning true if encountering f is true. *)
  fun exists f [] = false
    | exists f (r :: rs) = if List.exists f r then true else exists f rs

  (* Applies f to each element, returning the count of true results. *)
  fun count f g =
    let
      fun count_row row = length (List.filter f row)
      fun inner [] = 0
        | inner (row :: rows) = (count_row row) + (inner rows)
    in
      inner g
    end

  (* Returns a list of coordinates for adjacent grid locations. *)
  fun adjacent g x y =
    let
      val offsets = [ (~1,~1), (0,~1), (1,~1),
                      (~1, 0),         (1, 0),
                      (~1, 1), (0, 1), (1, 1) ]
      fun add (dx, dy) = (x + dx, y + dy)
    in
      List.filter (valid g) (List.map add offsets)
    end  
        
end

