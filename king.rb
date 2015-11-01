class King < Piece

  DIRECTIONS = { up: [0, -1],
                 down: [0, 1],
                 left: [-1, 0],
                 right: [1, 0],
                 upright: [1, -1],
                 upleft: [-1, -1],
                 downright: [1, 1],
                 downleft: [-1, 1] }

  def possible_moves
    possible_moves = []
    DIRECTIONS.keys.each do |dir|
      new_pos = [@position[0] + DIRECTIONS[dir][0], @position[1] + DIRECTIONS[dir][1]]
      possible_moves << new_pos if @board.valid_move?(@position, new_pos)
    end
    possible_moves
  end


  def to_s
    @color == :w ? " ♚ " : " ♚ ".colorize(:black)
  end
end
