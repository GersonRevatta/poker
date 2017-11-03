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

class PokerService

  attr_reader :token, :cards, :suits, :faces, :values
  
  # Translation key for letters to suit names
  CARD_SUITS = {
    "S" => "spades", "H" => "hearts",
    "C" => "clubs", "D" => "diamonds"
  }

  # Translation key for numbers/letters to suit faces
  CARD_FACES = { 
    "2" => "2", "3" => "3", "4" => "4",
    "5" => "5", "6" => "6", "7" => "7",
    "8" => "8", "9" => "9", "10" => "10",
    "J" => "Jack", "Q" => "Queen", "K" => "King",
    "A" => "Ace"
  }

  # Translation key for numbers/suit faces to card values
  CARD_VALUES = {
    "2" => 2, "3" => 3, "4" => 4,
    "5" => 5, "6" => 6, "7" => 7,
    "8" => 8, "9" => 9, "10" => 10,
    "Jack" => 11, "Queen" => 12, "King" => 13,
    "Ace" => 14
  }

  def initialize
    @token  = deck_token if not Rails.env.test?
  end

  def deck_token
    # this return a token b7cbef80-c003-11e7-b704-3b7d2b7285fd
    response = Typhoeus.post(Settings.comparaonline.deck)
    return response.body if response.code == 200
    @token = false
  end

  def delear
    # send token and number of card
    if @token
      request  = "#{Settings.comparaonline.deck}/#{@token}/deal/5"
      response = Typhoeus.get(request)
      options(JSON.parse(response.body))
    else
      @hand    = [{"number"=>"10", "suit"=>"hearts"}, {"number"=>"J", "suit"=>"hearts"}, {"number"=>"Q", "suit"=>"hearts"}, {"number"=>"K", "suit"=>"hearts"}, {"number"=>"A", "suit"=>"hearts"}]
      options(@hand)
    end
  end

  def options(card)
    @cards      = card.map{|a| a['number'] }
    @suits      = card.map{|a| a['suit'] } 
    @faces      = @cards.map { |card| CARD_FACES[card] }
    @values     = @faces.map { |face| CARD_VALUES[face] }
  end

  def evaluate
    case
    when flush?
      determine_flush_type
    when straight?
      "Straight (#{straight})"
    when four_of_a_kind?
      "Four of a Kind (#{four_of_a_kind})"
    when full_house?
      "Full House (#{full_house})"
    when three_of_a_kind?
      "Three of a Kind (#{three_of_a_kind})"
    when two_pair?
      "Two Pair (#{two_pair})"
    when one_pair?
      "One Pair (#{one_pair})"
    else
      "High Card: (#{high_card})"
    end
  end

  # 1. High Card: Highest value card. Order is 2, 3, 4, 5, 6, 7, 8, 9, Ten, Jack, Queen, King, Ace.
  def high_card
    @values.max
  end

  # 2. One Pair: Two cards of the same value.
  def one_pair?
    @faces.uniq.length == 4
  end

  def one_pair
    @faces.select { |face| @faces.count(face) == 2 }
  end

  # 3. Two Pairs: Two different pairs.
  def two_pair?
    @faces.uniq.length == 3 && faces.any? { |face| faces.count(face) == 2  }
  end

  def two_pair
    @faces.select { |face| @faces.count(face) == 2 }
  end

  # 4. Three of a Kind: Three cards of the same value.
  def three_of_a_kind?
    @faces.uniq.length == 3 && faces.any? { |face| faces.count(face) == 3  }
  end

  def three_of_a_kind
    three_faces = @faces.select { |face| @faces.count(face) == 3 }
  end

  # 5. Straight: All cards are consecutive values.
  def straight?
    sorted_values = @values.sort
    sorted_values == (sorted_values[0]..sorted_values[4]).step.to_a
  end

  def straight
    hash_array = @faces.map.with_index { |face, i| {'face' => face, 'value' => @values[i] } }
    sorted_faces = hash_array.sort_by { |key| key['value'] }.map { |key| key['face'] }
  end

  # 6. Flush: All cards of the same suit.
  def flush?
    @suits.uniq.length == 1
  end

  def flush
    @faces
  end

  # 7. Full House: Three of a kind and a pair.
  def full_house?
    @faces.uniq.length == 2 && faces.any? { |face| faces.count(face) == 3  }
  end

  def full_house
    @faces - @faces.select { |face| @faces.count(face) == 3 }.split
  end

  # 8. Four of a Kind: Four cards of the same value.
  def four_of_a_kind?
    @faces.uniq.length == 2 && faces.any? { |face| faces.count(face) == 4 }
  end

  def four_of_a_kind
    @faces.select { |face| @faces.count(face) == 4 }
  end

  # 9. Straight Flush: All cards are consecutive values of same suit.
  def straight_flush
    hash_array = @faces.map.with_index { |face, i| {'face' => face, 'value' => @values[i] } }
    sorted_faces = hash_array.sort_by { |key| key['value'] }.map { |key| key['face'] }
  end

  def determine_flush_type
    if royal_flush?
      "Royal Flush (#{royal_flush})"
    elsif straight?
      "Straight Flush (#{straight_flush})"
    else
      "Flush (#{flush})"
    end
  end

  # 10. Royal Flush: Ten, Jack, Queen, King, Ace of same suit.
  def royal_flush?
    @faces - ["Ace","King","Queen","Jack","10"] == []
  end

  def royal_flush
    @faces
  end

end