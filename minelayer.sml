signature MINELAYER =
sig
  type Mineable 
  val lay_mines : Mineable * int * int * int -> Mineable
end

functor MineLayer (structure S : SQUARE structure G : GRID) :> MINELAYER =
struct
  type Mineable = S.Square G.Grid

  fun rand_generators(g, s1, s2) =
    let
      val gen = Random.rand(s1, s2)
      val sz = G.size(g)
      val x_range = Random.randRange(0, (#1 sz) - 1)
      val y_range = Random.randRange(0, (#2 sz) - 1)
    in
      (fn() => x_range gen, fn() => y_range gen)
    end 

  fun avail_coord(g, x_gen, y_gen) =
    let
      val x = x_gen()
      val y = y_gen()
      val is_unmined = not(S.is_mined(G.get(g, x, y)))
    in
      if is_unmined then (x, y) else avail_coord(g, x_gen, y_gen)
    end 
    
  fun emplace(g, x_gen, y_gen) = 
    let
      val (x, y) = avail_coord(g, x_gen, y_gen)
    in
      G.set(g, x, y, S.mine(G.get(g, x, y)))
    end

  fun lay_mines(g : S.Square G.Grid, n, s1, s2) =
    let 
      val (x_gen, y_gen) = rand_generators(g, s1, s2)
      fun lay_mine(g, 0) = g
        | lay_mine(g, n) = lay_mine(emplace(g, x_gen, y_gen), n - 1)
    in
      lay_mine(g, n)
    end

end
    
