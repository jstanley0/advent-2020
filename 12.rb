

dirs = STDIN.readlines
a = 0
x = 0
y = 0
dirs.each do |dir|
  c = dir[0]
  d = dir[1..-1].to_i
  case c
  when 'N'
    y -= d
  when 'S'
    y += d
  when 'E'
    x += d
  when 'W'
    x -= d
  when 'L'
    a = (a - d) % 360
  when 'R'
    a = (a + d) % 360
  when 'F'
    case a
    when 0
      x += d
    when 90
      y += d
    when 180
      x -= d
    when 270
      y -= d
    end
  end
end

puts "#{x},#{y} #{x+y}"
