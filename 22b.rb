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

loop do
  p1card = player1.shift
  p2card = player2.shift
  if p1card > p2card
    player1 << p1card
    player1 << p2card
  elsif p2card > p1card
    player2 << p2card
    player2 << p1card
  end
  if player1.empty? || player2.empty?
    winning_cards = (player1 + player2).reverse
    multiplier = 1
    score = 0
    winning_cards.each do |card|
      score += card * multiplier
      multiplier += 1
    end
    puts "score: #{score}"
    exit
  end
end
