require_relative "enums"

class Player
    def initialize(side)
        unless side == Side::ATTACKER || side == Side::DEFENDER
            raise ArgumentError, "side must be ATTACKER or DEFENDER"
        end

        @side = side
    end

    def getSide
        @side 
    end


    def ownsPiece(piece)
        return false if piece.nil?
        
        piece.getOwner.equal?(self)
    end
end