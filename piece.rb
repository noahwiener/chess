require 'colorize'
require 'byebug'
require_relative 'board'

class Piece

  attr_accessor :color, :position, :moves, :board

  def initialize(color, position, board)
    @color = color
    @board = board
    @position = position
    @board[position] = self
    @moves = [];
  end

  def to_s
    " #{symbol} ".colorize(self.color)
  end

  def opponent?(piece)
    return false if piece.class == EmptyPiece
    color != piece.color
  end

  def dup_with_board(board)
    self.class.new(@color, @position, board)
  end


  def dup(board)
    self.class.new(color, position.dup, board)
  end

  def valid_moves(color)
    valid_moves = []

    self.possible_moves.each do |move|
      new_board = board.dup
      new_board.make_move!(position, move, color)
      valid_moves << move unless new_board.in_check?(color)
    end
    valid_moves
  end

end
