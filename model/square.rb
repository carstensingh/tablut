class Square
    def initialize(row, col, throne)
        @position = [row, col]
        @throne = throne
        @piece = nil
    end

    def getPos
        @position
    end

    def isThrone
        @throne
    end

    def getPiece
        @piece
    end

    def setPiece(newPiece)
        @piece = newPiece
    end

    def removePiece
        @piece = nil
    end
end
