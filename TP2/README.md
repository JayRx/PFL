# Lines of Action

## 1 - Game and Group Identification
##### Group: Lines of Action_1
##### Made By
- João Paulo Silva da Rocha (up201806261)
- Lara Machado de Medicis (up201806762)

## 2 - Instalation and Execution
- Download the code.
- Consult the 'lines_of_action.pl' file in SICSTUS.
- Run the 'play' predicate.

## 3 - Game Description
Lines of Action is a strategy board game for two players invented by Claude Soucie.
The objective of the game is to connect all of one player's pieces into a single group.
It is played in an 8x8 checkers board and the players can move the pieces any number of squares in the same direction (horizontally, vertically or diagonally).

### 3.1 - Start of the game
- Black moves first. Each player moves one of his pieces in every turn.

### 3.2 - Moves
- Pieces are moved in a straight line (vertical, horizontal or diagonal), exactly as many squares as there are pieces of either colour anywhere along the line of movement.
- Moved piece cannot land on a square occupied by one piece of the same colour. However, opponent pieces can be captured by landing on them.
- Moved piece may jump over pieces of the same colour, but not over opponent pieces.

### 3.3 - End of the game
- Game may be won with an own move or an opponent move, if the opponent makes a capture leaving an only group of pieces; particularly, if one player is reduced by captures (11) to a single piece, that is a win for the captured player (a single piece, obviously, makes a single group).
- If a move simultaneously creates a win for both players, the player who has made the move is the winner.
- The game ends in a draw if the same position is repeated three times.

Fonts of information:
https://en.wikipedia.org/wiki/Lines_of_Action
https://www.ludoteka.com/clasika/lines-of-action.html

## 4 - Game Logic
### 4.1 - Game State Representation
The Game State is represented by a matrix with the dimensions of the playing board. The Black player pieces are represented by 'B', the White player pieces by 'W' and the blank cells represented by '-'.

### 4.2 - Game State Visualization
### 4.3 - Moves Execution
### 4.4 - End of the Game
### 4.5 - Game State Evaluation
### 4.6 - Computer Moves

## 5 - Conclusions

## 6 - Bibliography
