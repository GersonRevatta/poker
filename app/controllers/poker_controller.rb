class PokerController < ApplicationController
  def index
    @poker   = PokerService.new
    @hand    = @poker.delear
    @ranking = @poker.evaluate
  end
end
