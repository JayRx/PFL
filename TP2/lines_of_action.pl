:-consult('board_creation.pl').
:-consult('board_print.pl').
:-use_module(library(lists)).
:-use_module(library(system)).

play :-
  initial_state(8, GameState),
  printBoard(GameState).

initial_state(Size, GameState) :-
  createBoard(Size, Size, GameState).
