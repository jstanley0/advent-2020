require 'byebug'
require 'set'

player1 = []
player2 = []

ARGF.gets #player 1
loop do
  line = ARGF.gets.chomp
  break if line.empty?
  player1 << line.to_i
end

ARGF.gets #player 2
loop do
  line = ARGF.gets&.chomp
  break if line.nil? || line.empty?
  player2 << line.to_i
end

def compute_hand_signature(hand1, hand2)
  hand1.join(',')+':'+hand2.join(',')
end

def play_crabs(hand1, hand2)
  prev_hands = Set.new
  loop do
    hand_sig = compute_hand_signature(hand1, hand2)
    if prev_hands.include?(hand_sig)
      return [1, 0]
    else
      prev_hands << hand_sig
    end

    card1 = hand1.shift
    card2 = hand2.shift

    if card1 <= hand1.size && card2 <= hand2.size
      sub_game_result = play_crabs(hand1[0, card1], hand2[0, card2])
      if sub_game_result.first == 1
        hand1 << card1
        hand1 << card2
      else
        hand2 << card2
        hand2 << card1
      end
    else
      if card1 > card2
        hand1 << card1
        hand1 << card2
      else
        hand2 << card2
        hand2 << card1
      end
    end

    if hand1.empty? || hand2.empty?
      winning_cards = (hand1 + hand2).reverse
      multiplier = 1
      score = 0
      winning_cards.each do |card|
        score += card * multiplier
        multiplier += 1
      end
      return [hand1.empty? ? 2 : 1, score]
    end
  end
end

puts play_crabs(player1, player2)
