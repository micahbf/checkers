class ComputerPlayer
  def initialize(color)
    @color = color
  end
  
  def play_turn(board)
    moves = all_possible_moves(board)
    play_move(board, moves.sample)
  end
  
  def play_move(board, move_seq)
    moving_piece = move_seq.shift    
    board[moving_piece].perform_moves(move_seq)
  end
  
  def all_possible_moves(board)
    pieces = board.pieces.select { |p| p.color == @color }
    all_moves = []
    pieces.each do |piece|
      piece.jump_moves.each do |move|
        all_moves << [piece.location, move] 
      end
    end
    return all_moves unless all_moves.empty?
    pieces.each do |piece|
      piece.slide_moves.each do |move|
        all_moves << [piece.location, move] 
      end
    end
    all_moves
  end
end