require 'amazing_print'
require 'set'
=begin
Coord = Struct.new(:x, :y, :z)

$active = Set.new

STDIN.readlines.map(&:chomp).each_with_index do |line, x|
  line.each_with_index do |char, y|
    $active << Coord.new(x, y, 0)if char == '#'

    end
  end
end
=end
PAD=7
board = STDIN.readlines.map(&:chomp)
board = board.map { |line| '.'*PAD + line + '.'*PAD }
vpad = ['.'*board[0].size]*PAD
board = (vpad + board + vpad).flatten
zpad = ['.' * board[0].size] * board[0].size

stack = []
PAD.times do
  stack << zpad.map(&:dup)
end
stack << board
PAD.times do
  stack << zpad.map(&:dup)
end

def clone_cube(cube)
  cube.map do |plane|
    plane.map do |row|
      row.dup
    end
  end
end

def count_surrounds(cube, z, y, x)
  count = 0
  ([z-1, 0].max..[z+1, cube.size-1].min).each do |dz|
    ([y-1, 0].max..[y+1, cube[dz].size-1].min).each do |dy|
      ([x-1, 0].max..[x+1, cube[dz][dy].size-1].min).each do |dx|
        next if dz == z && dy == y && dx == x
        count += 1 if cube[dz][dy][dx] == '#'
      end
    end
  end
  count
end

def tick_cube(cube)
  result = clone_cube(cube)
  cube.each_with_index do |plane, z|
    plane.each_with_index do |row, y|
      row.chars.each_with_index do |char, x|
        live = count_surrounds(cube, z, y, x)
        if char == '#' && (live < 2 || live > 3)
          result[z][y][x] = '.'
        elsif char == '.' && live == 3
          result[z][y][x] = '#'
        end
      end
    end
  end
  result
end

def count_live(cube)
  cube.map { |plane| plane.map { |row| row.count('#') }.sum }.sum
end

6.times do
  stack = tick_cube(stack)
end

puts count_live(stack)
ap stack
