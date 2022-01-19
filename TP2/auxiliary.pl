divideAbs(0, 0).

divideAbs(Number, Result) :-
  Number \= 0,
  Result is Number div abs(Number).

getBigger(A, B, Bigger) :-
  A >= B.

getBigger(A, B, B),
  B >= A.

read_file(Stream,[]) :-
  at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
  \+ at_end_of_stream(Stream),
  read(Stream,X),
  read_file(Stream,L).

print_file(File) :-
  %working_directory(CWD, CWD),
  write(CWD).
  open(File, read, Str),
  read_file(Str,Lines),
  close(Str),
  write(Lines), nl.
