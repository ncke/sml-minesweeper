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

val gm = Game.reveal gm "B2";






val dbg = "(" ^ Int.toString(ax) ^ ", " ^ Int.toString(ay) ^ ") "


0X0000XX0X
00X0000X00


