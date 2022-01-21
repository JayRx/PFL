:-use_module(library(lists)).
:-use_module(library(system)).
:-consult('auxiliary.pl').
:-consult('board_creation.pl').
:-consult('board_print.pl').
:-consult('board_control.pl').
:-consult('menu.pl').
:-consult('rules.pl').

play :-
  menu(Option),
  router(Option).

router('1') :- play('PvP').
router('2') :- play('PvB').
router('3') :- play('BvB').
router('4') :- rules.
router('5') :- print('Exiting...\n').

play(GameMode) :-
  initial_state(8, GameState),
  %test_custom_initial_state(GameState),
  play_loop(GameMode, GameState).

play_loop('PvP', GameState) :-
  printBoard(GameState),
  turn('B', GameState, GameStateAux),
  turn('W', GameStateAux, NGameState),
  play_loop('PvP', NGameState).

play_loop('PvB', GameState).

play_loop('BvB', GameState).

turn(Player, GameState, NGameState) :-
  move_piece(Player, GameState, NGameState),
  printBoard(NGameState),
  \+ check_game_over(GameState).

initial_state(Size, GameState) :-
  createBoard(Size, Size, GameState).

move_piece('B', GameState, NGameState) :-
  menu_ask_position('Player Black - What piece do you want to move? (Ex: A1): ', ColumnI, RowI),
  get_cell(ColumnI, RowI, GameState, Player),
  skip_line,
  menu_ask_position('Player Black - To where do you want to move this piece? (Ex: A1): ', ColumnIN, RowIN),
  \+get_cell(ColumnIN, RowIN, GameState, Player),
  validate_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState),
  change_cell(ColumnI, RowI, GameState, '-', GameStateAux),
  change_cell(ColumnIN, RowIN, GameStateAux, Player, NGameState).

move_piece('W', GameState, NGameState) :-
  menu_ask_position('Player White - What piece do you want to move? (Ex: A1): ', ColumnI, RowI),
  get_cell(ColumnI, RowI, GameState, Player),
  skip_line,
  menu_ask_position('Player White - To where do you want to move this piece? (Ex: A1): ', ColumnIN, RowIN),
  \+get_cell(ColumnIN, RowIN, GameState, Player),
  validate_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState),
  change_cell(ColumnI, RowI, GameState, '-', GameStateAux),
  change_cell(ColumnIN, RowIN, GameStateAux, Player, NGameState).

move_piece(Player, GameState, NGameState) :-
  skip_line,
  print('Not a valid move!\n'),
  move_piece(Player, GameState, NGameState).

check_game_over(GameState) :-
  check_all_pieces_together('B', GameState),
  format('Player ~w Won!\n', ['B']),
  play.

check_game_over(GameState) :-
  check_all_pieces_together('W', GameState),
  format('Player ~w Won!\n', ['W']),
  play.

custom_initial_state([
  ['-','B','B','B','B','B','B','-'],
  ['W','-','-','-','-','-','-','W'],
  ['W','-','-','-','-','-','-','W'],
  ['W','-','-','-','-','-','-','W'],
  ['W','-','-','-','-','-','-','W'],
  ['W','-','-','-','-','-','-','W'],
  ['W','-','-','-','-','-','-','W'],
  ['-','B','B','B','B','B','B','-']
]).

test_custom_initial_state([
  ['-','-','B','-','-','-','-','B'],
  ['-','-','B','-','-','-','-','W'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','B','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','W']
]).
