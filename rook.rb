require_relative 'slideable'

class Rook < Piece
  include Slideable

  def available_directions
    [:up, :down, :left, :right]
  end

  def to_s
    @color == :w ? " ♜ " : " ♜ ".colorize(:black)
  end
end
