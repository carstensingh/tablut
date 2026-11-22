require_relative "../model/enums"
require_relative "boardDisplay"
require_relative "boardController"
require_relative "playerController"

class GameView
  
    def startNewGame
        @board = Array.new(9) { Array.new(9, 0) }
        @status = GameStatus::NOT_STARTED
        @currentSide = Side::ATTACKER
        @result = GameResult::UNDECIDED
    
        @boardDisplay = BoardDisplay.new
        @playerController = PlayerController.new(self, @boardDisplay)
        @boardController = BoardController.new

        @boardDisplay.showWelcome
        @playerController.confirmReady
        @boardDisplay.showGameStarted

        @boardController.startGame
        refresh
        @boardDisplay.render(@board, @currentSide, @status, @result)
        @boardDisplay.showHelp
    end

    def move(fromRow, fromCol, toRow, toCol)
        result_move = @boardController.move(fromRow, fromCol, toRow, toCol)
        if result_move.isValid
            oldBoard = @board.map(&:dup)
            refresh

            @boardDisplay.moveAccepted(fromRow, fromCol, toRow, toCol)
            captures = findCaptures(oldBoard, @board)
            captures.each do |row, col, pieceType|
                @boardDisplay.pieceCaptured(row, col, pieceType)
            end
            @boardDisplay.render(@board, @currentSide, @status, @result)
        else
            @boardDisplay.moveInvalid
        end
    end

    def forfeit
        @boardController.forfeit
        @status = @boardController.getStatus
        refresh
        @boardDisplay.render(@board, @currentSide, @status, @result)
    end

    def getPlayerController
        @playerController
    end
    
    def getGameStatus
        @status
    end

    private

    def refresh
        @boardController.updateBoard(@board)
        @status = @boardController.getStatus
        @currentSide = @boardController.getCurrentSide
        @result = @boardController.getResult
    end

    def findCaptures(oldBoard, board)
        movedPiece = 0
        9.times do |row|
            9.times do |col|
                wasEmpty = oldBoard[row][col] == 0
                isFilled = board[row][col] != 0
                movedPiece = board[row][col] if wasEmpty && isFilled
            end
        end

        if movedPiece == 1
            opponentPieces = [2, 3]
        else
            opponentPieces = [1]
        end

        captures = []
        9.times do |row|
            9.times do |col|
                pieceBefore = oldBoard[row][col]
                isEmptyNow = board[row][col] == 0

                if opponentPieces.include?(pieceBefore) && isEmptyNow
                    captures << [row, col, pieceBefore]
                end
            end
        end

        captures
    end
end
