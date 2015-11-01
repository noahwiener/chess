class Queen < Piece
  include Slideable

  def available_directions
    [:up, :down, :left, :right, :upright, :upleft, :downright, :downleft]
  end

  def to_s
    @color == :white ? " ♛ " : " ♛ ".colorize(:black)
  end
end
