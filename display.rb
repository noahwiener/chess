require_relative 'cursorable'

class Display
include Cursorable
  attr_reader :board
  attr_accessor :selected

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = nil
    @queue = []
    render
  end

  def render
    system('clear')
    @board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        if @selected == [row_idx, col_idx]
          print square.to_s.colorize(background: :yellow)
        elsif @cursor_pos == [row_idx, col_idx]
          print square.to_s.colorize(background: :green)
        elsif (row_idx + col_idx).even?
            print square.to_s.colorize(background: :blue)
        elsif (row_idx + col_idx).odd?
          print square.to_s.colorize(background: :red)
        end
      end
      print "\n"
    end
    nil
  end

  def select_squares
    @selected = move_cursor
    move_cursor
  end

  def move_cursor
    until get_input
      system("clear")
      render
    end
    @cursor_pos
  end


  def render_on_input
    render
    until @queue.length == 2
      until get_input == "\r"
        render
      end
    end
    @board.make_move(@queue.shift, @queue.shift)
  end


end
