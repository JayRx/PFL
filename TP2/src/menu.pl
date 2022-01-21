menu(Option) :-
  menu_header,
  menu_body,
  get_menu_option(Option).

menu_header :-
  nl,
  print(' -----------------------------------'), nl,
  print('|                                   |'), nl,
  print('|     WELCOME TO LINES OF ACTION    |'), nl,
  print('|                                   |'), nl,
  print('|-----------------------------------|'), nl.

menu_body :-
print('|                                   |'), nl,
print('| What do you want to do?           |'), nl,
print('|                                   |'), nl,
print('| 1. Player vs Player               |'), nl,
print('| 2. Player vs Bot                  |'), nl,
print('| 3. Bot vs Bot                     |'), nl,
print('| 4. Rules                          |'), nl,
print('| 5. Exit                           |'), nl,
print('|                                   |'), nl,
print(' -----------------------------------\n'), nl.

get_menu_option(Option) :-
  print('What is your option? '),
  get_char(Option),
  validate_menu_option(Option).

get_menu_option(Option) :-
  skip_line,
  print('Not a valid option!\n'),
  get_menu_option(Option).

validate_menu_option('1').
validate_menu_option('2').
validate_menu_option('3').
validate_menu_option('4').
validate_menu_option('5').

menu_header2 :-
  print_file('menu.txt').

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

column_to_int('A', 0).
column_to_int('B', 1).
column_to_int('C', 2).
column_to_int('D', 3).
column_to_int('E', 4).
column_to_int('F', 5).
column_to_int('G', 6).
column_to_int('H', 7).

row_to_int('1', 0).
row_to_int('2', 1).
row_to_int('3', 2).
row_to_int('4', 3).
row_to_int('5', 4).
row_to_int('6', 5).
row_to_int('7', 6).
row_to_int('8', 7).

menu_ask_position(Text, ColumnI, RowI) :-
  print(Text),
  get_char(Column),
  get_char(Row),
  validate_column(Column),
  validate_row(Row),
  column_to_int(Column, ColumnI),
  row_to_int(Row, RowI), !.

menu_ask_position(Text, ColumnI, RowI) :-
  print('Not a valid position!\n'),
  menu_ask_position(Text, ColumnI, RowI).
