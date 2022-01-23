% display_game(+GameState)
% Displays the given GameState with column and row indicators
display_game(GameState) :-
  nl,nl,
  print('    A B C D E F G H '), nl,
  print('   -----------------'), nl,
  printBoard_aux(GameState, 1),
  print('   -----------------'),
  nl,nl.

% printBoard_aux(Board, N)
% Auxiliary predicate to display_game(+GameState)
% Displays the given Board with row indicators
printBoard_aux([], _).
printBoard_aux([Row|Board], N) :-
  print(N),
  print(' | '),
  printRow(Row),
  print('|'),
  nl,
  N2 is N + 1,
  printBoard_aux(Board, N2).

% printRow(+Row)
% Auxiliary predicate to printBoard_aux(Board, N)
% Displays the given Row
printRow([]).
printRow([X|Row]) :-
  format('~w ', [X]),
  printRow(Row).
