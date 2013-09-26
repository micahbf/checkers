require 'colorize'

class InvalidMoveError < RuntimeError
end

class Piece
  SLIDE_MOVES_UP = [[-1, 1], [-1, -1]]
  SLIDE_MOVES_DOWN = [[1, 1], [1, -1]]
  JUMP_MOVES_UP = [[-2, 2], [-2, -2]]
  JUMP_MOVES_DOWN = [[2, 2], [2, -2]]
  
  attr_reader :color
  
  def initialize(board, color, king = false)
    @board = board
    @color = color
    @king = king
  end
  
  def render
    print "@".colorize(:color => @color, :background => :white)
  end
  
  def perform_slide(dest_square)
    unless slide_moves.include?(dest_square)
      raise InvalidMoveError, "piece cannot move there"
    end
    @board.move(location, dest_square)
    true
  end
  
  def perform_jump(dest_square)
    unless jump_moves.include?(dest_square)
      raise InvalidMoveError, "piece cannot jump there"
    end
    @board.capture_between(location, dest_square)
    @board.move(location, dest_square)
    true
  end
  
  def perform_moves!(moves)
    jumps_only = (moves.count > 1) ? true : false
    moves.each do |move|
      if slide_moves.include?(move)
        raise InvalidMoveError if jumps_only
        perform_slide(move)
      elsif jump_moves.include?(move)
        perform_jump(move)
      else
        raise InvalidMoveError, "Move to #{move} not possible"
      end
    end
  end
  
  private
  
  def location
    @board.piece_coord(self)
  end
  
  def king?
    @king
  end
  
  def slide_moves
    unless king?
      slide_moves = (@color == :black) ? SLIDE_MOVES_DOWN : SLIDE_MOVES_UP
    else
      slide_moves = SLIDE_MOVES_DOWN + SLIDE_MOVES_UP
    end
    
    slide_moves.map do |move|
      row, col = location
      row_diff, col_diff = move

      [row + row_diff, col + col_diff]
    end.select do |dest|
      @board.empty?(dest)
    end
  end
  
  def jump_moves
    unless king?
      jump_moves = (@color == :black) ? JUMP_MOVES_DOWN : JUMP_MOVES_UP
    else
      jump_moves = JUMP_MOVES_DOWN + JUMP_MOVES_UP
    end
    
    jumped_squares = jump_moves.map { |m| m.map { |c| c / 2 } }
  
    jump_moves.map! { |move| move.zip(location).map { |m, l| m + l } }
    jumped_squares.map! { |move| move.zip(location).map { |m, l| m + l } }
    
    jump_moves.zip(jumped_squares).select do |move|
      dest, between = move
      @board.empty?(dest) &&
        !@board.empty?(between) && 
        @board[between].color != @color
    end.map do |move|
      dest, between = move
      dest
    end
  end
end