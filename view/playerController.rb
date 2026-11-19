class PlayerController
    def initialize(gameView, boardDisplay)
        @gameView = gameView
        @boardDisplay = boardDisplay
    end


    def confirmReady
        loop do 
            puts "Are both players ready? (yes/no)"
            print "> "
            answer = gets
            exit if answer.nil? 

            break if answer.strip.downcase == "yes"
        end
    end



    def takeTurn
        loop do
            puts
            puts "Enter command: "
            print "> "
            command = gets
            exit if command.nil?

            command = command.strip.upcase
            # "move D1 C1": a column letter A to I, then a row number 1 to 9.
            squares = command.match(/\AMOVE\s+([A-I])([1-9])\s+([A-I])([1-9])\z/)

            if command == "FORFEIT"
                @gameView.forfeit 
                return
            elsif squares
                fromCol = squares[1].ord - "A".ord
                fromRow = squares[2].to_i - 1
                toCol = squares[3].ord - "A".ord
                toRow = squares[4].to_i - 1
                @gameView.move(fromRow, fromCol, toRow, toCol)
                return
            else
                @boardDisplay.commandInvalid
            end
        end
    end
end