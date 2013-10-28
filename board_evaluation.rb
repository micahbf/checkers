module BoardEvaluation
  COLOR_SIGNS = {:black => 1, :red => -1}
  
  def evaluate
    piecewise_score
  end
  
  private
  
  def piecewise_score
    pieces_score = 0
    self.pieces.each do |piece|
      sign = COLOR_SIGNS[piece.color]
      pieces_score += 1.0 * sign
      pieces_score += 0.5 * sign if piece.king? #TODO: unless trapped
      pieces_score += 0.2 * sign if piece.on_side?
      #TODO: better positional weighting
      #TODO: runaway checker (unimpeded path to king)
    end
    pieces_score
  end
end