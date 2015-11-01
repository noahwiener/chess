require 'colorize'
require 'byebug'
require_relative 'board'

class Piece

  WHITEPIECES = {
    'King' => "\u2654",
    'Queen' => "\u2655",
    'Rook' => "\u2656",
    'Bishop' => "\u2657",
    'Knight' => "\u2658",
    'Pawn' => "\u2659"
  }
  BLACKPIECES = {
    'King' => "\u265A",
    'Queen' => "\u265B",
    'Rook' => "\u265C",
    'Bishop' => "\u265D",
    'Knight' => "\u265E",
    'Pawn' => "\u265F"
  }

    ROOKMOVES = [
      [1,0],
      [-1,0],
      [0,1],
      [0,-1]
    ]
    BISHOPMOVES = [
      [1,1],
      [-1,-1],
      [1,-1],
      [-1,1]
    ]
    KINGMOVES = ROOKMOVES + BISHOPMOVES


  attr_accessor :color, :position, :moves, :board

  def initialize(color, position, board)
    @color = color
    @board = board
    @position = position
    @moves = []
    @board[*position] = self
  end

  def valid_move?(move)
    @board.valid_move?(self, move)
  end

  def moves
  end

  def to_s
    if color == :w
      " #{WHITEPIECES[self.class.to_s]} ".colorize(:white)
    elsif color == :b
      " #{BLACKPIECES[self.class.to_s]} ".colorize(:black)
    else
      "   "
    end
  end

  def valid_moves
    
  end

end

class SlidingPieces < Piece

  def possible_moves(base_moves)
    moves = []
    base_moves.each do |direction|
      new_move = [direction[0] + @position[0], direction[1] + @position[1]]
      until !valid_move?(new_move)
        moves << new_move
        # debugger
        break if @board.opponent_piece?(self, new_move)
        new_move = [direction[0] + new_move[0], direction[1] + new_move[1]]
      end
    end
    moves
  end
end

class Rook < SlidingPieces
  def list_moves
    @moves = possible_moves(ROOKMOVES)
  end
end

class Bishop < SlidingPieces
  def list_moves
    @moves = possible_moves(BISHOPMOVES)
  end
end

class Queen < SlidingPieces
  def list_moves
    @moves = possible_moves(BISHOPMOVES) + possible_moves(ROOKMOVES)
  end
end



class SteppingPieces < Piece

  KNIGHTMOVES = [[-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1], [2, 1], [1, 2]]

  def possible_moves(base_moves)
    moves = []
    base_moves.each do |direction|
      new_move = [direction[0] + @position[0], direction[1] + @position[1]]
        moves << new_move if valid_move?(new_move)
    end
    moves
  end
end


class Knight < SteppingPieces
  def list_moves
    @moves = possible_moves(KNIGHTMOVES)
  end
end

class King < SteppingPieces
  def list_moves
    @moves = possible_moves(KINGMOVES)
  end
end


class Pawn < Piece
  def initialize(color, position, board, moved = false)
    super(color, position, board)
    @moved = moved
    set_direction
  end

  def set_direction
    if self.color == :w
      @direction = -1
    elsif self.color == :b
      @direction = 1
    end
  end

  def possible_moves
    moves = []
    new_pos = [@position[0] + @direction, @position[1]]
    moves << new_pos if valid_move?(new_pos)
    unless moved?
      new_pos = [@position[0] + (@direction * 2), @position[1]]
      moves << new_pos if valid_move?(new_pos)
    end
    take_piece.each { |diagonal| moves << diagonal }
    moves
  end

  def take_piece
    opposing_pieces = []
    left_pos = [@position[0] + @direction, @position[1] - 1]
    right_pos = [@position[0] + @direction, @position[1] + 1]
    opposing_pieces << left_pos if valid_move?(left_pos) && @board.opponent_piece?(self, left_pos)
    opposing_pieces << right_pos if valid_move?(right_pos) && @board.opponent_piece?(self, right_pos)
    opposing_pieces
  end

  def moved?
    @moved
  end

  def list_moves
    @moves = possible_moves
  end

end


class EmptyPiece < Piece
  def initialize
  end
  # def to_s
  #   "   "
  # end
end
