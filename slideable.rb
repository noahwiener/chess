require 'byebug'

module Slideable
  DIRECTIONS = { up: [0, -1],
                 down: [0, 1],
                 left: [-1, 0],
                 right: [1, 0],
                 upright: [1, -1],
                 upleft: [-1, -1],
                 downright: [1, 1],
                 downleft: [-1, 1] }

  def possible_moves
    possibilities = []

    available_directions.each do |dir|
      current_pos = @position
      new_pos = [@position[0] + DIRECTIONS[dir][0], @position[1] + DIRECTIONS[dir][1]]

      while @board.valid_move?(current_pos, new_pos)
        possibilities << new_pos
        break if @board[new_pos].class != EmptyPiece && @board[new_pos].color != color
        test_pos = new_pos
        new_pos = [test_pos[0] + DIRECTIONS[dir][0], test_pos[1] + DIRECTIONS[dir][1]]
      end
    end
    possibilities
  end
end
