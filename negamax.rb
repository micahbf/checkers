module Negamax
  def best_move(board)
    root_node = MoveNode.new(board, @color, nil)
    color_sign = (@color == :black) ? 1 : -1
    
    move_nodes = {}
    root_node.children.each do |node|
      move_nodes[node] = negamax(node, @depth, -72.0, 72.0, color_sign) 
    end
    
    p move_nodes.sort_by { |k, v| v }.last.first.move_seq
  end
    
  
  def negamax(node, depth, alpha, beta, color_sign)
    return color_sign * node.value if depth == 0 || node.terminal?
    best_value = -72.0
    
    node.children.each do |child|
      child_value = -negamax(child, depth - 1, -beta, -alpha, -color_sign)
      best_value = [best_value, child_value].max
      alpha = [alpha, child_value].max
      break if alpha >= beta
    end
    
    best_value
  end

  class MoveNode
    attr_reader :move_seq, :value
    
    def initialize(board, color, move_seq)
      @board = board
      @color = color
      @move_seq = move_seq
      @value = @board.evaluate
    end
    
    def children
      children = []
      @board.pieces(@color).each do |piece|
        piece.all_move_seqs.each do |move_seq|
          child_board = @board.dup
          full_seq = move_seq.dup
          full_seq.unshift(piece.location) unless full_seq.first == piece.location
          move_seq.shift if move_seq.first == piece.location
          child_board[piece.location].perform_moves(move_seq)
          children << MoveNode.new(child_board, piece.opp_color, full_seq)
        end
      end
      children
    end
    
    def terminal?
      @board.pieces.all? { |p| p.color == :black } ||
        @board.pieces.all? { |p| p.color == :red }
    end
    
    def inspect
      { id: self.object_id,
        color: @color,
        move_seq: @move_seq,
        value: @value
      }
    end
  end
end
