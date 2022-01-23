
% divideAbs(+Number, -Result)
% Divides a number by it's absolute value. The result will be -1, 0 or 1.
divideAbs(0, 0).

divideAbs(Number, Result) :-
  Number \= 0,
  Result is Number div abs(Number).
