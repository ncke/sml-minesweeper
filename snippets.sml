val gr = Grid.Make 10 10 (Square.Empty());

structure MLay = MineLayerFn(structure S=Square structure G=Grid);

val mgr = MLay.lay_mines gr 25 100 200;

structure Disp = DisplayFn(structure S=Square structure G=Grid);

structure Neigh = NeighboursFn(structure S=Square structure G=Grid);

val cgr = Neigh.Count mgr;

structure Disp = DisplayFn(structure S=Square structure G=Grid);

print(Disp.display mgr cgr);





structure Game = GameFn(structure S=Square structure G=Grid);

val gm = Game.New (10,10) 25 (100,200);

val gm = Game.New (20,20) 10 (100,200);

Game.show gm;

val gm = Game.play gm "B2";






val dbg = "(" ^ Int.toString(ax) ^ ", " ^ Int.toString(ay) ^ ") "


0X0000XX0X
00X0000X00



structure Search = SearchFn (structure S=Square structure G=Grid);

(*)
  fun should_reveal_square sq = not (S.is_mined sq)
 
  fun should_recurse_square sq = 
    not (S.is_mined sq) andalso not (S.is_revealed sq)
  
  fun unvisited_neighbours g visited coord =
    let
      val (x, y) = coord
      val neighbours = G.adjacent g x y
      val is_same_coord = fn j => (fn k => j = k)
      fun is_unvisited n = not (List.exists (is_same_coord n) visited)
    in
      List.filter is_unvisited neighbours
    end

  fun search_coords g visited reveals [] = reveals
    | search_coords g visited reveals (coord :: prospects) =
        let
          val (x, y) = coord
          val sq = G.get g x y
          val reveal_sq = should_reveal_square sq
          val recurse_sq = should_recurse_square sq
          val next_visited = coord :: visited
          val next_reveals = if reveal_sq then coord :: reveals else reveals
          val next_unvisited = unvisited_neighbours g visited coord
          val next_prospects = if recurse_sq then prospects @ next_unvisited else prospects
        in
          search_coords g next_visited next_reveals next_prospects
        end
*)

