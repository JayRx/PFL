printBoard(Board) :-
  nl,
  printBoard_aux(Board),
  nl.

printBoard_aux([]).
printBoard_aux([Row|Board]) :-
  print('| '),
  printRow(Row),
  print('|'),
  nl,
  printBoard_aux(Board).

printRow([]).
printRow([X|Row]) :-
  format('~w ', [X]),
  printRow(Row).
