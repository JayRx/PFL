# Lines of Action

## 1 - Game and Group Identification
Group: Lines of Action_1
Made By:
- João Paulo Silva da Rocha (up201806261) - 50%
- Lara Machado de Medicis (up201806762) - 50%

## 2 - Instalation and Execution
- Download the code.
- Consult the 'lines_of_action.pl' file in SICSTUS.
- Run the 'play' predicate.

## 3 - Game Description
Lines of Action is a strategy board game for two players invented by Claude Soucie.
The objective of the game is to connect all of one player's pieces into a single group.
It is played in an 8x8 checkers board and the players can move the pieces any number of squares in the same direction (horizontally, vertically or diagonally).

### 3.1 - Start of the game
- Black moves first. Each player moves one of his pieces in every turn.

### 3.2 - Moves
- Pieces are moved in a straight line (vertical, horizontal or diagonal), exactly as many squares as there are pieces of either colour anywhere along the line of movement.
- Moved piece cannot land on a square occupied by one piece of the same colour. However, opponent pieces can be captured by landing on them.
- Moved piece may jump over pieces of the same colour, but not over opponent pieces.

### 3.3 - End of the game
- Game may be won with an own move or an opponent move, if the opponent makes a capture leaving an only group of pieces; particularly, if one player is reduced by captures (11) to a single piece, that is a win for the captured player (a single piece, obviously, makes a single group).
- If a move simultaneously creates a win for both players, the player who has made the move is the winner.

