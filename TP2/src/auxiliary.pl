divideAbs(0, 0).

divideAbs(Number, Result) :-
  Number \= 0,
  Result is Number div abs(Number).