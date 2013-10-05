module Negamax
  def best_move
    root_node = MoveNode.new(@board, @color, nil)
    color_sign = (@color == :black) ? 1 : -1
    
    move_nodes = {}
    root_node.children.each do |node|
      move_nodes[node] = negamax(node, @depth, -72.0, 72.0, color_sign) 
    end
    
    move_nodes.max_by{ |k, v| v }.move_seq
  end
    
  
  def negamax(node, depth, alpha, beta, color_sign)
    return color_sign * node.value if depth == 0 || node.terminal?
    best_value = -72.0
    
    node.children.each do |child|
      child_value = -negamax(child, depth - 1, -beta, -alpha, -color_sign)
      best_value = max(best_value, child_value)
      alpha = max(alpha, child_value)
      break if alpha >= beta
    end
    
    best_value
  end

  class MoveNode
    attr_reader move_seq
    
    def initialize(board, color, move_seq)
      @board = board
      @color = color
      @move_seq = move_seq
      @value = @board.evaluate
    end
    
    def children
      children = []
      @board.pieces(color).each do |piece|
        piece.all_move_seqs.each do |move_seq|
          child_board = @board.dup
          child_board[piece].perform_moves(move_seq)
          full_seq = move_seq.dup.unshift(piece.location)
          children << MoveNode.new(child_board, piece.opp_color, full_seq)
        end
      end
      children
    end
  end
end
