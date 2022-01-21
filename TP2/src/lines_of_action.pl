:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(between)).
:-use_module(library(random)).
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
  %initial_state(8, GameState),
  test_custom_initial_state(GameState),
  display_game(GameState),
  play_loop(GameMode, GameState).

play_loop('PvP', GameState) :-
  turn('B', GameState, GameStateAux),
  value(GameStateAux, 'B', Value),
  turn('W', GameStateAux, NGameState),
  value(NGameState, 'W', Value),
  play_loop('PvP', NGameState).

play_loop('PvB', GameState) :-
  turn('B', GameState, GameStateAux),
  turn_bot('W', GameStateAux, NGameState),
  play_loop('PvB', NGameState).

play_loop('BvB', GameState) :-
  sleep(1),
  turn_bot('B', GameState, GameStateAux),
  sleep(1),
  turn_bot('W', GameStateAux, NGameState),
  play_loop('BvB', NGameState).

turn(Player, GameState, NGameState) :-
  move_piece(Player, GameState, NGameState),
  display_game(NGameState),
  \+ check_game_over(GameState).

turn_bot(Player, GameState, NGameState) :-
  move_piece_bot(Player, GameState, NGameState),
  display_game(NGameState),
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

move_piece_bot(Player, GameState, NGameState) :-
  setof([ColumnI-RowI, ColumnIN-RowIN], get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState), Moves),
  random_member([CI-RI, CIN-RIN], Moves),
  column_to_int(ColumnFrom, CI),
  row_to_int(RowFrom, RI),
  column_to_int(ColumnTo, CIN),
  row_to_int(RowTo, RIN),
  format('Move: From ~w~w to ~w~w\n', [ColumnFrom, RowFrom, ColumnTo, RowTo]),
  change_cell(CI, RI, GameState, '-', GameStateAux),
  change_cell(CIN, RIN, GameStateAux, Player, NGameState).

get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState) :-
  between(0, 7, ColumnI),
  between(0, 7, RowI),
  between(0, 7, ColumnIN),
  between(0, 7, RowIN),
  get_cell(ColumnI, RowI, GameState, Player),
  \+get_cell(ColumnIN, RowIN, GameState, Player),
  validate_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState).

value(GameState, Player, Value) :-
  count_pieces(Player, GameState, Pieces),
  format('Pieces: ~w\n', [Pieces]),
  ValueLog is log(12/Pieces),
  Value is ValueLog * ValueLog * 42,
  format('Value: ~w\n', [Value]).

valid_moves(GameState, ListOfMoves) :-
  setof('B'-[ColumnI-RowI, ColumnIN-RowIN], get_bot_move('B', ColumnI, RowI, ColumnIN, RowIN, GameState), ListOfMovesBlack),
  setof('W'-[ColumnI-RowI, ColumnIN-RowIN], get_bot_move('W', ColumnI, RowI, ColumnIN, RowIN, GameState), ListOfMovesWhite),
  append(ListOfMovesBlack, ListOfMovesWhite, ListOfMoves).

test :-
  custom_initial_state(GameState),
  check_cells_in_between('B', 1, 0, 0, 1, GameState).

check_game_over(GameState) :-
  game_over(GameState, 'B'),
  print('Player Black Won!\n'),
  play.

check_game_over(GameState) :-
  game_over(GameState, 'W'),
  print('Player White Won!\n'),
  play.

game_over(GameState, 'B') :-
  check_all_pieces_together('B', GameState).

game_over(GameState, 'W') :-
  check_all_pieces_together('W', GameState).

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
  ['-','-','B','B','B','-','-','-'],
  ['-','-','B','-','-','-','-','W'],
  ['-','-','B','-','-','-','-','-'],
  ['-','-','B','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','B','-','-','-','W']
]).
