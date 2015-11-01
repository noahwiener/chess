require 'colorize'
class Tile

  def initialize(piece = nil)
    @occupied = piece
  end

  def occupied?
    @occupied
  end

  def inspect
    if occupied?
      " #{occupied} ".colorize(background: :yellow)
    else
      "   ".colorize(background: :red)
    end
  end


end
