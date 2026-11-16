# List of enumerators used by the model classes.

module Side
    ATTACKER = :attacker
    DEFENDER = :defender 
end

module PieceType
    ATTACKER = :attacker
    DEFENDER = :defender 
    KING =  :king 
end

module GameStatus
    NOT_STARTED = :not_started 
    ACTIVE = :active 
    ENDED = :ended 
end

module GameResult
    UNDECIDED = :undecided 
    ATTACKER_WIN = :attacker_win 
    DEFENDER_WIN = :defender_win 
    TIE = :tie 
end

module TurnStatus
    ACTIVE = :active 
    COMPLETED = :completed 
end



