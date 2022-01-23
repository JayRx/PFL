% get_cell(+ColumnI, +RowI, +GameState, ?Cell)
% Gets the current value in cell [RowI][ColumnI] or checks if the cell value is equal to Cell
get_cell(ColumnI, RowI, GameState, Cell) :-
  get_row(RowI, GameState, Row),
  get_column(ColumnI, Row, Cell).

% get_row(+RowI, +Board, -Row)
% Auxiliary predicate to get_cell(+ColumnI, +RowI, +GameState, ?Cell)
% Gets the nth Row from the Board (GameState).
get_row(0, [Row|_], Row).
get_row(RowI, [_|Board], Row) :-
  RowI > 0,
  RowI2 is RowI - 1,
  get_row(RowI2, Board, Row).

% get_column(+ColumnI, +Board, -Column)
% Auxiliary predicate to get_cell(+ColumnI, +RowI, +GameState, ?Cell)
% Gets the nth Column from the given Row
get_column(0, [Column|_], Column).
get_column(ColumnI, [_|Board], Column) :-
  ColumnI > 0,
  ColumnI2 is ColumnI - 1,
  get_column(ColumnI2, Board, Column).

% change_list_value(+L, +Pos, +Value, -NL)
% Auxiliary predicate to change_cell(+ColumnI, +RowI, +GameState, +Value, -NGameState)
% Changes the nth (Pos) value from the list L to Value and returns a new list with the new value
change_list_value(L, Pos, Value, NL) :-
  append(L1, L3, L),
  length(L1, Pos),
  append(L4, L2, L3),
  length(L4, 1),
  append(L1, [Value|L2], NL).

% change_cell(+ColumnI, +RowI, +GameState, +Value, -NGameState)
% Changes the cell [RowI][ColumnI] value from the GameState to Value and returns a new GameState with the new value
change_cell(ColumnI, RowI, GameState, Value, NGameState) :-
  get_row(RowI, GameState, Row),
  change_list_value(Row, ColumnI, Value, NRow),
  change_list_value(GameState, RowI, NRow, NGameState).

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

% check_cells_in_between(+Player, +ColumnI, +RowI, +ColumnIN, +RowIN, +GameState)
% Checks if the cells between [RowI][ColumnI] and [RowIN][ColumnIN] (following a straight line movement - vertically, horizontally or diagonally) are filled with the same Player's pieces or are blank ('-')
check_cells_in_between(_, Column, Row, Column, Row, _).
check_cells_in_between(Player, ColumnI, RowI, ColumnIN, RowIN, GameState) :-
  [ColumnI, RowI] \= [ColumnIN, RowIN],
  between(0, 7, ColumnI),
  between(0, 7, RowI),
  MovementColumn is ColumnIN - ColumnI,
  MovementRow is RowIN - RowI,
  divideAbs(MovementColumn, CMove),
  divideAbs(MovementRow, RMove),
  Column is ColumnI + CMove,
  Row is RowI + RMove,
  check_cells_in_between(Player, Column, Row, ColumnIN, RowIN, GameState),
  (
    get_cell(ColumnI, RowI, GameState, Player)
  ;
    get_cell(ColumnI, RowI, GameState, '-')
  ).

% get_movement_cells(+ColumnI, +RowI, +MovementColumnDir, +MovementRowDir, +GameState, -Counter)
% Counts the total number of pieces found in the movement line represented by MovementRowDir and MovementColumnDir passing by the cell [RowI][ColumnI]
get_movement_cells(ColumnI, RowI, MovementColumnDir, MovementRowDir, GameState, Counter) :-
  length(GameState, BoardSize),
  ColumnI2 is ColumnI + MovementColumnDir,
  RowI2 is RowI + MovementRowDir,
  count_movement_cells(ColumnI2, RowI2, MovementColumnDir, MovementRowDir, GameState, BoardSize, Counter1),
  count_movement_cells(ColumnI, RowI, -MovementColumnDir, -MovementRowDir, GameState, BoardSize, Counter2),
  Counter is Counter1 + Counter2.

% count_movement_cells(+ColumnI, +RowI, +MovementColumnDir, +MovementRowDir, +GameState, +BoardSize, -Counter)
% Auxiliary predicate to get_movement_cells(+ColumnI, +RowI, +MovementColumnDir, +MovementRowDir, +GameState, -Counter)
% Counts the total number of pieces found in the movement line represented by MovementRowDir and MovementColumnDir starting in the cell [RowI][ColumnI]
count_movement_cells(ColumnI, RowI, MovementColumnDir, MovementRowDir, GameState, BoardSize, Counter) :-
  ColumnI >= 0,
  RowI >= 0,
  ColumnI < BoardSize,
  RowI < BoardSize,
  \+ get_cell(ColumnI, RowI, GameState, '-'),
  ColumnI2 is ColumnI + MovementColumnDir,
  RowI2 is RowI + MovementRowDir,
  count_movement_cells(ColumnI2, RowI2, MovementColumnDir, MovementRowDir, GameState, BoardSize, Counter2),
  Counter is Counter2 + 1.

