require_relative 'display'

class Player
  attr_reader :color, :display
  attr_accessor :name

  def initialize(color, display)
    @color = color
    @display = display
    @name = ""
  end

  def make_move
    from_pos, to_pos = nil, nil

    until from_pos && to_pos
      display.render

      if from_pos
        puts "#{self.name}'s turn. Move to where?"
        to_pos = display.get_input
        display.selected = nil
      else
        puts "#{self.name}'s turn. Move from where?"
        from_pos = display.get_input
        display.selected = from_pos
      end
    end

    [from_pos, to_pos]
  end
end
