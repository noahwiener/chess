require_relative 'piece'

class Bishop < Piece
  include Slideable

  def available_directions
    [:upright, :upleft, :downright, :downleft]
  end

  def to_s
    @color == :w ? " ♝ " : " ♝ ".colorize(:black)
  end
end
