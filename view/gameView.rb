class GameView
  
    def startNewGame
        @board = Array.new(9) { Array.new(9, 0) }
        @status = nil
        @currentSide = nil
        @result = nil
    
        @boardDisplay = BoardDisplay.new
        @playerController = PlayerController.new
        @boardController = BoardController.new
        @boardController.startGame
    end

    def move(fromRow, fromCol, toRow, toCol)
        result_move = @boardController.move(fromRow, fromCol, toRow, toCol)
        if result_move.isValid
            @boardController.updateBoard(@board)
            @status = @boardController.getStatus
            @currentSide = @boardController.getCurrentSide
            @result = @boardController.getResult
            @boardDisplay.render(@board, @currentSide, @status, @result)
        else
            @boardDisplay.moveInvalid
        end
    end

    def forfeit
        @boardController.forfeit
        @status = @boardController.getStatus
        @result = @boardController.getResult
        @boardDisplay.render(@board, @currentSide, @status, @result)
    end
end
