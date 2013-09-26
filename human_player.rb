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
    end
    
    board[moving_piece].perform_moves(move_seq)
  end
end