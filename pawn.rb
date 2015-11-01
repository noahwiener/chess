require_relative 'piece'

class Pawn < Piece
  def initialize(color, pos, board)
    super
    @available_directions = []
  end

  DIRECTIONS = { up: [-1, 0],
                 down: [1, 0],
                 left: [0, -1],
                 right: [0, 1],
                 upright: [-1, 1],
                 upleft: [-1, -1],
                 downright: [1, 1],
                 downleft: [1, -1] }

  def determine_moves
    if @color == :b
      @available_directions << [1, 0] unless @board[[@position[0] + 1, @position[1]]].is_a?(Piece)
    else
      @available_directions << [-1, 0] unless @board[[@position[0] - 1, @position[1]]].is_a?(Piece)
    end

    if in_original_position?(@color)
      if @color == :b
        @available_directions << [2, 0] unless @board[[@position[0] + 1, @position[1]]].is_a?(Piece)
      else
        @available_directions << [-2, 0] unless @board[[@position[0] - 1, @position[1]]].is_a?(Piece)
      end
    end
    check_diagonals(@color)
  end

  def in_original_position?(color)
    if color == :b && @position[0] == 1
      return true
    elsif color == :w && @position[0] == 6
      return true
    end
    false
  end

  def check_diagonals(color)
    possibles = []
    if color == :b
      possibles = [:downright, :downleft]

      possibles.each do |dir|
        pos = [DIRECTIONS[dir][0] + @position[0], DIRECTIONS[dir][1] + @position[1]]
        @available_directions << DIRECTIONS[dir] if @board.valid_move?(@position, pos) && @board[pos].color == :white
      end
    elsif color == :w
      possibles = [:upright, :upleft]

      possibles.each do |dir|
        pos = [DIRECTIONS[dir][0] + @position[0], DIRECTIONS[dir][1] + @position[1]]
        @available_directions << DIRECTIONS[dir] if @board.valid_move?(@position, pos) && @board[pos].color == :black
      end
    end
  end

  def possible_moves
    determine_moves

    result = []
    @available_directions.each do |change|
      new_pos = [change[0] + @position[0], change[1] + @position[1]]
      result << new_pos
    end

    @available_directions = []
    result
  end

  def to_s
    @color == :w ? " ♟ " : " ♟ ".colorize(:black)
  end
end
