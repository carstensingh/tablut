require_relative "enums"

class Piece 
  def initialize(type, owner)
    types = [PieceType::ATTACKER, PieceType::DEFENDER, PieceType::KING]
    raise ArgumentError, "type must be a PieceType" unless types.include?(type)
    raise ArgumentError, "owner must be a Player" if owner.nil?
    
    @type = type
    @owner = owner
  end

  def getType
    @type
  end

  def getOwner
    @owner
  end

  def isKing
    @type == PieceType::KING
  end
end
