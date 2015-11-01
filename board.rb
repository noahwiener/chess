require 'colorize'
require_relative 'piece'
require 'byebug'

class Board
  attr_accessor :grid
  attr_accessor :selected
  attr_reader :current_player_color

  def initialize
    @empty_piece = EmptyPiece.new
    @grid = Array.new(8) { Array.new(8, @empty_piece) }
    @current_player_color = :w
    add_pieces
  end

  def add_pieces
   @grid[0] = main_row(:b, 0)
   @grid[1] = pawn_row(:b, 1)
   @grid[6] = pawn_row(:w, 6)
   @grid[7] = main_row(:w, 7)
 end

 def pawn_row(color, row)
   Array.new(8) { |col| Pawn.new(color, [row, col], self) }
 end

 def main_row(color, row)
   row_array = Array.new(8)

   (0..2).each do |col|
     if col == 0
       type = Rook
     elsif col == 1
       type = Knight
     else
       type = Bishop
     end
     row_array[col] = type.new(color, [row, col], self)
     row_array[7 - col] = type.new(color, [row, 7 - col], self)
   end

   row_array[3] = Queen.new(color, [row, 3], self)
   row_array[4] = King.new(color, [row, 4], self)

   row_array
 end

 def [](pos)
   row, col = pos
   @grid[row][col]
 end

 def []=(pos, piece)
   row, col = pos
   @grid[row][col] = piece
 end


 def move(start, to)
   piece = self[start]
   piece.position = to
   self[to] = piece
   self[start] = EmptyPiece.new()
 end

  def in_bounds?(pos)
    pos.first.between?(0,7) && pos.last.between?(0,7)
  end

  def valid_move?(piece, move)
    in_bounds?(move) && !same_team?(piece, move)
  end

  def same_team?(piece, square)
    self[*square].color == piece.color
  end

  def opponent_piece?(piece, square)
    self[*square].class != EmptyPiece && self[*square].color != piece.color
  end

  def in_check?(color)
    if color == :w
      king_pos = find_king(:w)
      find_all_moves(:b).include?(king_pos)
    else
      king_pos = find_king(:b)
      find_all_moves(:w).include?(king_pos)
    end
  end

  def find_king(color)
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        if square.class == King && square.color == color
          return [row_idx, col_idx]
        end
      end
    end
  end

  def find_all_moves(color)
    all_moves = []
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        # debugger if square is_a?(Pawn)
        if square.class != EmptyPiece && square.color == color
            all_moves += square.list_moves
        end
      end
    end
    all_moves.uniq
  end


  def checkmate?(color)
    if in_check?(color)
      if find_all_moves.each do |move|
        !valid_moves.include?(move)
      # will be addressed later
      end
    end
    end
  end

  def dup
    dupped = Board.new
    dupped.grid.each_with_index do |row, idx1|
      row.each_with_index do |square, idx2|
        unless square.class == EmptyPiece
          color = self[idx1, idx2].color
          type = self[idx1, idx2].class
          square = type.new(color, [idx1, idx2], dupped)
        end
      end
    end
    dupped
  end
end
