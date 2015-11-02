# Chess

This fully interactive, pure-ruby chess game runs in the terminal.  Color cues in the game not only illuminate the board, but also show players where they can move and what pieces they can take.  The game takes advantage of modules, inheritance, and manipulation of user input for a great chess experience.

To play the game, clone this repo, navigate to the project folder, and enter <code>ruby game.rb</code>

## Demo

<img src="https://i.gyazo.com/a0539fbb1ef3ac225fb39356686715c3.gif" height="400" alt="gameplay-gif">

## Features

### Deep Board Duplication

In order to check whether moves would put a player in check, I made a deep duplication of the board, performed the move, and checked the result.

`def dup
    duped = Board.new(true)
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        if square.class == EmptyPiece
          duped.grid[row_idx][col_idx] = EmptyPiece.new
        else
          duped.grid[row_idx][col_idx] = square.dup_with_board(duped)
        end
      end
    end
    duped
  end`

`def valid_moves(color)
    return [] if self.color != color
    valid_moves = []

      self.possible_moves.each do |move|
        new_board = board.dup
        new_board.make_move!(position, move)
        valid_moves << move unless new_board.in_check?(color)
      end
    valid_moves
  end`


### Slideable Piece inheritance

Object-Oriented Programming--all pieces inherit from a Piece class, and the Bishop, Rook, and Queen all inherit from the Slideable module for their multi-tile movement.

### Cursorable

Navigate through the game with simple arrow key commands.

`def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end
  def handle_key(key)
    case key
    when :ctrl_c
      exit 0
    when :return, :space
      @cursor_pos
    when :left, :right, :up, :down
      update_pos(MOVES[key])
      nil
    else
      puts key
    end
  end
  def read_char
    STDIN.echo = false
    STDIN.raw!
    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!
    return input
  end`
