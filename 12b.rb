dirs = STDIN.readlines
x = 0
y = 0
wx = 10
wy = -1
dirs.each do |dir|
  c = dir[0]
  d = dir[1..-1].to_i
  case c
  when 'N'
    wy -= d
  when 'S'
    wy += d
  when 'E'
    wx += d
  when 'W'
    wx -= d
  when 'L'
    case d % 360
    when 90
      tmp = wy
      wy = -wx
      wx = tmp
    when 180
      wx = -wx
      wy = -wy
    when 270
      tmp = -wy
      wy = wx
      wx = tmp
    end
  when 'R'
    case d % 360
    when 90
      tmp = -wy
      wy = wx
      wx = tmp
    when 180
      wx = -wx
      wy = -wy
    when 270
      tmp = wy
      wy = -wx
      wx = tmp
    end
  when 'F'
    x += wx * d
    y += wy * d
  end
end

puts "#{x},#{y} #{x.abs+y.abs}"
