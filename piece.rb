def Piece
  def initialize(board, color, king = false)
    @board = board
    @color = color
    @king = king
  end
  
  def location
    @board.piece_coord(self)
  end
end