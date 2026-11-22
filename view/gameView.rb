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
            mover = @currentSide
            oldBoard = @board.map(&:dup)
            refresh

            @boardDisplay.moveAccepted(fromRow, fromCol, toRow, toCol)
            captures = findCaptures(oldBoard, @board, mover)
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

    def findCaptures(oldBoard, newBoard, mover)
        opponent = mover == Side::ATTACKER ? [2, 3] : [1]
        captures = []
        9.times do |row|
            9.times do |col|
                if opponent.include?(oldBoard[row][col]) && newBoard[row][col] == 0
                    captures << [row, col, oldBoard[row][col]]
                end
            end
        end
        captures
    end
end
