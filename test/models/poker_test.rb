require 'test_helper'

class PokerTest < ActiveSupport::TestCase
  # 1. High Card: Highest value card. Order is 2, 3, 4, 5, 6, 7, 8, 9, Ten, Jack, Queen, King,
  # Ace.
  # 2. One Pair: Two cards of the same value.
  # 3. Two Pairs: Two different pairs.
  # 4. Three of a Kind: Three cards of the same value.
  # 5. Straight: All cards are consecutive values.
  # 6. Flush: All cards of the same suit.
  # 7. Full House: Three of a kind and a pair.
  # 8. Four of a Kind: Four cards of the same value.
  # 9. Straight Flush: All cards are consecutive values of same suit.
  # 10. Royal Flush: Ten, Jack, Queen, King, Ace of same suit.
  
  def setup
    @hand = [{"number"=>"8", "suit"=>"spades"}, 
             {"number"=>"9", "suit"=>"hearts"}, 
             {"number"=>"9", "suit"=>"spades"}, 
             {"number"=>"A", "suit"=>"hearts"}, 
             {"number"=>"K", "suit"=>"diamonds"}]
    @deck = PokerService.new
    @deck.options(@hand)
  end

  test "# 1. High Card: Highest value card. Order is 2, 3, 4, 5, 6, 7, 8, 9, Ten, Jack, Queen, King, Ace." do
    assert_equal @deck.high_card, 14
  end

  test "# 2. One Pair: Two cards of the same value." do
    assert_equal @deck.one_pair, ["9", "9"]
  end

  test "# 3. Two Pairs: Two different pairs." do
    assert_equal @deck.two_pair, ["9", "9"]
  end

  test "# 4. Three of a Kind: Three cards of the same value." do
    assert_equal @deck.three_of_a_kind, []
  end

  test "# 5. Straight: All cards are consecutive values." do
    assert_equal @deck.straight, ["8", "9", "9", "King", "Ace"]
  end

  test "# 6. Flush: All cards of the same suit.." do
    assert_equal @deck.flush, ["8", "9", "9", "Ace", "King"]
  end

  test "# 7. Full House: Three of a kind and a pair." do
    @hand_full_hause = [{"number"=>"9", "suit"=>"spades"},
                        {"number"=>"9", "suit"=>"spades"},
                        {"number"=>"K", "suit"=>"spades"},
                        {"number"=>"K", "suit"=>"hearts"},
                        {"number"=>"K", "suit"=>"diamonds"}]
    @deck.options(@hand_full_hause)
    assert_equal @deck.full_house, ["9", "9", "King", "King", "King"]
  end

  test "# 8. Four of a Kind: Four cards of the same value." do
      @hand_four_of_a_kind = [{"number"=>"9", "suit"=>"spades"},
                        {"number"=>"K", "suit"=>"spades"},
                        {"number"=>"K", "suit"=>"clubs"},
                        {"number"=>"K", "suit"=>"hearts"},
                        {"number"=>"K", "suit"=>"diamonds"}]
    @deck.options(@hand_four_of_a_kind)
    assert_equal @deck.four_of_a_kind, ["King", "King", "King", "King"]
  end

  test "# 9. Straight Flush: All cards are consecutive values of same suit." do
    @hand_straight_flush = [{"number"=>"10", "suit"=>"hearts"},
                              {"number"=>"J", "suit"=>"diamonds"},
                              {"number"=>"Q", "suit"=>"hearts"},
                              {"number"=>"K", "suit"=>"clubs"},
                              {"number"=>"A", "suit"=>"hearts"}]
    @deck.options(@hand_straight_flush)
    assert_equal @deck.straight_flush, ["10", "Jack", "Queen", "King", "Ace"]
  end

  # 10. Royal Flush: Ten, Jack, Queen, King, Ace of same suit.
  test "# 10. Royal Flush: Ten, Jack, Queen, King, Ace of same suit." do
    @hand_royal_flush = [{"number"=>"10", "suit"=>"hearts"},
                              {"number"=>"J", "suit"=>"hearts"},
                              {"number"=>"Q", "suit"=>"hearts"},
                              {"number"=>"K", "suit"=>"hearts"},
                              {"number"=>"A", "suit"=>"hearts"}]
    @deck.options(@hand_royal_flush)
    assert_equal @deck.royal_flush,  ["10", "Jack", "Queen", "King", "Ace"]
  end

end
