PUBLIC_KEYS = [13135480, 8821721]
n = [1, 1]
l = 1
matched_loops = [nil, nil]
while matched_loops.any?(&:nil?)
  (0..1).each do |i|
    n[i] = (n[i] * 7) % 20201227
    index = PUBLIC_KEYS.index(n[i])
    if index
      matched_loops[index] = l
    end
  end
  l += 1
end

p matched_loops

def transform_thing(subject, loop_size)
  m = 1
  loop_size.times do
    m *= subject
    m %= 20201227
  end
  m
end

p transform_thing(PUBLIC_KEYS[0], matched_loops[1])
p transform_thing(PUBLIC_KEYS[1], matched_loops[0])
