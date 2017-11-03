class PokerController < ApplicationController
  def index
    @poker           = PokerService.new
    @one_played      = PokerService.new(@poker.token)
    @one_delear      = @one_played.delear.faces
    @second_played   = PokerService.new(@poker.token)
    @second_delear   = @second_played.delear.faces
    @one_evaluate    = @one_played.evaluate
    @one_ranking     = @one_played.ranking
    @second_evaluate = @second_played.evaluate
    @second_ranking  = @second_played.ranking
  end
end
