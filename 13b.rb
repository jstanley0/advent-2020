STDIN.readline
buses=STDIN.readline.split(',').map(&:to_i)
letter = 'a'
buses.each_with_index do |bus, i|
  next if bus == 0
  print "#{bus} * #{letter}-#{i} = "
  letter = letter.succ
end
# ^ then paste that thing into wolfram alpha :P
