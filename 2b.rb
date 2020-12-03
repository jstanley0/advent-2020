valid_passwords = 0
ARGF.each_line do |line|
  match = line.match(/(\d+)-(\d+) (\w): (\w+)/)
  p0 = match[1].to_i
  p1 = match[2].to_i
  letter = match[3]
  pw = match[4]
  raise "bad input" unless pw
  valid_passwords += 1 if (pw[p0 - 1] == letter) ^ (pw[p1 - 1] == letter)
end
puts valid_passwords
