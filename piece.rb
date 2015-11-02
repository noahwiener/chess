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

  def dup_with_board(new_board)
    self.class.new(color, position.dup, new_board)
  end

  def valid_moves(color)
    return [] if self.color != color
    valid_moves = []

    self.possible_moves.each do |move|
      new_board = board.dup
      new_board.make_move!(position, move)
      valid_moves << move unless new_board.in_check?(color)
    end
    valid_moves
  end

end
