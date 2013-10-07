require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

class Checkers
  def initialize
    @players = {
      :black => ComputerPlayer.new(:black, 2),
      :red => ComputerPlayer.new(:red, 2)
    }
    @board = Board.new(@players)
  end
  
  def play
    until @board.won?
      current_player = (current_player == :black) ? :red : :black
      @players[current_player].play_turn(@board)
      @board.render
      gets
    end
    
    puts "#{current_player} wins!"
    @board.render 
  end
end

if __FILE__ == $PROGRAM_NAME
  c = Checkers.new
  c.play
end