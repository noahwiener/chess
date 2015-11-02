require_relative 'board'
require_relative 'player'
require 'byebug'

class Game

  attr_reader :board, :display, :players, :current

  def initialize
    @colors = [:w, :b]
    @board = Board.new
    @display = Display.new(@board)
    @players = [Player.new(:w, @display), Player.new(:b, @display)]
    player_assignments
    @current = @players.first
    play
  end

  def player_assignments
    puts "Player one will play as white.  Enter player one's name"
    @players[0].name = gets.chomp

    puts "Player two will play as black. Enter player two's name"
    @players[1].name = gets.chomp
  end

  def play
    puts "Welcome to Noah's Ruby Chess!"
    puts "#{@players[0].name} is white and goes first"
    puts "#{@players[1].name} is black"
    puts "Have fun!"
    sleep 2

    display.render
    take_turn until game_over?
    if checkmate?
      puts "Checkmate! #{@players.last.name} wins!"
      sleep 5
    else
      puts "It's a draw!"
      sleep 5
    end
  end

  private

  def take_turn
    until board.move_made
      player_input = @current.make_move
      board.make_move(@current.color, player_input[0], player_input[1])
      display.render
    end
    board.move_made = false
    switch_players!
    if board.in_check?(@current.color)
      puts "#{@players.last.name} put #{@current.name} in check"
      sleep 1
    end
  end

  def switch_players!
    @players.reverse!
    @current = @players[0]
  end

  def game_over?
    @colors.any? { |color| board.checkmate?(color) || board.stalemate?(color)}
  end

  def checkmate?
    @colors.any? { |color| board.checkmate?(color) }
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new
end
