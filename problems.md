# Tablut Problems

## Need Fix ASAP

### 1. PlayerController can't reach GameView
takeTurn() has to call move() or forfeit() on the GameVieww, but PlayerController has no instance variables and its constructor takes no arguments.

**Source:** Handoff Document page 8,9

### 2. Nothing can call takeTurn()
Two of your sequence diagram shows only the player calling takeTurn(). GameView creates the PlayerController internally, and none of its public methods return it or the game status, so no turn loop can be written.

**Source:** Handoff Document page 9,10

### 3. The first board is never shown
The Start New Game sequence ends after startGame() without calling update Board() or render(). However, your handoff document says that the starting board is rendered.

**Source:** Handoff Document page 3,10

### 4. Instance variables are missing
- BoardController lists no instance variables but doesn't it keep the Game it creates.
- GameView lists only board, status, and currentSide, but shouldn't it also have the three view objects it creates.

**Source:** Handoff Document page 5,8,9

### 5. Missing method descriptions
- positionHistory, hasLegalMove(side), and getPositionKey() all have no description but are in your new class diagram.  

- The makeMove description on M2 pg.27 has 3 reasons for a draw, but, none of them are described.

**Source:** Milestone 2 page 27 + Handoff Document page 12


## Need Clarification

### 6. Input Format
- The handoff document says the player enters a row and column then another row and colummn (HOD, pg.9) but your screenshot (M2, pg20, 2.2) shows `move D1 C1`

### 7. Missing screen outputs
This entire screen has no method
```
Tablut
Two-player game

Are both players ready? (yes/no)
> yes

New game started.

Player 1: Attacker (A)
Player 2: Defender (D), including the King (K)

Player 1 moves first.
```

Is this printed with render()?
```
A = Attacker    D = Defender
K = King        . = Empty

To move: move <source> <destination>
Example: move D1 C1
To concede: forfeit
```

Nothing prints this
```
Move accepted: D1 to C1.
```

### 8. Invalid Move Issues

1. moveInvalid() takes no argument, so the reason in Move.getErrorMessage() can't reach the display
2. Move.getErrorMessage() has no description anywhere only in class diagram
3. In your make a move sequence, GameView calls moveInvalid() only after the model rejects a move. A badly formatted command such as `mve D1` never becomes a move. Then GameView.move() is never called and PlayerController has no link to BoardDisplay to call it directly.

### 9. How does render know if it is a forfeit or a captured king?
render() receives only the result.  Does this matter?

### 10. How are captures displayed?
Screen 2.5 prints "Captured: Defender at E4" However, Gameview.move() returns nothing, no view method dispalys a capture and a Piece has no position. Also, boardDisplay has no method to print a capture. 

### 11. Move Argument order
GameView.move and BoardController.move take `(fromRow, fromCol, toCol, toRow)`. Game.makeMove takes `(fromRow, fromCol, toRow, toCol)`.

### 12. Can BoardController.move return null
The detailed list says teh method returns null if the model rejects the move. Game.makeMove always returns a Move but could be marked invalid

### 13. What are the default values
GameView.startNewGame() resets its instance variables "to default values" that are never listed

### 14. Methods on the new class diagram with no description
These are on the diagram (HOD pg.12) but not in the detailed list of classes (M2 pg.25-34):
- Board.getSquare(row, col). What does it return for a square off the board?
- Square.isThrone(), Piece.isKing(), Turn.getStatus()
- Move.isValid(), getCapturedPieces(), markValid(captured), markInvalid(error)
- Game.validateMove(move) and checkEndOfGame()

### 15. A finished turn is added to turns twice
makeMove step 5 calls currentTurn.complete() and turns.add(currentTurn). Step 7 then calls switchTurn(), which completes the turn and adds it to turns again.
**Source:** Milestone 2 page 26, 27

### 16. Does forfeit complete the turn?
The forfeit description only calls endGame(). Sequence diagram SD 5 also calls complete() on the turn. Is the forfeited turn added to turns?

**Source:** Milestone 2 page 27, 39

### 17. How does Game check who owns a piece?
The makeMove description compares the piece's side with the active side, but Piece has no side, only a type and an owner. Sequence diagram SD 3 calls ownsPiece(piece) on the active Player, but Turn has no method that returns its player.

**Source:** Milestone 2 page 26, 37


### 18. The Forfeit sequence renders a board it never refreshed
The sequence calls render() with the stored board and currentSide, but never calls updateBoard() or getCurrentSide(). With problem 3, a forfeit before the first valid move shows an empty board.

**Source:** Handoff Document page 11
