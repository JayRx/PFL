:-consult('auxiliary.pl').
:-consult('board_creation.pl').
:-consult('board_print.pl').
:-consult('board_control.pl').
:-consult('menu.pl').
:-use_module(library(lists)).
:-use_module(library(system)).

play :-
  menu,
  initial_state(8, GameState),
  printBoard(GameState),
  %check_game_over(GameState),
  move_piece('B', GameState, NGameState),
  printBoard(NGameState).

initial_state(Size, GameState) :-
  createBoard(Size, Size, GameState).

move_piece(Player, GameState, NGameState) :-
  menu_ask_position('What piece do you want to move? (Ex: A1): ', ColumnI, RowI),
  get_cell(ColumnI, RowI, GameState, Cell),
  format('Column: ~w Row: ~w Cell: ~w\n', [ColumnI, RowI, Cell]),
  get_cell(ColumnI, RowI, GameState, Player),
  skip_line,
  menu_ask_position('To where do you want to move this piece? (Ex: A1): ', ColumnIN, RowIN),
  get_cell(ColumnIN, RowIN, GameState, CellN),
  format('Column: ~w Row: ~w Cell: ~w\n', [ColumnIN, RowIN, CellN]),
  get_cell(ColumnIN, RowIN, GameState, '-'),
  validate_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState),
  change_cell(ColumnI, RowI, GameState, '-', GameStateAux),
  change_cell(ColumnIN, RowIN, GameStateAux, Player, NGameState).

move_piece(Player, GameState, NGameState) :-
  skip_line,
  print('Not a valid move!\n'),
  move_piece(Player, GameState, NGameState).

check_game_over(GameState) :-
count_pieces('B', GameState, BlackPieces),
count_pieces('W', GameState, WhitePieces),
format('Black Pieces: ~w\tWhite Pieces: ~w\n', [BlackPieces, WhitePieces]).
