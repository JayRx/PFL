% Imports all the libraries used
:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(between)).
:-use_module(library(random)).

% Imports all the other game files
:-consult('auxiliary.pl').
:-consult('board_creation.pl').
:-consult('board_print.pl').
:-consult('board_control.pl').
:-consult('menu.pl').
:-consult('rules.pl').

% play
% Starts the program
play :-
  menu(Option),
  router(Option).

% router(+Option)
% Redirects to other predicate based on the menu option the user typed
router('1') :- play('PvP').
router('2') :- play('PvB').
router('3') :- play('BvB').
router('4') :- rules, play.
router('5') :- print('Exiting...\n').

% initial_state(+Size, -GameState)
% Gets the initial GameState
initial_state(Size, GameState) :-
  createBoard(Size, Size, GameState).

% play(+GameMode)
% Starts the Lines of Action game in the given GameMode
play('PvP') :-
  %initial_state(8, GameState),
  test_custom_initial_state(GameState),
  display_game(GameState),
  play_loop('PvP', GameState).

play('PvB') :-
  get_bot_level(BotLevel),
  initial_state(8, GameState),
  display_game(GameState),
  play_loop('PvB', GameState, BotLevel).

play('BvB') :-
  get_bot_level(FirstBotLevel, SecondBotLevel),
  initial_state(8, GameState),
  display_game(GameState),
  play_loop('BvB', GameState, FirstBotLevel, SecondBotLevel).

% play_loop(+GameMode, +GameState)
% Loops the Lines of Action game in the given GameMode
play_loop('PvP', GameState) :-
  turn('B', GameState, GameStateAux),
  value(GameStateAux, 'B', ValueBlack),
  print_value('B', ValueBlack),
  turn('W', GameStateAux, NGameState),
  value(NGameState, 'W', ValueWhite),
  print_value('W', ValueWhite),
  play_loop('PvP', NGameState).

play_loop('PvB', GameState, BotLevel) :-
  turn('B', GameState, GameStateAux),
  value(GameStateAux, 'B', ValueBlack),
  print_value('B', ValueBlack),
  sleep(1),
  turn_bot('W', GameStateAux, BotLevel, NGameState),
  value(NGameState, 'W', ValueWhite),
  print_value('W', ValueWhite),
  play_loop('PvB', NGameState, BotLevel).

play_loop('BvB', GameState, FirstBotLevel, SecondBotLevel) :-
  sleep(1),
  turn_bot('B', GameState, FirstBotLevel, GameStateAux),
  value(GameStateAux, 'B', ValueBlack),
  print_value('B', ValueBlack),
  sleep(1),
  turn_bot('W', GameStateAux, SecondBotLevel, NGameState),
  value(NGameState, 'W', ValueWhite),
  print_value('W', ValueWhite),
  play_loop('BvB', NGameState, FirstBotLevel, SecondBotLevel).

% turn(+Player, +GameState, -NGameState)
% Processes the given Player's turn and returns a new GameState (NGameState)
turn(Player, GameState, NGameState) :-
  move_piece(Player, GameState, NGameState),
  display_game(NGameState),
  \+ check_game_over(NGameState, Player).

% turn_bot(+Player, +GameState, -NGameState)
% Processes the given Bot's (Player) turn and returns a new GameState (NGameState)
turn_bot(Player, GameState, BotLevel, NGameState) :-
  move_piece_bot(Player, GameState, BotLevel, NGameState),
  display_game(NGameState),
  \+ check_game_over(NGameState, Player).

% move(GameState, Move, NewGameState)
% Validates the given Move and returns a NewGameState
move(GameState, Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo), NewGameState) :-
  validate_move(Player, ColumnFrom, RowFrom, ColumnTo, RowTo, GameState),
  change_cell(ColumnFrom, RowFrom, GameState, '-', GameStateAux),
  change_cell(ColumnTo, RowTo, GameStateAux, Player, NewGameState).

% move_piece(Player, GameState, NGameState)
% Asks the user which piece he wants to move and where he wants to move it to. Then validates the move and returns a new GameState (NGameState)
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

