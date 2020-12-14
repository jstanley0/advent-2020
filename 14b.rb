require 'amazing_print'
mem = {}

one_bits = []
float_bits = []
STDIN.readlines.each do |line|
  l, r = line.split('=').map(&:strip)
  if l == 'mask'
    one_bits = []
    float_bits = []
    r.chars.reverse.each_with_index do |char, bit|
      if char == '1'
        one_bits << bit
      elsif char == 'X'
        float_bits << bit
      end
    end
  else
    # 00
    # 01
    # 10
    # 11
    addr = l.scan(/\d+/).first.to_i
    val = r.to_i
    puts "raw address: #{addr.to_s(2)}"
    one_bits.each { |bit| addr |= (1 << bit) }
    puts "pre-munged:  #{addr.to_s(2)}"
    for i in 0...(1 << float_bits.size)
      mod_addr = addr
      float_bits.each_with_index do |bit, j|
        if i[j] == 0
          mod_addr &= ~(1 << bit)
        else
          mod_addr |= (1 << bit)
        end
      end
      puts "float:  #{mod_addr.to_s(2)}"
      mem[mod_addr] = val
    end
  end
end

ap mem
puts mem.values.sum
