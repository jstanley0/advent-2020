
def read_group
  group = nil
  loop do
    line = STDIN.gets&.chomp
    break if line.nil? || line.empty?
    person = 0
    line.chars.each do |c|
      person |= (1 << (c.ord - 'a'.ord))
    end
    group = group.nil? ? person : group & person
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
  break unless g
  groups << g
end

puts groups.map { |g| count_group(g) }.sum
