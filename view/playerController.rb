class PlayerController
    def initialize
    end

    def takeTurn
        print "Starting row (or forfeit): "
        input = gets.to_s.strip

        if input == "forfeit"
            #Needs to call forfeit() from GameView but no access
            print "Stub"
        end

        fromRow = input.to_i
        print "Starting column: "
        fromCol = gets.to_s.strip.to_i
        print "Destination row: "
        toRow = gets.to_s.strip.to_i
        print "Destination column: "
        toCol = gets.to_s.strip.to_i

        #Call Move
    end
end