:-consult('board_creation.pl').
:-consult('board_print.pl').
:-consult('menu.pl').
:-use_module(library(lists)).
:-use_module(library(system)).

play :-
  menu,
  initial_state(8, GameState),
  printBoard(GameState),
  menu_ask_option.

initial_state(Size, GameState) :-
  createBoard(Size, Size, GameState).
