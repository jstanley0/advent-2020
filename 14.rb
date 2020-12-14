mem = {}

def apply_mask(val, mask)
  mask.chars.reverse.each_with_index do |char, bit|
    if char == '0'
      val &= ~(1 << bit)
    elsif char == '1'
      val |= (1 << bit)
    end
  end
  val
end

mask = ''
STDIN.readlines.each do |line|
  l, r = line.split('=').map(&:strip)
  if l == 'mask'
    mask = r
  else
    addr = l.scan(/\d+/).first.to_i
    mem[addr] = apply_mask(r.to_i, mask)
  end
end

puts mem.values.sum
