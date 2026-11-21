require_relative "enums"
require_relative "game"

# Communicates with the Model: sends move, forfeit and start requests to the
# Game, and reads the board, turn, status and result back. Applies no game rules.
class BoardController
    # Numbers the View uses for each square: 0 = empty, 1 = attacker,
    # 2 = defender, 3 = king.
    PIECE_CODES = {
        nil => 0,
        PieceType::ATTACKER => 1,
        PieceType::DEFENDER => 2,
        PieceType::KING => 3
    }.freeze

    def initialize
    end

    # Creates a new game within the Model.
    def startGame
        @game = Game.new
        @game.startNewGame
    end

    # Requests a move within the Model. Returns the resulting Move, or nil
    # if the Model rejects it.
    def move(fromRow, fromCol, toCol, toRow)
        move = @game.makeMove(fromRow, fromCol, toRow, toCol)
        move.isValid ? move : nil
    end

    # Requests a forfeit within the Model, ending the game with the current
    # side losing.
    def forfeit
        @game.forfeit(@game.getCurrentSide)
    end

    # Populates the given 2D array with the pieces on the board in their
    # respective positions, using the Model's current state.
    def updateBoard(board)
        board.each_index do |row|
            board[row].each_index do |col|
                board[row][col] = PIECE_CODES.fetch(@game.getPieceAt(row, col))
            end
        end
    end

    def getCurrentSide
        @game.getCurrentSide
    end

    def getStatus
        @game.getStatus
    end

    def getResult
        @game.getResult
    end
end
