require_relative 'piece'

class Knight < Piece
  def possible_moves
    available_directions = [[2, -1], [2, 1], [-2, -1], [-2, 1], [1, -2], [1, 2], [-1, -2], [-1, 2]]

    result = []
    available_directions.each do |change|
      new_pos = [change[0] + @pos[0], change[1] + @pos[1]]
      result << new_pos if @board.valid_move?(@pos, new_pos)
    end
    result
  end

  def to_s
    @color == :white ? " ♞ " : " ♞ ".colorize(:black)
  end
end
