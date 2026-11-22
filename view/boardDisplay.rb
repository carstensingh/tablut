class BoardDisplay
    SYMBOLS = { 0 => ".", 1 => "A", 2 => "D", 3 => "K" }
    PIECE_NAMES = { 1 => "Attacker", 2 => "Defender", 3 => "King" }
    
    def render(board, currentSide, status, result)
        puts "    " + ("A".."I").to_a.join(" ")
        board.each_with_index do |row, i|
            cells = row.map { |value| SYMBOLS[value] }.join(" ")
            puts "#{(i + 1).to_s.rjust(2)}  #{cells}"
        end
        puts
        
        if status == GameStatus::ENDED
            puts "GAME OVER"
            puts
            if result == GameResult::ATTACKER_WIN
                puts "Player 1 (Attacker) wins!"
            elsif result == GameResult::DEFENDER_WIN
                puts "Player 2 (Defender) wins!"
            elsif result == GameResult::TIE
                puts "The game is a draw."
            end
        else
            if currentSide == Side::ATTACKER
                puts "Current turn: Player 1 (Attacker)"
            else
                puts "Current turn: Player 2 (Defender)"
            end
            puts
        end
    end

    def moveInvalid
        puts "Invalid move. Try again. The board remains unchanged."
        puts
    end

    def showWelcome
        puts "TABLUT"
        puts "Two-player game"
        puts
    end

    def showGameStarted
        puts "New game started."
        puts
        puts "Player 1: Attacker (A)"
        puts "Player 2: Defender (D), including the King (K)"
        puts
        puts "Player 1 moves first."
        puts
    end

    def showHelp
        puts "A = Attacker    D = Defender"
        puts "K = King        . = Empty"
        puts
        puts "To move: move <source> <destination>"
        puts "Example: move D1 C1"
        puts "To concede: forfeit"
        puts
    end

    def commandInvalid
        puts "Invalid command: enter a source and destination. Example: move D1 C1"
        puts
    end

    def moveAccepted(fromRow, fromCol, toRow, toCol)
        from = "#{("A".ord + fromCol).chr}#{fromRow + 1}"
        to = "#{("A".ord + toCol).chr}#{toRow + 1}"
        puts "Move accepted: #{from} to #{to}."
        puts
    end
    
    def pieceCaptured(row, col, pieceType)
        square = "#{("A".ord + col).chr}#{row + 1}"
        puts "Captured: #{PIECE_NAMES[pieceType]} at #{square}"
        puts
    end
end
