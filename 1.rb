nums = ARGF.readlines.map(&:to_i)
nums.each do |num|
  other_num = nums.find { |n| n + num == 2020 }
  if other_num
    puts num * other_num
    break
  end
end
