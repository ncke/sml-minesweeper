# sml-minesweeper
An implementation of Minesweeper in Standard ML.

Minesweeper is written in Standard ML; it will run in the SML/NJ REPL.

## Setting up minesweeper.
Compile minesweeper modules:
`CM.make("sources.cm");`

Set up the Game structure:
`structure Game = GameFn(structure S=Square structure G=Grid);`

## Starting a new game.
To start a new game:
`val gm = Game.New (w, h) m (s1, s2);`
- `(w, h)` gives the width and height of the desired game (max 26x26).
- `m` denotes the number of mines to populate in the grid.
- `s1, s2` are arbitrary integers used to seed random number generation.

Examples:
- 10x10 grid, 15 mines: `val gm = Game.New (10,10) 15 (100,200);`
- 20x20 grid, 30 mines: `val gm = Game.New (20,20) 30 (100,200);`
- 25x25 grid, 60 mines: `val gm = Game.New (25,25) 60 (100,200);`

## Playing moves.
The objective of the game is to mark the location of all the mines on the grid and reveal all of the unmined squares. Be careful not to reveal a mine, or it's game over!

### Viewing the grid.
`Game.show gm;`
To see the current state of the grid

The game starts with entirely unexplored territory.
```
   ABCDEFGHIJ
 1 ..........
 2 ..........
 3 ..........
 4 ..........
 5 ..........
 6 ..........
 7 ..........
 8 ..........
 9 ..........
10 ..........

15 mines remainng to find.
```
After a few moves, the pattern starts to emerge.
```
   ABCDEFGHIJ
 1 1?21 1....
 2 23?1 112..
 3 1?21   1.1
 4 111    111
 5    111
 6  112?11121
 7  2........
 8 13........
 9 ........21
10 ........1

11 mines remainng to find.
```
Key to the grid:
- `.`: Unexplored squares are marked on the grid using a full stop.
- `3`: A number indicates how many of this squares immediate neighbours are mined.
- `?`: Shows a square that you have marked as being mined.
- ` `: Shows open sea, revealed squares that have no neighbouring mines.
- `X`: Shows a revealed mine 💥.

### Revealing a square.
`val gm = Game.reveal gm "G5";`
`Game.show gm;`

```
   ABCDEFGHIJ
 1 ...1 1....
 2 ...1 112..
 3 ..21   1..
 4 111    111
 5    111
 6  112.11121
 7  2........
 8 13........
 9 ..........
10 ..........

15 mines remainng to find.
```

### Marking a square as mined.
`val gm = Game.mark gm "C2";`
`Game.show gm;`
The mark function will place a marker above a grid square to indicate that it is believed to be mined. Callling the mark function on a marked square will toggle the marker off.
```
   ABCDEFGHIJ
 1 ...1 1....
 2 ..?1 112..
 3 ..21   1..
 4 111    111
 5    111
 6  112.11121
 7  2........
 8 13........
 9 ..........
10 ..........

14 mines remainng to find.
```

## Resources.

SML/NJ Fellowship (2017) 'Standard ML of NJ User's Guide'. Available at https://www.smlnj.org/doc/index.html
