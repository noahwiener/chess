require_relative 'slideable'

class Queen < Piece
  include Slideable

  def available_directions
    [:up, :down, :left, :right, :upright, :upleft, :downright, :downleft]
  end

  def to_s
    @color == :w ? " ♛ " : " ♛ ".colorize(:black)
  end
end
