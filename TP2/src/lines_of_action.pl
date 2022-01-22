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
  initial_state(8, GameState),
  display_game(GameState),
  play_loop(GameMode, GameState).

play_loop('PvP', GameState) :-
  turn('B', GameState, GameStateAux),
  value(GameStateAux, 'B', ValueBlack),
  print_value('B', ValueBlack),
  turn('W', GameStateAux, NGameState),
  value(NGameState, 'W', ValueWhite),
  print_value('W', ValueWhite),
  play_loop('PvP', NGameState).

play_loop('PvB', GameState) :-
  turn('B', GameState, GameStateAux),
  value(GameStateAux, 'B', ValueBlack),
  print_value('B', ValueBlack),
  sleep(1),
  turn_bot('W', GameStateAux, NGameState),
  value(NGameState, 'W', ValueWhite),
  print_value('W', ValueWhite),
  play_loop('PvB', NGameState).

play_loop('BvB', GameState) :-
  sleep(1),
  turn_bot('B', GameState, GameStateAux),
  value(GameStateAux, 'B', ValueBlack),
  print_value('B', ValueBlack),
  sleep(1),
  turn_bot('W', GameStateAux, NGameState),
  value(NGameState, 'W', ValueWhite),
  print_value('W', ValueWhite),
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

move(GameState, Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo), NewGameState) :-
  validate_move(Player, ColumnFrom, RowFrom, ColumnTo, RowTo, GameState),
  change_cell(ColumnFrom, RowFrom, GameState, '-', GameStateAux),
  change_cell(ColumnTo, RowTo, GameStateAux, Player, NewGameState).

move_piece('B', GameState, NGameState) :-
  menu_ask_position('Player Black - What piece do you want to move? (Ex: A1): ', ColumnI, RowI),
  get_cell(ColumnI, RowI, GameState, 'B'),
  menu_ask_position('Player Black - To where do you want to move this piece? (Ex: A1): ', ColumnIN, RowIN),
  \+get_cell(ColumnIN, RowIN, GameState, 'B'),
  move(GameState, 'B'-(ColumnI, RowI)-(ColumnIN, RowIN), NGameState),
  print_move('B'-(ColumnI, RowI)-(ColumnIN, RowIN)).

move_piece('W', GameState, NGameState) :-
  menu_ask_position('Player White - What piece do you want to move? (Ex: A1): ', ColumnI, RowI),
  get_cell(ColumnI, RowI, GameState, 'W'),
  menu_ask_position('Player White - To where do you want to move this piece? (Ex: A1): ', ColumnIN, RowIN),
  \+get_cell(ColumnIN, RowIN, GameState, 'W'),
  move(GameState, 'W'-(ColumnI, RowI)-(ColumnIN, RowIN), NGameState),
  print_move('W'-(ColumnI, RowI)-(ColumnIN, RowIN)).

move_piece(Player, GameState, NGameState) :-
  print('Not a valid move!\n'),
  move_piece(Player, GameState, NGameState).

move_piece_bot(Player, GameState, NGameState) :-
  choose_move(Player, GameState, 1, Move),
  print_move(Move),
  move(GameState, Move, NGameState).

print_move('B'-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)) :-
  column_to_int(CI, ColumnFrom),
  row_to_int(RI, RowFrom),
  column_to_int(CIN, ColumnTo),
  row_to_int(RIN, RowTo),
  format('Black Move: From ~w~w to ~w~w\n', [CI, RI, CIN, RIN]).

print_move('W'-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)) :-
  column_to_int(CI, ColumnFrom),
  row_to_int(RI, RowFrom),
  column_to_int(CIN, ColumnTo),
  row_to_int(RIN, RowTo),
  format('White Move: From ~w~w to ~w~w\n', [CI, RI, CIN, RIN]).

choose_move(Player, GameState, 1, Move) :-
  setof(Value-Player-(ColumnI, RowI)-(ColumnIN, RowIN), get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, Value, GameState), Moves),
  random_member(MoveAux, Moves),
  get_move(MoveAux, Move).

choose_move(Player, GameState, 2, Move) :-
  setof(Player-(ColumnI, RowI)-(ColumnIN, RowIN), get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, GameState), Moves),
  last(Moves, MoveAux),
  get_move(MoveAux, Move).

get_move(_-Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo), Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)).

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

value(GameState, Player, Value) :-
  count_pieces(Player, GameState, Pieces),
  ValueLog is log(12/Pieces),
  Value is ValueLog * 42.

print_value('B', Value) :-
  format('Player Black Value: ~w\n', [Value]).

print_value('W', Value) :-
  format('Player White Value: ~w\n', [Value]).

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
