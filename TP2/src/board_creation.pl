% createBoard(+Size, +Size, -GameState)
% Creates the initial GameState for the Lines of Action game with a board with the given dimensions (Size)
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

% createRow(+Player, +Size, +SizeAux, -Row)
% Auxiliary predicate to createBoard(+Size, +Size, -GameState)
% Creates a row based on the positions it will have in the board. If it's the first or last row it will have Black pieces and empty cells, otherwise it will have White pieces and empty cells
createRow('W', 1, _, ['W']).
createRow('W', Size, SizeAux, Row) :-
  Size > 1,
  Size == SizeAux,
  NSize is Size - 1,
  createRow('W', NSize, SizeAux, NRow),
  append(NRow, ['W'], Row).
createRow('W', Size, SizeAux, Row) :-
  Size > 1,
  Size \== SizeAux,
  NSize is Size - 1,
  createRow('W', NSize, SizeAux, NRow),
  append(NRow, ['-'], Row).

createRow('B', 1, _, ['-']).
createRow('B', Size, SizeAux, Row) :-
  Size > 1,
  Size == SizeAux,
  NSize is Size - 1,
  createRow('B', NSize, SizeAux, NRow),
  append(NRow, ['-'], Row).
createRow('B', Size, SizeAux, Row) :-
  Size > 1,
  Size \== SizeAux,
  NSize is Size - 1,
  createRow('B', NSize, SizeAux, NRow),
  append(NRow, ['B'], Row).
