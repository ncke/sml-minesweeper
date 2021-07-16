signature GAME = 
sig
  type Game
  val New : (int * int) -> int -> (int * int) -> Game
  val show : Game -> unit
end

functor GameFn (
  structure S : SQUARE 
  structure G : GRID 
) :> GAME =
struct

  type Game = {
    grid : S.Square G.Grid,
    counts : int G.Grid
  }

  structure MineLayer = MineLayerFn (structure S = S structure G = G)
  
  structure Neighbours = NeighboursFn (structure S = S structure G = G)

  structure Display = DisplayFn (structure S = S structure G = G)

  fun New (x_size, y_size) mine_count (seed_1, seed_2) =
    let
      val blank_grid = G.Make x_size y_size (S.Empty())
      val mined_grid = MineLayer.lay_mines blank_grid mine_count seed_1 seed_2
      val count_grid = Neighbours.Count mined_grid
    in
      { grid = mined_grid, counts = count_grid }
    end
 
  fun show (game : Game) =
    print(Display.display (#grid game) (#counts game))

end

