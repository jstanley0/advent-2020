TARGET = 1721308972
nums = STDIN.readlines.map(&:to_i)

for s in 2..1000
  seq = nums.each_cons(s).find { |sub| sub.sum == TARGET }
  if seq
    puts seq.min + seq.max
    break
  end
end

def smrt_sum(nums)
  l = 0
  h = 0
  acc = nums[0]
  while acc != TARGET
    while acc < TARGET
      h += 1
      return nil if h == nums.size
      acc += nums[h]
    end
    while acc > TARGET
      acc -= nums[l]
      l += 1
      return nil if l == h
    end
  end
  seq = nums[l..h]
  seq.min + seq.max
end

puts smrt_sum(nums)
