module Negamax
  def negamax(node, depth, alpha, beta, color_sign)
    return color * node.value if depth == 0 || node.terminal?
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
    include Comparable
    
    def initialize(board, color)
      @board = board
      @color = color
      @value = @board.evaluate
    end
    
    def <=>
    end
  end
end
