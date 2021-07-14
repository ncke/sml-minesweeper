signature MINELAYER =
sig
  type Mineable 
  val lay_mines : Mineable -> int -> int -> int -> Mineable
end

functor MineLayerFn (structure S : SQUARE structure G : GRID) :> MINELAYER =
struct

  type Mineable = S.Square G.Grid

  (* Returns a pair of generator functions for random coordinates. *)
  fun rand_generators g s1 s2 =
    let
      val gen = Random.rand(s1, s2)
      val (x_size, y_size) = G.size(g)
      val x_range = Random.randRange(0, x_size - 1)
      val y_range = Random.randRange(0, y_size - 1)
    in
      (fn() => x_range gen, fn() => y_range gen)
    end 

  (* Returns the coordinates of an unmined square. *)
  fun avail_coord g (x_gen, y_gen) =
    let
      val (x, y) = (x_gen(), y_gen())
      val square = G.get g x y
      val is_unmined = not (S.is_mined square) 
    in
      if is_unmined then (x, y) else avail_coord g (x_gen, y_gen)
    end 
    
  (* Returns a grid containing a newly mined square. *)
  fun emplace g generators = 
    let
      val (x, y) = avail_coord g generators 
      val square = G.get g x y
    in
      G.set g x y (S.mine square) 
    end

  (* Adds n mines to the grid, using s1 and s2 as random seeds. *)
  fun lay_mines (g : Mineable) n s1 s2 =
    let 
      val generators = rand_generators g s1 s2
      fun lay_mine g 0 = g
        | lay_mine g n = lay_mine (emplace g generators) (n - 1)
    in
      lay_mine g n
    end

end
    
