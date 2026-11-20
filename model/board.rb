require_relative "enums"
require_relative "square"
require_relative "piece"

class Board
  
  #9x9 board with throne at 4,4
  BOARD_LENGTH = 9
  THRONE_ROW = 4
  THRONE_COL = 4

  #for each of the four directions
  DIRECTIONS = [[-1,0],[1,0],[0,-1],[0,1]]

  #defender positions
  DEFENDER_START = [[2,4],[3,4],[5,4],[6,4],[4,2],[4, 3],[4,5],[4,6]]

  #attacker positions
  ATTACKER_START = [[0,3],[0,4], [0,5],[1,4],
                    [8,3],[8,4],[8,5],[7,4],
                    [3,0],[4,0],[5,0],[4,1],
                    [3,8],[4,8],[5,8],[4,7]]

  #allocates the 81 square objects (marking the center square as the throne)
  #and calls setUp().
  def initialize(attacker, defender)

    @squares = Array.new(BOARD_LENGTH)

    for row in 0...BOARD_LENGTH

      @squares[row] = Array.new(BOARD_LENGTH)

      for col in 0...BOARD_LENGTH

        isThrone = (row == THRONE_ROW && col == THRONE_COL)
        @squares[row][col] = Square.new(row, col, isThrone)

      end
    end

    @kingSquare = nil
    setUp(attacker, defender)

  end

  #setups board in standard Tablu starting layout. 
  def setUp(attacker, defender)
    #clear every square
    for row in 0...BOARD_LENGTH
      for col in 0...BOARD_LENGTH
        @squares[row][col].removePiece
      end
    end

    #create the king and place it on (4,4). Set kingSquare to that square.
    @kingSquare = @squares[THRONE_ROW][THRONE_COL]
    @kingSquare.setPiece(Piece.new(PieceType::KING, defender))

    #creating 8 defenders
    DEFENDER_START.each do |position|

      @squares[position[0]][position[1]].setPiece(Piece.new(PieceType::DEFENDER, defender))
      
    end


    ATTACKER_START.each do |position|

      @squares[position[0]][position[1]].setPiece(Piece.new(PieceType::ATTACKER, attacker))

    end

  end

  def getSquare(row, col)

    if row < 0 || row >= BOARD_LENGTH || col < 0 || col >= BOARD_LENGTH
     
      return nil

    end

    return @squares[row][col]

  end

  #returns the Piece on that square, or null if it is empty or out of range.
  def getPieceAt(row, col)

    square = getSquare(row, col)

    if square == nil

      return nil

    end

    return square.getPiece
  end

  #true only if coordinates are on the board and the square holds no piece.
  def isEmpty(row, col)

    square = getSquare(row, col)

    if square == nil

      return false

    end

    return square.getPiece == nil
  end

  #checks for path 
  def isPathClear(fromRow, fromCol, toRow, toCol)
   
    #if both the row and column differ, or neither differs, return false.
    if fromRow != toRow && fromCol != toCol
      return false
    end
    if fromRow == toRow && fromCol == toCol
      return false
    end

    #computes dr = sign(toRow - fromRow), dc = sign(toCol - fromCol)
    dr = 0
    if toRow > fromRow

      dr = 1

    elsif toRow < fromRow

      dr = -1
    end

    dc = 0

    if toCol > fromCol

      dc = 1

    elsif toCol < fromCol

      dc = -1
    end


    #starting at (fromRow + dr, fromCol + dc), walk until reaching the destination.
    row = fromRow + dr
    col = fromCol + dc
    while row != toRow || col != toCol

      #if any visited square holds a piece then return false.
      if @squares[row][col].getPiece != nil
        return false
      end

      row = row + dr
      col = col + dc

    end

    return true

  end

  #the throne is restricted unless piece is the king
  def isRestricted(piece, row, col)

    if @squares[row][col].isThrone && !piece.isKing
      return true
    end

    return false
  end

  #relocates the piece
  def movePiece(fromRow, fromCol, toRow, toCol)
    source = @squares[fromRow][fromCol]
    destination = @squares[toRow][toCol]

    piece = source.getPiece
    source.removePiece
    destination.setPiece(piece)

    #if the piece is king set kingSquare to the destination square
    if piece.isKing
      @kingSquare = destination
    end
  end

  #removes every enemy piece captured by the piece 
  def removeCaptures(row, col)
    mover = getPieceAt(row, col)
    owner = mover.getOwner
    captured = []

    DIRECTIONS.each do |direction|
      dr = direction[0]
      dc = direction[1]

      adjacentSquare = getSquare(row + dr, col + dc)
      farSquare = getSquare(row + 2 * dr, col + 2 * dc)

      #skip adjacent is off board, empty, holds a piece of the mover's own side,
      #or holds the king.
      if adjacentSquare == nil
        next
      end
      adjacent = adjacentSquare.getPiece
      if adjacent == nil || owner.ownsPiece(adjacent) || adjacent.isKing
        next
      end

      #it is on the board and holds a friendly piece or its empty throne.
      if farSquare == nil
        next
      end
      far = farSquare.getPiece
      isCaptured = false
      if far == nil && farSquare.isThrone
        isCaptured = true
      elsif far != nil && owner.ownsPiece(far)
        isCaptured = true
      end

      #if captured then clear adjacent square and add the Piece to the result.
      if isCaptured
        adjacentSquare.removePiece
        captured.push(adjacent)
      end
    end

    return captured
    
  end

  
  #If any neighbor is off the board, empty, or a defender, return false. 
  #Returns false if the king no longer exists.
  def isKingSurrounded
    if @kingSquare == nil || @kingSquare.getPiece == nil || !@kingSquare.getPiece.isKing
      return false
    end

    kingRow = @kingSquare.getPos[0]
    kingCol = @kingSquare.getPos[1]

    DIRECTIONS.each do |direction|
      neighbour = getSquare(kingRow + direction[0], kingCol + direction[1])
      if neighbour == nil
        return false
      end

      piece = neighbour.getPiece
      if piece == nil
        if !neighbour.isThrone
          return false
        end
      elsif piece.getType != PieceType::ATTACKER
        return false
      end
    end

    return true
  end

  #true if kingSquare is non-null and its row or column is 0 or 8
  def isKingOnEdge
    if @kingSquare == nil
      return false
    end

    kingRow = @kingSquare.getPos[0]
    kingCol = @kingSquare.getPos[1]
    if kingRow == 0 || kingRow == 8 || kingCol == 0 || kingCol == 8
      return true
    end

    return false
  end

  #the game is drawn if a player cannot move
  def hasLegalMove(side)

    for row in 0...BOARD_LENGTH
      for col in 0...BOARD_LENGTH

        piece = @squares[row][col].getPiece

        if piece == nil || piece.getOwner.getSide != side

          next
        end

        DIRECTIONS.each do |direction|

          nextRow = row + direction[0]
          nextCol = col + direction[1]

          while isEmpty(nextRow, nextCol)

            if !isRestricted(piece, nextRow, nextCol)

              return true
            end

            nextRow = nextRow + direction[0]
            nextCol = nextCol + direction[1]

          end
        end

      end

    end

    return false
  end

  #the game is drawn if a position is repeated
  def getPositionKey
   
    key = ""

    for row in 0...BOARD_LENGTH
      for col in 0...BOARD_LENGTH

        piece = @squares[row][col].getPiece

        if piece == nil
          key = key + "."

        elsif piece.getType == PieceType::ATTACKER
          
          key = key + "A"

        elsif piece.getType == PieceType::DEFENDER

          key = key + "D"

        else

          key = key + "K"

        end

      end
    end

    return key
 
  end
end
