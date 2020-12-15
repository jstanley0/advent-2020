INPUT=[0,13,1,16,6,17]

mem = {}
INPUT[0..-2].each_with_index do |n, i|
  if mem.key?(n)
    mem[n] = i + 1 - mem[n]
  else
    mem[n] = i + 1
  end
end

last = INPUT.last
turn = INPUT.size

while turn < 30000000
  newval = if mem.key?(last)
    turn - mem[last]
  else
    0
  end
  mem[last] = turn
  turn += 1
  last = newval
end

puts last
