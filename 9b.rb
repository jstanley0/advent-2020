TARGET = 1721308972
nums = STDIN.readlines.map(&:to_i)

for s in 2..1000
  seq = nums.each_cons(s).find { |sub| sub.sum == TARGET }
  if seq
    puts seq.min + seq.max
    break
  end
end
