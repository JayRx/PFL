print_rules :-
  print('| Start of the game\n'),
  print('| Black moves first.\n'),
  print('| Each player moves one of his pieces in every turn.\n'),
  print('| Moves\n'),
  print('| Pieces are moved in a straight line (vertical, horizontal or diagonal), exactly as many squares as there are pieces of either colour anywhere along the line of movement.\n'),
  print('| Moved piece cannot land on a square occupied by one piece of the same colour. However, opponent pieces can be captured by landing on them.\n'),
  print('| Moved piece may jump over pieces of the same colour, but not over opponent pieces.\n'),
  print('| End of the game\n'),
  print('| Game may be won with an own move or an opponent move, if the opponent makes a capture leaving an only group of pieces; particularly, if one player is reduced by captures (11) to a single piece, that is a win for the captured player (a single piece, obviously, makes a single group).\n'),
  print('| If a move simultaneously creates a win for both players, the player who has made the move is the winner.\n'),
  print('| The game ends in a draw if the same position is repeated three times.\n').
