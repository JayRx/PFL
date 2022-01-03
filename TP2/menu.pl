menu :-
  menu_header.

menu_header :-
  nl,
  print(' -----------------------------------'), nl,
  print('|                                   |'), nl,
  print('|     WELCOME TO LINES OF ACTION    |'), nl,
  print('|                                   |'), nl,
  print(' -----------------------------------'), nl.

menu_ask_option :-
  print('What piece do you want to move? (Ex: A1): '),
  get_char(Column),
  get_char(Row),
  validate_column(Column),
  validate_row(Row),
  format('Column: ~w Row: ~w\n', [Column, Row]).
menu_ask_option :-
  skip_line,
  print('Not a valid position!\n'),
  menu_ask_option.

validate_column('A').
validate_column('B').
validate_column('C').
validate_column('D').
validate_column('E').
validate_column('F').
validate_column('G').
validate_column('H').

validate_row('1').
validate_row('2').
validate_row('3').
validate_row('4').
validate_row('5').
validate_row('6').
validate_row('7').
validate_row('8').