count_movement_cells(ColumnI, RowI, MovementColumnDir, MovementRowDir, GameState, BoardSize, Counter) :-
  ColumnI >= 0,
  RowI >= 0,
  ColumnI < BoardSize,
  RowI < BoardSize,
  ColumnI2 is ColumnI + MovementColumnDir,
  RowI2 is RowI + MovementRowDir,
  count_movement_cells(ColumnI2, RowI2, MovementColumnDir, MovementRowDir, GameState, BoardSize, Counter).

count_movement_cells(_, _, _, _, _, _, 0).

% validate_movement(?Movement, ?Movement)
% Checks if a given movement is correct. It only accepts horizontal, vertical and diagonal movements
validate_movement(Movement, Movement).
validate_movement(0, _).
validate_movement(_, 0).

% count_pieces(+Player, +GameState, -Pieces)
% Counts the number of Pieces the given Player has in the given GameState
count_pieces(_, [], 0).

count_pieces(Player, [Row|GameState], Pieces) :-
  count_pieces(Player, GameState, Pieces2),
  count_pieces_row(Player, Row, PiecesRow),
  Pieces is Pieces2 + PiecesRow.

% count_pieces_row(+Player, +Row, -Pieces)
% Auxiliary predicate to count_pieces(+Player, +GameState, -Pieces)
% Counts the number of Pieces the given Player has in the given Row
count_pieces_row(_, [], 0).

count_pieces_row(Player, [Player|Row], Pieces) :-
  count_pieces_row(Player, Row, Pieces2),
  Pieces is Pieces2 + 1.

count_pieces_row(Player, [Cell|Row], Pieces) :-
  Cell \= Player,
  count_pieces_row(Player, Row, Pieces).

% get_piece_occorrunces(+Player, +GameState, -ColumnI, -RowI)
% Auxiliary predicate to check_all_pieces_together(+Player, +GameState)
% Gets all given Player's pieces positions [RowI][ColumnI] one by one
get_piece_occorrunces(Player, GameState, ColumnI, RowI) :-
  nth0(RowI, GameState, Row),
  member(Player, Row),
  nth0(ColumnI, Row, Player).

% path_to_all(+First, +Occorrunces, +GameState, +Player)
% Auxiliary predicate to check_all_pieces_together(+Player, +GameState)
% Checks if the given First Piece has a valid path to all the other pieces in the Occorrunces list only following cells with the given Player's pieces
path_to_all(_, [], _, _).
path_to_all(First, [First|Occorrunces], GameState, Player) :-
  path_to_all(First, Occorrunces, GameState, Player).
path_to_all(First, [Cell|Occorrunces], GameState, Player) :-
  path_to_all(First, Occorrunces, GameState, Player),
  path(First, Cell, GameState, Player).

% path(+A, +B, +GameState, +Player)
% Auxiliary predicate to path_to_all(+First, +Occorrunces, +GameState, +Player)
% Checks if A has a valid path to B only following cells with the given Player's pieces
path(A, B, GameState, Player) :-
    walk(A, B, [], GameState, Player).

% walk(+[Column,Row], +B, +V, +GameState, +Player)
% Auxiliary predicate to path(+A, +B, +GameState, +Player)
% Checks if [Column,Row] has a valid path to B only following cells with the given Player's pieces
walk([Column,Row], B, V, GameState, Player) :-
    edge([Column,Row],X, 8),
    \+ member(X,V),
    get_cell(Column, Row, GameState, Player),
    (
      B = X
    ;
      walk(X, B, [[Column,Row]|V], GameState, Player)
    ).

% edge(+A, +B, +Size)
% Auxiliary predicate to walk(+[Column,Row], +B, +V, +GameState, +Player)
% Checks if the Cell A has an edge to the Cell B in a Board with a given Size
edge([X,Y], [X1,Y], Size) :-
    X1 is X + 1,
    X1 < Size.
edge([X,Y], [X,Y1], Size) :-
    Y1 is Y + 1,
    Y1 < Size.
edge([X,Y], [X1,Y1], Size) :-
    X1 is X + 1,
    Y1 is Y + 1,
    X1 < Size,
    Y1 < Size.
edge([X,Y], [X1,Y], _) :-
    X1 is X - 1,
    X1 >= 0.
edge([X,Y], [X,Y1], _) :-
    Y1 is Y - 1,
    Y1 >= 0.
edge([X,Y], [X1,Y1], _) :-
    X1 is X - 1,
    Y1 is Y - 1,
    X1 >= 0,
    Y1 >= 0.
edge([X,Y], [X1,Y1], Size) :-
    X1 is X + 1,
    Y1 is Y - 1,
    X1 < Size,
    Y1 >= 0.
edge([X,Y], [X1,Y1], Size) :-
    X1 is X - 1,
    Y1 is Y + 1,
    X1 >= 0,
    Y1 < Size.

% check_all_pieces_together(+Player, +GameState)
% Checks if all the given Player's pieces are together in a single group in the given GameState
check_all_pieces_together(Player, GameState) :-
  setof([Column,Row], get_piece_occorrunces(Player, GameState, Column, Row), Occorrunces),
  nth0(0, Occorrunces, [FirstColumn,FirstRow]),
  path_to_all([FirstColumn,FirstRow], Occorrunces, GameState, Player).
