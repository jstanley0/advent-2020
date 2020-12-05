def parse_line(line)
  lb = 0
  ub = 128
  lc = 0
  uc = 8
  line.chars.each do |char|
    case char
    when 'F'
      ub = (lb + ub) / 2
    when 'B'
      lb = (lb + ub) / 2
    when 'L'
      uc = (uc + lc) / 2
    when 'R'
      lc = (uc + lc) / 2
    end
  end
  lb * 8 + lc
end

row_ids = STDIN.readlines.map { |line| parse_line(line).to_i }
puts (row_ids.min..row_ids.max).to_a - row_ids
