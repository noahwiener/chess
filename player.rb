require_relative 'display'
require 'byebug'

class Player
  attr_reader :color, :display
  attr_accessor :name, :message

  def initialize(color, display)
    @color = color
    @display = display
    @name = ""
    @message = ""
  end

  def make_move
    from_pos, to_pos = nil, nil

    until from_pos && to_pos
      display.render
      if from_pos
        puts "#{self.name}, select a place to move that piece."
        to_pos = display.get_input
      else
        if message != ""
          puts message
        end
        puts "It is #{self.name}'s turn."
        puts "#{self.name}, select a piece to move"
        from_pos = display.get_input
        display.selected = from_pos
      end
    end
    display.selected = nil
    [from_pos, to_pos]
  end
end
