require 'colorize'

class InvalidMoveError < RuntimeError
end

class Piece
  SLIDE_MOVES_UP = [[-1, 1], [-1, -1]]
  SLIDE_MOVES_DOWN = [[1, 1], [1, -1]]
  JUMP_MOVES_UP = [[-2, 2], [-2, -2]]
  JUMP_MOVES_DOWN = [[2, 2], [2, -2]]
  PROMOTION_ROWS = {:black => 7, :red => 0}
  MARKS = {:pawn => "\u2b24 ", :king => "\u2605 "}
  
  attr_reader :color
  
  def initialize(board, color, king = false)
    @board = board
    @color = color
    @king = king
  end
  
  def render
    type = @king ? :king : :pawn
    print MARKS[type].colorize(:color => @color, :background => :white)
  end
  
  def dup(board)
    Piece.new(board, @color, @king)
  end
  
  def perform_moves(moves)
    if valid_move_seq?(moves)
      perform_moves!(moves)
    else
      raise InvalidMoveError, "move invalid"
    end
  end
  
  def location
    @board.piece_coord(self)
  end
  
  def can_jump?
    jump_moves.count > 0 ? true : false
  end
  
  def all_move_seqs
    can_jump? ? jump_moves : slide_moves
  end
  
  def king?
    @king
  end
  
  def on_side?
    [0, 7].include?(location[1])
  end
  
  def opp_color
    @color == :black ? :red : :black
  end
  
  protected
  
  def perform_moves!(moves)
    jumps_only = (moves.count > 1) ? true : false
    moves.each do |move|
      puts "moves: #{moves} location: #{location} move: #{move}"
      if slide_moves.include?([move])
        raise InvalidMoveError, "Piece must jump" if jumps_only
        perform_slide(move)
      elsif jump_moves.any? { |ms| ms.include?(move) }
        perform_jump(move)
      else
        raise InvalidMoveError, "Move to #{move} not possible"
      end
    end
  end
  
  def jump_moves
    jump_nodes.map do |nodes| 
      nodes.map { |node| trace_path(node)  }
    end.flatten(1)
  end
  
  def perform_jump!(dest_square)
    @board.capture_between(location, dest_square)
    @board.move(location, dest_square)
    promotion_check
    true
  end
  
  def jump_nodes(parent = nil)
    self_node = JumpMove.new(parent, self, [])
    children = valid_jumps.map do |jump|
      child_piece = dup_and_jump(jump)
      child_piece.jump_nodes(self_node)
    end
    if children.empty?
      return self_node
    else
      return children
    end
  end
  
  private
  
  def valid_jumps
    poss_jump_moves = resulting_locations(jump_vectors)
    jumped_squares = resulting_locations(slide_vectors)
    
    poss_jump_moves.zip(jumped_squares).select do |move|
      valid_jump_move?(move)
    end.map do |move|
      dest, between = move
      dest
    end
  end
  
  def jump_vectors
    unless king?
      return (@color == :black) ? JUMP_MOVES_DOWN : JUMP_MOVES_UP
    else
      return JUMP_MOVES_DOWN + JUMP_MOVES_UP
    end
  end
  
  def slide_vectors
    unless king?
      slide_moves = (@color == :black) ? SLIDE_MOVES_DOWN : SLIDE_MOVES_UP
    else
      slide_moves = SLIDE_MOVES_DOWN + SLIDE_MOVES_UP
    end
  end
  
  def valid_jump_move?(move)
    #requires a zipped destination and between square
    dest, between = move
    on_board?(dest) &&
      @board.empty?(dest) &&
      !@board.empty?(between) && 
      @board[between].color != @color
  end
  
  def dup_and_jump(move)
    test_board = @board.dup
    test_board[location].perform_jump!(move)
    test_board[move]
  end
  
  def trace_path(jump_node)
    path = []
    curr_node = jump_node
    until curr_node.nil?
      path.unshift(curr_node.piece.location)
      curr_node = curr_node.parent
    end
    return path
  end
  
  def slide_moves    
    resulting_locations(slide_vectors).select do |dest|
      on_board?(dest) && @board.empty?(dest)
    end.map do |dest|
      [dest]
    end
  end
  
  def resulting_locations(moves)
    moves.map do |move|
      row, col = location
      row_diff, col_diff = move

      [row + row_diff, col + col_diff]
    end
  end
  
  def on_board?(coord)
    coord.all? { |c| (0..7).cover?(c) }
  end
  
  def valid_move_seq?(moves)
    duped_board = @board.dup
    begin
      duped_board[location].perform_moves!(moves)
    rescue InvalidMoveError => e
      puts e
      return false
    else
      return true
    end
  end
  
  def perform_slide(dest_square)
    unless slide_moves.include?([dest_square])
      raise InvalidMoveError, "piece cannot move there"
    end
    @board.move(location, dest_square)
    promotion_check
    true
  end
  
  def perform_jump(dest_square)
    unless jump_moves.any? { |ms| ms.include?(dest_square) }
      raise InvalidMoveError, "piece cannot jump there"
    end
    @board.capture_between(location, dest_square)
    @board.move(location, dest_square)
    promotion_check
    true
  end
  
  def promotion_check
    return if @king
    row, col = location
    if row == PROMOTION_ROWS[@color]
      @king = true
    end
  end
end

JumpMove = Struct.new(:parent, :piece, :children)