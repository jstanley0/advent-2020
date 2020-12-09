PREAMBLE = 25
nums = STDIN.readlines.map(&:to_i)
for i in PREAMBLE...nums.size
  unless nums[i - 25...i].combination(2).map(&:sum).include?(nums[i])
    puts nums[i]
    break
  end
end
