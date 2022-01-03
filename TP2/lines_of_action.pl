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
  get_cell(0, 1, GameState, Cell),
  format('Cell [~w][~w]: ~w\n', [0, 1, Cell]).

initial_state(Size, GameState) :-
  createBoard(Size, Size, GameState).
