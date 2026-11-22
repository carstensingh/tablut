require_relative "enums"
require_relative "player"
require_relative "board"
require_relative "turn"
require_relative "move"

# Entry point to the Tablut Model subsystem. The View talks only to Game.
class Game
    BOARD_SIZE = 9

    def initialize
        # players[0] is the attacker, players[1] is the defender.
        @players = [Player.new(Side::ATTACKER), Player.new(Side::DEFENDER)]
        resetState
    end

    # Begins a fresh game from the standard layout. Works from any status,
    # so a finished game can be restarted.
    def startNewGame
        resetState
        @board = Board.new(@players[0], @players[1])
        @currentTurn = Turn.new(1, @players[0])
        @status = GameStatus::ACTIVE
    end

    # Attempts one move for the side whose turn it is. Always returns a Move;
    # if rejected, move.isValid is false and the Move carries the error.
    def makeMove(fromRow, fromCol, toRow, toCol)
        if @status != GameStatus::ACTIVE
            move = Move.new(nil, nil, nil)
            move.markInvalid("Game is not in progress")
            return move
        end

        source = squareAt(fromRow, fromCol)
        destination = squareAt(toRow, toCol)
        piece = source.nil? ? nil : @board.getPieceAt(fromRow, fromCol)

        move = Move.new(source, destination, piece)
        @currentTurn.recordMove(move)

        return move unless validateMove(move)

        @board.movePiece(fromRow, fromCol, toRow, toCol)
        captured = @board.removeCaptures(toRow, toCol)
        move.markValid(captured)

        checkEndOfGame
        return move if @status == GameStatus::ENDED

        switchTurn
        move
    end

    # Ends the game with the opposite side winning. Does nothing unless active.
    def forfeit(side)
        return if @status != GameStatus::ACTIVE

        if side == Side::DEFENDER
            endGame(GameResult::ATTACKER_WIN)
        else
            endGame(GameResult::DEFENDER_WIN)
        end
    end

    # Read-only query returning only the PieceType (or nil for empty/off-board).
    def getPieceAt(row, col)
        return nil if @board.nil? || !onBoard(row, col)

        piece = @board.getPieceAt(row, col)
        piece.nil? ? nil : piece.getType
    end

    def getCurrentSide
        @currentTurn.getActiveSide
    end

    def getStatus
        @status
    end

    def getResult
        @result
    end

    def getTurnNumber
        return 0 if @status == GameStatus::NOT_STARTED

        @currentTurn.getNumber
    end

    private

    def resetState
        @status = GameStatus::NOT_STARTED
        @result = GameResult::UNDECIDED
        @board = nil
        @turns = []
        @positionHistory = []
        @currentTurn = Turn.new(1, @players[0])
    end

    # Runs the move checks in order, stopping at the first
    # failure. Marks the move invalid with that reason and returns false.
    def validateMove(move)
        source = move.getSource
        destination = move.getDestination
        piece = move.getSelectedPiece

        if source.nil? || destination.nil?
            move.markInvalid("Coordinates must be between 0 and 8.")
            return false
        end

        fromRow, fromCol = source.getPos
        toRow, toCol = destination.getPos

        if piece.nil? || piece.getOwner.getSide != @currentTurn.getActiveSide
            move.markInvalid("You must select one of your own pieces.")
            return false
        end

        if fromRow == toRow && fromCol == toCol
            move.markInvalid("Source and destination are the same square.")
            return false
        end

        unless @board.isEmpty(toRow, toCol)
            move.markInvalid("Destination square is not empty.")
            return false
        end

        unless @board.isPathClear(fromRow, fromCol, toRow, toCol)
            move.markInvalid("Pieces must move in a straight line with no pieces in the way.")
            return false
        end

        if @board.isRestricted(piece, toRow, toCol)
            move.markInvalid("That piece may not stop on that square.")
            return false
        end

        true
    end

    # End-of-game conditions, checked in order.
    def checkEndOfGame
        if @board.isKingSurrounded
            endGame(GameResult::ATTACKER_WIN)
            return
        end

        if @board.isKingOnEdge
            endGame(GameResult::DEFENDER_WIN)
            return
        end

        # Draw: a position is repeated.
        positionKey = "#{@board.getPositionKey} #{otherPlayer.getSide}"
        if @positionHistory.include?(positionKey)
            endGame(GameResult::TIE)
            return
        end
        @positionHistory.push(positionKey)

        # Draw: the player about to move cannot move.
        unless @board.hasLegalMove(otherPlayer.getSide)
            endGame(GameResult::TIE)
        end
    end

    def endGame(r)
        @currentTurn.complete
        @turns.push(@currentTurn)
        @result = r
        @status = GameStatus::ENDED
    end

    def switchTurn
        @currentTurn.complete
        @turns.push(@currentTurn)
        @currentTurn = Turn.new(@currentTurn.getNumber + 1, otherPlayer)
    end

    # --- private helpers ---

    def onBoard(row, col)
        row.is_a?(Integer) && col.is_a?(Integer) &&
            row.between?(0, BOARD_SIZE - 1) && col.between?(0, BOARD_SIZE - 1)
    end

    def squareAt(row, col)
        return nil unless onBoard(row, col)

        @board.getSquare(row, col)
    end

    def otherPlayer
        @players.find { |player| player.getSide != @currentTurn.getActiveSide }
    end
end