Sources of information:
- [Lines of Action - Wikipedia](https://en.wikipedia.org/wiki/Lines_of_Action)
- [Lines of Action - Rules](https://www.ludoteka.com/clasika/lines-of-action.html)

## 4 - Game Logic
### 4.1 - Game State Representation
The Game State is represented by a matrix with the dimensions of the playing board. The Black player pieces are represented by 'B', the White player pieces by 'W' and the blank cells represented by '-'.

The following screenshot is a representation of the initial Game State:

![Initial GameState](https://i.imgur.com/5GPwSDC.png)

As we can see, we above the Black pieces on the top and bottom rows and the White pieces in the other rows.

The following screenshot is a representation of a Game State in the middle of a game:

![Mid GameState](https://i.imgur.com/hTfHybj.png)

We can also observe the Black player's board value and the move the White player will make next.

The following screenshot is a representation of a final Game State:

![Final GameState](https://i.imgur.com/6x0ddDE.png)

As we can see, all black pieces are together so the Black player won the game.

### 4.2 - Game State Visualization
To visualize the Game State we implemented a predicate that with the help of auxiliary predicates diplays all the important Game State information. This information contains row and column indicators and values of each cell ('B', 'W' or '-').

The following code shows the stated predicates:
``` prolog
% display_game(+GameState)
% Displays the given GameState with column and row indicators
display_game(GameState) :-
  nl,nl,
  print('    A B C D E F G H '), nl,
  print('   -----------------'), nl,
  printBoard_aux(GameState, 1),
  print('   -----------------'),
  nl,nl.

% printBoard_aux(Board, N)
% Auxiliary predicate to display_game(+GameState)
% Displays the given Board with row indicators
printBoard_aux([], _).
printBoard_aux([Row|Board], N) :-
  print(N),
  print(' | '),
  printRow(Row),
  print('|'),
  nl,
  N2 is N + 1,
  printBoard_aux(Board, N2).

% printRow(+Row)
% Auxiliary predicate to printBoard_aux(Board, N)
% Displays the given Row
printRow([]).
printRow([X|Row]) :-
  format('~w ', [X]),
  printRow(Row).
```

We also created a predicate that creates the board's initial state based on the dimensions we want for it. This way we can create a board with any size we want without changing anything, as we can see below:
``` prolog
% createBoard(+Size, +Size, -GameState)
% Creates the initial GameState for the Lines of Action game with a board with the given dimensions (Size)
createBoard(0, _, []).
createBoard(1, Size, GameState) :-
  createBoard(0, Size, NGameState),
  createRow('B', Size, Size, Row),
  append(NGameState, [Row], GameState).
createBoard(Size, Size, GameState) :-
  Size > 1,
  NSize is Size - 1,
  createBoard(NSize, Size, NGameState),
  createRow('B', Size, Size, Row),
  append(NGameState, [Row], GameState).
createBoard(Aux, Size, GameState) :-
  Aux > 1,
  NAux is Aux - 1,
  createBoard(NAux, Size, NGameState),
  createRow('W', Size, Size, Row),
  append(NGameState, [Row], GameState).

% createRow(+Player, +Size, +SizeAux, -Row)
% Auxiliary predicate to createBoard(+Size, +Size, -GameState)
% Creates a row based on the positions it will have in the board. If it's the first or last row it will have Black pieces and empty cells, otherwise it will have White pieces and empty cells
createRow('W', 1, _, ['W']).
createRow('W', Size, SizeAux, Row) :-
  Size > 1,
  Size == SizeAux,
  NSize is Size - 1,
  createRow('W', NSize, SizeAux, NRow),
  append(NRow, ['W'], Row).
createRow('W', Size, SizeAux, Row) :-
  Size > 1,
  Size \== SizeAux,
  NSize is Size - 1,
  createRow('W', NSize, SizeAux, NRow),
  append(NRow, ['-'], Row).

createRow('B', 1, _, ['-']).
createRow('B', Size, SizeAux, Row) :-
  Size > 1,
  Size == SizeAux,
  NSize is Size - 1,
  createRow('B', NSize, SizeAux, NRow),
  append(NRow, ['-'], Row).
createRow('B', Size, SizeAux, Row) :-
  Size > 1,
  Size \== SizeAux,
  NSize is Size - 1,
  createRow('B', NSize, SizeAux, NRow),
  append(NRow, ['B'], Row).
```

### 4.3 - Moves Execution
When it's time to move a piece, the program firstly asks the user from where and to where he wants to move a certain piece. Then, it validates the starting and ending positions and finally checks it is a valid move.
For a move to be valid all the following clauses must be true:
- Starting position must have a piece of the current player.
- Movement needs to be horizontal, vertical or diagonal only.
- Ending position must not have a piece of the current player.
- A piece has to move exactly the same number of cells as the number of pieces found in the line of direction.
- A piece must not jump over other player's pieces.

In the following code we have a representation of the predicate that validates a move:
``` prolog
% validate_move(+Player, +ColumnI, +RowI, +ColumnIN, +RowIN, +GameState)
% Validates the move from [RowI][ColumnI] to [RowIN][ColumnIN] in the given GameState following the rules of Lines of Action
validate_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState) :-
  MovementColumn is ColumnIN - ColumnI,
  MovementRow is RowIN - RowI,
  MovementColumnAbs is abs(MovementColumn),
  MovementRowAbs is abs(MovementRow),
  validate_movement(MovementColumn, MovementRow),
  divideAbs(MovementColumn, MovementColumnDir),
  divideAbs(MovementRow, MovementRowDir),
  get_movement_cells(ColumnI, RowI, MovementColumnDir, MovementRowDir, GameState, Counter1),
  Counter2 is max(MovementColumnAbs, MovementRowAbs),
  !,
  Counter1 == Counter2,
  check_cells_in_between(Player, ColumnI, RowI, ColumnIN, RowIN, GameState).
```

After we validate the given move, we change the starting position to an empty cell and the ending position to the player's piece. This is what the following predicate does:
``` prolog
% move(GameState, Move, NewGameState)
% Validates the given Move and returns a NewGameState
move(GameState, Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo), NewGameState) :-
  validate_move(Player, ColumnFrom, RowFrom, ColumnTo, RowTo, GameState),
  change_cell(ColumnFrom, RowFrom, GameState, '-', GameStateAux),
  change_cell(ColumnTo, RowTo, GameStateAux, Player, NewGameState).
```

### 4.4 - End of the Game
To verify if the game is over we need to detect, for each player, if all his pieces are together forming only one group or if he only has one piece left in the game. If the player only has one piece left it also means that all his pieces are together.

Here is the predicate that executes the respecting code:
``` prolog
% game_over(+GameState, +Player)
% Checks if it's Game Over in the given GameState for the given Player
game_over(GameState, 'B') :-
  check_all_pieces_together('B', GameState).
```

### 4.5 - All Available Moves
We created a predicate that returns all the available moves in the given Game State. We can use this value to see if there are any moves left to make.

Below we can see how this predicate is implemented:
``` prolog
% valid_moves(+GameState, -ListOfMoves)
% Gets all the Moves possible
% Move is represented by: Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
valid_moves(GameState, ListOfMoves) :-
  setof('B'-(ColumnI, RowI)-(ColumnIN, RowIN), get_bot_move('B', ColumnI, RowI, ColumnIN, RowIN, _, GameState), ListOfMovesBlack),
  setof('W'-(ColumnI2, RowI2)-(ColumnIN2, RowIN2), get_bot_move('W', ColumnI2, RowI2, ColumnIN2, RowIN2, _, GameState), ListOfMovesWhite),
  append(ListOfMovesBlack, ListOfMovesWhite, ListOfMoves).
```

As we can see, it uses the setof predicate to get a list of valid moves of each player and then it joins both into a single list that will contain every possible valid move in the game.

### 4.6 - Game State Evaluation
To evaluate the current Game State we simply count all the player's pieces and retrive a value based on that.
Because the objective of the game is to have all pieces grouped, the less pieces we have, the ammount of effort is needed to group all the pieces.

We could also add to this evaluation the number of groups of the player's pieces and how distant they are from each other. In our point of view, if we have more groups, more difficult it is to have a single group. The same justification goes for the distance between the group, whenever the groups are more distant, more difficult it is to have a single group.

The following code block represents the implemented predicate that retrieves a player's board score:
``` prolog
% value(+GameState, +Player, -Value)
% Calculates the Player's board Value in the given GameState
value(GameState, Player, Value) :-
  count_pieces(Player, GameState, Pieces),
  ValueLog is log(12/Pieces),
  Value is ValueLog * 42.
```

### 4.7 - Computer Moves
Whenever the computer wants to make move, it initally calculates all the moves it can make and it's value.
Each move with value is represented by Value-Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo).

Here we can see the retrieval of the previous stated information:
``` prolog
% choose_move(+Player, +GameState, +Level, -Move)
% Depending on the given Bot's Level chooses the move it will make
% Move is represented by: Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
choose_move(Player, GameState, 1, Move) :-
  setof(Value-Player-(ColumnI, RowI)-(ColumnIN, RowIN), get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, Value, GameState), Moves),
  random_member(MoveAux, Moves),
  get_move(MoveAux, Move).

choose_move(Player, GameState, 2, Move) :-
  setof(Player-(ColumnI, RowI)-(ColumnIN, RowIN), get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState), Moves),
  last(Moves, MoveAux),
  get_move(MoveAux, Move).

% get_move(+MoveWithValue, -Move)
% Parses MoveWithValue and extracts the Move from it
% MoveWithValue is represented by: Value-Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
% Move is represented by: Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
get_move(_-Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo), Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)).

% get_bot_move(+Player, +ColumnI, +RowI, +ColumnIN, +RowIN, +Value, +GameState)
% This predicate is used to get all the Moves a Bot (Player) can make and it's associated board value
% MoveWithValue is represented by: Value-Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
% Move is represented by: Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, Value, GameState) :-
  between(0, 7, ColumnI),
  between(0, 7, RowI),
  between(0, 7, ColumnIN),
  between(0, 7, RowIN),
  get_cell(ColumnI, RowI, GameState, Player),
  \+get_cell(ColumnIN, RowIN, GameState, Player),
  validate_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState),
  move(GameState, Player-(ColumnI, RowI)-(ColumnIN, RowIN), NGameState),
  value(NGameState, Player, Value).
```

Then the Level 1 Computer Bot will randomly choose a move from the available moves list.
The Level 2 Computer Bot will get the last move from the available moves list which is the move that improves his overall score because the list is ordenated from lowest to biggest values.

## 5 - Conclusions
With the development of this project we improved our knowledge about Prolog and implemented many topics talked in the course's classes.
One downside of making a game using Prolog is the limited visual representation that SICStus Prolog offers.
Although could be improved in terms of efficiency, we implemented everything enumerated in the project paper in a way that it all works.
For future work, we could:
- Improve the code's efficiency to make the program run more smoothly.
- Implement a graphic design using other programming language (Example: using PyGame with Python) and make calls to the project's Prolog predicates to run the Lines of Action game.
- Change the Game State evaluation predicate to represent a more viable and accurate Game State value.

## 6 - Bibliography
- [Lines of Action - Wikipedia](https://en.wikipedia.org/wiki/Lines_of_Action)
- [Lines of Action - Rules](https://www.ludoteka.com/clasika/lines-of-action.html)
- [SICStus built-in predicates](https://sicstus.sics.se/sicstus/docs/3.7.1/html/sicstus_10.html)
