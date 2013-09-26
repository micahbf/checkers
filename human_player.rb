require 'colorize'

class HumanPlayer
  ROWS = "abcdefgh"
  
  def initialize(color)
    @color = color
  end
  
  def play_turn(board)
    begin
      board.render
      move_seq = get_move_seq
      play_move(board, move_seq)
    rescue InvalidMoveError => error
      puts "Invalid move: #{error}".red
      retry
    end
  end
  
  private
  
  def get_move_seq
    print "#{@color}> "
    moves = gets.chomp.downcase.split(/\s*,\s*/)
    to_numeric(moves)
  end
  
  def to_numeric(moves)
    moves.map do |move|
      row, col = move.split(//)
      unless ('a'..'h').cover?(row) && (1..8).cover?(col.to_i)
        raise InvalidMoveError, 'input invalid'
      end
      [ROWS.index(row), col.to_i - 1]
    end
  end
  
  def play_move(board, move_seq)
    moving_piece = move_seq.shift
    if board[moving_piece].color != @color
      raise InvalidMoveError, "not your checker" 
    elsif jump_possible?(board) && !is_jump?(moving_piece, move_seq)
      raise InvalidMoveError, "you must jump when possible"
    end
    
    board[moving_piece].perform_moves(move_seq)
  end
  
  def jump_possible?(board)
    board.pieces.select { |p| p.color == @color }.any? do |piece|
      piece.can_jump?
    end
  end
  
  def is_jump?(moving_piece, move_seq)
    piece_row, piece_col = moving_piece
    to_row, to_col = move_seq.first
    if (piece_row - to_row).abs == 2 && (piece_col - to_col).abs == 2
      return true
    end
    false
  end
end