departure=STDIN.readline.to_i
buses=STDIN.readline.split(',').reject{_1=='x'}.map(&:to_i)
times = buses.map { |bus| ((departure / bus) * bus) + bus }
earliest = times.min
wait_time = earliest - departure
the_bus = buses[times.index(earliest)]
puts "departure: #{departure}"
puts "buses: #{buses.inspect}"
puts "times: #{times.inspect}"
puts "wait time: #{wait_time}"
puts "the bus: #{the_bus}"
puts wait_time * the_bus