% move_piece_bot(+Player, +GameState, -NGameState)
% Gets the bot's (Player) move. Then validates the move and returns a new GameState (NGameState)
move_piece_bot(Player, GameState, BotLevel, NGameState) :-
  choose_move(Player, GameState, BotLevel, Move),
  print_move(Move),
  move(GameState, Move, NGameState).

% print_move(+Move)
% Displays the given Move in text to have more readability
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

% choose_move(+Player, +GameState, +Level, -Move)
% Depending on the given Bot's Level chooses the move it will make
% Move is represented by: Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
choose_move(Player, GameState, '1', Move) :-
  setof(Value-Player-(ColumnI, RowI)-(ColumnIN, RowIN), get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, Value, GameState), Moves),
  random_member(MoveAux, Moves),
  get_move(MoveAux, Move).

choose_move(Player, GameState, '2', Move) :-
  setof(Value-Player-(ColumnI, RowI)-(ColumnIN, RowIN), get_bot_move(Player, ColumnI, RowI, ColumnIN, RowIN, Value, GameState), Moves),
  last(Moves, MoveAux),
  get_move(MoveAux, Move).

% get_move(+MoveWithValue, -Move)
% Parses MoveWithValue and extracts the Move from it
% MoveWithValue is represented by: Value-Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
% Move is represented by: Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
get_move(_-Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo), Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)).

% get_bot_move(+Player, +ColumnI, +RowI, +ColumnIN, +RowIN, +Value, +GameState)
% This predicate is used to get all the Moves a Bot (Player) can make and it's associated board value
% MoveWithValue is represented by: Value-Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
% Move is represented by: Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
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

% value(+GameState, +Player, -Value)
% Calculates the Player's board Value in the given GameState
value(GameState, Player, Value) :-
  count_pieces(Player, GameState, Pieces),
  ValueLog is log(12/Pieces),
  Value is ValueLog * 42.

% print_value(+Player, +Value)
% Displays the Player's board Value
print_value('B', Value) :-
  format('Player Black Value: ~w\n', [Value]).

print_value('W', Value) :-
  format('Player White Value: ~w\n', [Value]).

% valid_moves(+GameState, -ListOfMoves)
% Gets all the Moves possible
% Move is represented by: Player-(ColumnFrom, RowFrom)-(ColumnTo, RowTo)
valid_moves(GameState, ListOfMoves) :-
  setof('B'-(ColumnI, RowI)-(ColumnIN, RowIN), get_bot_move('B', ColumnI, RowI, ColumnIN, RowIN, _, GameState), ListOfMovesBlack),
  setof('W'-(ColumnI2, RowI2)-(ColumnIN2, RowIN2), get_bot_move('W', ColumnI2, RowI2, ColumnIN2, RowIN2, _, GameState), ListOfMovesWhite),
  append(ListOfMovesBlack, ListOfMovesWhite, ListOfMoves).

% check_game_over(+GameState)
% Checks if it's Game Over in the given GameState and displays the Winner
check_game_over(GameState, 'B') :-
  game_over(GameState, 'B'),
  print('Player Black Won!\n'),
  play.

check_game_over(GameState, 'B') :-
  game_over(GameState, 'W'),
  print('Player White Won!\n'),
  play.

check_game_over(GameState, 'W') :-
  game_over(GameState, 'W'),
  print('Player White Won!\n'),
  play.

check_game_over(GameState, 'W') :-
  game_over(GameState, 'B'),
  print('Player Black Won!\n'),
  play.

% game_over(+GameState, +Player)
% Checks if it's Game Over in the given GameState for the given Player
game_over(GameState, 'B') :-
  check_all_pieces_together('B', GameState).

game_over(GameState, 'W') :-
  check_all_pieces_together('W', GameState).

% custom_initial_state
% Initial GameState representation
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

% test_custom_initial_state
% Test GameState representation
test_custom_initial_state([
  ['-','-','B','B','B','-','-','-'],
  ['-','-','B','-','-','-','-','W'],
  ['-','-','B','-','-','-','-','-'],
  ['-','-','B','-','-','B','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','-','-','-','-','-'],
  ['-','-','-','W','-','-','-','W']
]).
