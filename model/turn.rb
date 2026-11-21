require_relative "enums"

class Turn
  

  def initialize(number, activePlayer)

    if number < 1

      raise ArgumentError, "number must be at least 1"
    end

    if activePlayer == nil

      raise ArgumentError, "Turn requires an active player"
    end

    @number = number
    @status = TurnStatus::ACTIVE
    @activePlayer = activePlayer
    @attemptedMoves = []

  end

  def getNumber

    return @number

  end

  def getStatus

    return @status

  end

  def getActiveSide

    return @activePlayer.getSide

  end

  def recordMove(move)

    if @status == TurnStatus::COMPLETED
      return

    end

    @attemptedMoves.push(move)

  end

  def complete

    @status = TurnStatus::COMPLETED
    
  end
end
