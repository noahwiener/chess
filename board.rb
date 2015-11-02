require_relative 'display'
require_relative 'pieces'
require 'byebug'

class Board
  include Cursorable

  attr_accessor :grid, :display

  def initialize(duped = false)
    @empty_piece = EmptyPiece.new
    @grid = Array.new(8) { Array.new(8, @empty_piece) }
    add_starting_pieces unless duped
  end

  def make_move(color, from, to)
    if self[from].valid_moves(color).include?(to)
      if valid_move?(from, to)
        make_move!(from, to, color)
      end
    end
    promote_pawns
  end

  def make_move!(from, to, color)
    self[to] = self[from]
    self[to].position = to
    self[from] = EmptyPiece.new
  end


  def in_check?(color)
    opponent = opposite_color(color)
    king_pos = find_king(color)
    find_all_moves(opponent).include?(king_pos)
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
        if square.class != EmptyPiece && square.color == color
            all_moves += square.possible_moves
        end
      end
    end
    all_moves.uniq
  end


  def checkmate?(color)
    if in_check?(color)
      opponent = opposite_color(color)
      @grid.each do |row|
        row.each do |square|
          if square.class != EmptyPiece && square.color == opponent
              return false if square.valid_moves(opponent).count > 0
          end
        end
      end
      return true
    end
    false
  end

  def stalemate?(color)
    unless in_check?(color)
      opponent = opposite_color(color)
      @grid.each do |row|
        row.each do |square|
          if square.class != EmptyPiece && square.color == opponent
              return false if square.valid_moves(opponent).count > 0
          end
        end
      end
      return true
    end
    false
  end


  def dup
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
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def valid_move?(from, to)
  return false if self[from].class == EmptyPiece
   if in_bounds?(to) && (self[to].class == EmptyPiece || self[from].opponent?(self[to]))
     true
   else
     false
   end
  end

  def in_bounds?(pos)
    pos.first.between?(0,7) && pos.last.between?(0,7)
  end

private

  def opposite_color(color)
    if color == :w
      :b
    else
      :w
    end
  end

  def add_starting_pieces
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


  def opponent_piece?(piece, square)
    self[*square].class != EmptyPiece && self[*square].color != piece.color
  end

  def promote_pawns
    promotion = []
    white = self.grid[0].select { |piece| piece.is_a?(Pawn) && piece.color == :w }
    black = self.grid[7].select { |piece| piece.is_a?(Pawn) && piece.color == :b }

    promotion = white + black
    promotion.each do |piece|
      self.grid[piece.pos[0]][piece.pos[1]] = Queen.new(piece.color, piece.pos, self)
    end
  end

end
