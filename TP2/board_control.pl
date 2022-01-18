get_cell(ColumnI, RowI, GameState, Cell) :-
  get_row(RowI, GameState, Row),
  get_column(ColumnI, Row, Cell).

get_row(0, [Row|_], Row).
get_row(RowI, [_|Board], Row) :-
  RowI > 0,
  RowI2 is RowI - 1,
  get_row(RowI2, Board, Row).

get_column(0, [Column|_], Column).
get_column(ColumnI, [_|Board], Column) :-
  ColumnI > 0,
  ColumnI2 is ColumnI - 1,
  get_column(ColumnI2, Board, Row).

change_list_value(L, Pos, Value, NL) :-
  append(L1, L3, L),
  length(L1, Pos),
  append(L4, L2, L3),
  length(L4, 1),
  append(L1, [Value|L2], NL).

change_cell(ColumnI, RowI, GameState, Value, NGameState) :-
  get_row(RowI, GameState, Row),
  change_list_value(Row, ColumnI, Value, NRow),
  change_list_value(GameState, RowI, NRow, NGameState).

validate_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState) :-
  get_cell(ColumnI, RowI, GameState, Player),
  MovementColumn is abs(ColumnIN - ColumnI),
  MovementRow is abs(RowIN - RowI),
  validate_movement(MovementColumn, MovementRow),
  get_cell(ColumnIN, RowIN, GameState, '-').

validate_movement(Movement, Movement).
validate_movement(0, _).
validate_movement(_, 0).
