nums = ARGF.readlines.map(&:to_i)
nums.combination(3).each do |combination|
  if combination.sum == 2020
    puts combination.inject(:*)
    break
  end
end
