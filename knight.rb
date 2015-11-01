class Knight < Piece
  def possible_moves
    available_directions = [[2, -1], [2, 1], [-2, -1], [-2, 1], [1, -2], [1, 2], [-1, -2], [-1, 2]]

    result = []
    available_directions.each do |change|
      new_pos = [change[0] + @position[0], change[1] + @position[1]]
      result << new_pos if @board.valid_move?(@position, new_pos)
    end
    result
  end

  def to_s
    @color == :w ? " ♞ " : " ♞ ".colorize(:black)
  end
end
