valid_passwords = 0
ARGF.each_line do |line|
  match = line.match(/(\d+)-(\d+) (\w): (\w+)/)
  min = match[1].to_i
  max = match[2].to_i
  letter = match[3]
  pw = match[4]
  raise "bad input" unless pw
  count = pw.count(letter)
  valid_passwords += 1 if (min..max).include? count
end
puts valid_passwords
