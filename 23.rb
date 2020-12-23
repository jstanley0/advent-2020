#INPUT = '389125467'
INPUT = '364297581'

a = INPUT.chars.map(&:to_i)
puts "size: #{a.size}"
a_max = a.max
current = 0
prevcrap = []
100.times do |move|
  puts "\n-- move #{move + 1} --"
  puts "cups: " + a.each_with_index.map { |n, i| i == current ? "(#{n})" : " #{n} " }.join
  one_index = a.index(1)
  nexttwo = [a[(one_index + 1) % a.size], a[(one_index + 2) % a.size]]
  if nexttwo != prevcrap
    puts "move #{move + 1}: #{nexttwo.inspect}"
    prevcrap = nexttwo
  end

  picked_up = []
  3.times do
    delete_ix = current + 1
    if delete_ix >= a.size
      delete_ix = 0
      current -= 1
    end
    picked_up << a.delete_at(delete_ix)
  end
  next_label = a[(current + 1) % a.size]
  puts "picked up: #{picked_up}"
  dest_label = a[current] - 1
  dest_index = a.index(dest_label)
  while dest_index.nil?
    dest_label -= 1
    dest_label = a_max if dest_label < 1
    dest_index = a.index(dest_label)
  end
  puts "destination: #{dest_label}"
  a.insert(dest_index + 1, *picked_up)
  current = a.index(next_label)
end

puts "\n-- final --"
puts "cups: " + a.each_with_index.map { |n, i| i == current ? "(#{n})" : " #{n} " }.join
