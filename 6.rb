
def read_group
  group = 0
  loop do
    line = STDIN.gets&.chomp
    break if line.nil? || line.empty?
    line.chars.each do |c|
      group |= (1 << (c.ord - 'a'.ord))
    end
  end
  group
end

def count_group(group)
  count = 0
  while group != 0
    count += 1 if (group & 1) == 1
    group >>= 1
  end
  count
end

groups = []
loop do
  g = read_group
  break if g == 0
  groups << g
end

puts groups.map { |g| count_group(g) }.sum
