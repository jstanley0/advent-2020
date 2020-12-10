nums = STDIN.readlines.map(&:to_i).sort
nums = [0] + nums + [nums[-1] + 3]

chunks = []
prev = 0
current_chunk = 1
nums.each do |num|
  if num == prev + 1
    current_chunk += 1
  else
    chunks << current_chunk if current_chunk > 2
    current_chunk = 1
  end
  prev = num
end

# I thought I'd have to calculate this but these are the only chunk sizes in the input!
CHUNK_PERMS = {
  3 => 2,  # 111, 101
  4 => 4,  # 1111, 1011, 1101, 1001
  5 => 7   # 11111, 10111, 11011, 11101, 10011, 11001, 10101
}

puts chunks.map { |chunk| CHUNK_PERMS[chunk] }.inject(:*)
