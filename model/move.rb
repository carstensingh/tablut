# Model: records one attempted move and the Game's verdict on it.
# A Move does not check any rules itself. The Game validates it, then calls
# markValid (with any captured pieces) or markInvalid (with the reason).
class Move
    def initialize(source, destination, piece)
        @source = source
        @destination = destination
        @selectedPiece = piece
        @valid = false
        @errorMessage = nil
        @captured = []
    end

    def getSource
        @source
    end

    def getDestination
        @destination
    end

    def getSelectedPiece
        @selectedPiece
    end

    def isValid
        @valid
    end

    def getErrorMessage
        @errorMessage
    end

    # Returns a copy so callers cannot change the Move's record.
    def getCapturedPieces
        @captured.dup
    end

    # Called by the Game when the move is legal and has been applied.
    def markValid(captured)
        @valid = true
        @errorMessage = nil
        @captured = captured.dup
    end

    # Called by the Game when the move breaks a rule.
    def markInvalid(error)
        @valid = false
        @errorMessage = error
        @captured = []
    end
end
