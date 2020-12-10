nums = STDIN.readlines.map(&:to_i).sort
nums = [0] + nums + [nums[-1] + 3]

diffs = nums.each_with_index.map { |num, i| num - nums[i - 1] }
puts diffs.inspect
puts diffs.count(1) * diffs.count(3)

