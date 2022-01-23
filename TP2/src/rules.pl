% rules
% Displays the rules of the Lines of Action game
rules :-
  print('\n ------------------------------------------------------------------------------------------------------------- \n'),
  print('|                                                                                                             |\n'),
  print('| 1) Start of the game                                                                                        |\n'),
  print('|                                                                                                             |\n'),
  print('| - Black moves first.                                                                                        |\n'),
  print('|                                                                                                             |\n'),
  print('| - Each player moves one of his pieces in every turn.                                                        |\n'),
  print('|                                                                                                             |\n'),
  print('|                                                                                                             |\n'),
  print('| 2) Moves                                                                                                    |\n'),
  print('|                                                                                                             |\n'),
  print('| - Pieces are moved in a straight line (vertical, horizontal or diagonal),                                   |\n'),
  print('|   exactly as many squares as there are pieces of either colour anywhere along the line of movement.         |\n'),
  print('|                                                                                                             |\n'),
  print('| - Moved piece cannot land on a square occupied by one piece of the same colour.                             |\n'),
  print('|   However, opponent pieces can be captured by landing on them.                                              |\n'),
  print('|                                                                                                             |\n'),
  print('| - Moved piece may jump over pieces of the same colour, but not over opponent pieces.                        |\n'),
  print('|                                                                                                             |\n'),
  print('|                                                                                                             |\n'),
  print('| 3) End of the game                                                                                          |\n'),
  print('|                                                                                                             |\n'),
  print('| - Game may be won with an own move or an opponent move,                                                     |\n'),
  print('|   if the opponent makes a capture leaving an only group of pieces;                                          |\n'),
  print('|   particularly, if one player is reduced by captures (11) to a single piece,                                |\n'),
  print('|   that is a win for the captured player (a single piece, obviously, makes a single group).                  |\n'),
  print('|                                                                                                             |\n'),
  print('| - If a move simultaneously creates a win for both players, the player who has made the move is the winner.  |\n'),
  print('|                                                                                                             |\n'),
  print(' ------------------------------------------------------------------------------------------------------------- \n').
