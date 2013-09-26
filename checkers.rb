require_relative 'board'
require_relative 'human_player'

class Checkers
  def initialize
    @board = Board.new
    @players = {
      :black => HumanPlayer.new(:black),
      :red => HumanPlayer.new(:red)
    }
  end
  
  def play
    