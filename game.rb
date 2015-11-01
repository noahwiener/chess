require_relative 'board'

class Game
  def initialize(white, black)
    @colors = [:w, :b]
    @board = Board.new
    @players = [white,black]
    player_assignments
    @current = @players.first
    play
  end

  def player_assignments
    puts "Player one will play as white.  Enter player one's name"
    @players[0].name = gets.chomp
    @players[0].color = :w

    puts "Player two will play as black. Enter player two's name"
    @players[1].name = gets.chomp
    @players[1].color = :b
  end

  def play
    puts "Welcome to Noah's Ruby Chess!"
    puts "#{@players[0].name} is white and goes first"
    puts "#{@players[1].name} is black"
    puts "Have fun!"
    sleep 2

    @board.display.render(@current.color)
    take_turn until game_over?
    if checkmate?
      puts "Checkmate! #{@current.name} wins!"
    else
      puts "It's a draw!"
    end
  end

  def take_turn
    player_input = @current.get_move
    @board.make_move(player_input)
    @board.display.render(@current.color)
    switch_players!
  end

  def switch_players!
    @players.reverse!
    @current = @players[0]
  end

  def game_over?
    @colors.any? { |color| @board.checkmate?(color) || @board.stalemate?(color)}
  end

  def checkmate?
    @colors.any? { |color| @board.checkmate?(color) }
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new(Player.new, Player.new)
end
