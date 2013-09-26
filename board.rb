require_relative 'piece'
require_relative 'human_player'
require 'colorize'

class Board
  def initialize
    @players = {
      :black => HumanPlayer.new(:black),
      :red => HumanPlayer.new(:red)
    }
    make_starting_grid
  end
  
  def piece_coord(piece)
    squares.each do |square|
      row, col = square
      return square if self[square].equal?(piece)
    end
  end
  
  def empty?(square)
    row, col = square
    @rows[row][col].nil?
  end
  
  def [](square)
    row, col = square
    @rows[row][col]
  end
  
  def move(from_sq, to_sq)
    self[from_sq], self[to_sq] = nil, self[from_sq]
  end
  
  def capture_between(from_sq, to_sq)
    btw_sq = square_between(from_sq, to_sq)
    self[btw_sq] = nil
  end
  
  def render
    @rows.each_with_index do |row, row_i|
      row.each_with_index do |square, col_i|
        if square.nil?
          bg_color = (dark_square?([row_i, col_i])) ? :white : :light_white
          print " ".colorize(:background => bg_color)
        else
          square.render
        end
      end
      puts
    end
    nil
  end
  
  private
  
  def []=(square, to_set)
    row, col = square
    @rows[row][col] = to_set
  end
  
  def square_between(from_sq, to_sq)
    from_row, from_col = from_sq
    to_row, to_col = to_sq
    
    btw_row = (from_row - to_row) / 2
    btw_col = (from_col - to_col) / 2
    
    [btw_row, btw_col]
  end
  
  def make_starting_grid
    make_blank_grid
    @players.each { |color, player| make_starting_pieces(color) }
  end
  
  def make_blank_grid
    @rows = Array.new(8) { Array.new(8) }
    p @rows
  end
  
  def dark_square?(coord)
    row, col = coord
    (row + col).even?
  end
  
  def make_starting_pieces(color)
    starting_rows = (color == :black) ? [0, 1, 2] : [5, 6, 7]
    starting_rows.each do |row|
      (0..7).each do |col|
        @rows[row][col] = Piece.new(self, color) if dark_square?([row, col])
      end
    end
  end
  
  def squares
    [].tap do |squares|
      (0..7).each { |row| (0..7).each { |col| squares << [row, col ] } }
    end
  end
end