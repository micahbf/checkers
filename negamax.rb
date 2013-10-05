module Negamax
  def negamax(node, depth, alpha, beta, color)
    
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
