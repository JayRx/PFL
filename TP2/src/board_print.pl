display_game(Board) :-
  nl,nl,
  print('    A B C D E F G H '), nl,
  print('   -----------------'), nl,
  printBoard_aux(Board, 1),
  print('   -----------------'),
  nl,nl.

printBoard_aux([], _).
printBoard_aux([Row|Board], N) :-
  print(N),
  print(' | '),
  printRow(Row),
  print('|'),
  nl,
  N2 is N + 1,
  printBoard_aux(Board, N2).

printRow([]).
printRow([X|Row]) :-
  format('~w ', [X]),
  printRow(Row).
