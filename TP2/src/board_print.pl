% display_game(+GameState)
% Displays the given GameState with column and row indicators
display_game(GameState) :-
  nl,nl,
  print('    '),
  length(GameState, Size),
  printColumnIndicators(0, Size),
  nl,
  print('   -'), printLines(Size), nl,
  printBoard_aux(GameState, 1),
  print('   -'), printLines(Size), nl,
  nl,nl.

% printColumnIndicators(+Column, +Size)
% Auxiliary predicate to display_game(+GameState)
% Displays the Column Indicators based on the Size of the board
printColumnIndicators(_, 0).
printColumnIndicators(Column, Size) :-
  Size > 0,
  SizeAux is Size - 1,
  ColumnAux is Column + 1,
  char_code('A', CodeA),
  Code is CodeA + Column,
  char_code(Letter, Code),
  format('~w ', [Letter]),
  printColumnIndicators(ColumnAux, SizeAux).

% printLines(+Size)
% Auxiliary predicate to display_game(+GameState)
% Displays the lines separating the column indicators from the board content
printLines(0).
printLines(Size) :-
  Size > 0,
  SizeAux is Size - 1,
  print('--'),
  printLines(SizeAux).

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
