createBoard(0, _, []).
createBoard(1, Size, GameState) :-
  createBoard(0, Size, NGameState),
  createRow('B', Size, Size, Row),
  append(NGameState, [Row], GameState).
createBoard(Size, Size, GameState) :-
  Size > 1,
  NSize is Size - 1,
  createBoard(NSize, Size, NGameState),
  createRow('B', Size, Size, Row),
  append(NGameState, [Row], GameState).
createBoard(Aux, Size, GameState) :-
  Aux > 1,
  NAux is Aux - 1,
  createBoard(NAux, Size, NGameState),
  createRow('W', Size, Size, Row),
  append(NGameState, [Row], GameState).

createRow('W', 0, _, ['W']).
createRow('W', Size, SizeAux, Row) :-
  Size > 0,
  Size == SizeAux,
  NSize is Size - 1,
  createRow('W', NSize, SizeAux, NRow),
  append(NRow, ['W'], Row).
createRow('W', Size, SizeAux, Row) :-
  Size > 0,
  Size \== SizeAux,
  NSize is Size - 1,
  createRow('W', NSize, SizeAux, NRow),
  append(NRow, ['-'], Row).

createRow('B', 0, _, ['-']).
createRow('B', Size, SizeAux, Row) :-
  Size > 0,
  Size == SizeAux,
  NSize is Size - 1,
  createRow('B', NSize, SizeAux, NRow),
  append(NRow, ['-'], Row).
createRow('B', Size, SizeAux, Row) :-
  Size > 0,
  Size \== SizeAux,
  NSize is Size - 1,
  createRow('B', NSize, SizeAux, NRow),
  append(NRow, ['B'], Row).
