class Board
  def initalize
    make_starting_grid
    @players = {
      :black => HumanPlayer.new(:black)
      :red => HumanPlayer.new(:red)
    }
  end
  
  def piece_coord(piece)
    squares.each do |square|
      row, col = square
      return square if @rows[row][col].equal?(piece)
    end
  end
  
  def empty?(square)
    row, col = square
    @rows[row][col].nil?
  end
  
  private
  
  def make_starting_grid
    make_blank_grid
    @players.each { |color, player| make_starting_pieces(color) }
  end
  
  def make_blank_grid
    @rows = Array.new(8) { Array.new(8) }
  end
  
  def dark_square?(coord)
    row, col = coord
    (row + col).even?
  end
  
  def make_starting_pieces(color)
    starting_rows = (color == :black) ? [0, 1, 2] : [5, 6, 7]
    starting_rows.each do |row|
      row.each_index do |col|
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