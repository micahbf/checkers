require_relative 'board'
require_relative 'human_player'

class Checkers
  def initialize
    @players = {
      :black => HumanPlayer.new(:black),
      :red => HumanPlayer.new(:red)
    }
    @board = Board.new(@players)
  end
  
  def play
    until @board.won?
      current_player = (current_player == :black) ? :red : :black
      @board.render
      current_player.play_turn(@board)
    end
    
    puts "#{current_player} wins!"
    @board.render 
  end
end