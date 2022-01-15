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
  menu_ask_option(ColumnI, RowI),
  format('Column: ~w Row: ~w\n', [ColumnI, RowI]),
  get_cell(ColumnI, RowI, GameState, Cell),
  format('Cell [~w][~w]: ~w\n', [RowI, ColumnI, Cell]),
  change_cell(ColumnI, RowI, GameState, '0', NGameState),
  printBoard(NGameState).

initial_state(Size, GameState) :-
  createBoard(Size, Size, GameState).
