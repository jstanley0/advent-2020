require 'amazing_print'
require 'set'

SIZE=21
hyper = (0...SIZE).map do |cube|
  (0...SIZE).map do |plane|
    (0...SIZE).map do |row|
      '.' * SIZE
    end
  end
end

board = STDIN.readlines.map(&:chomp)
mid = SIZE/2
mid_plane = hyper[mid][mid]
y = mid - board.size/2
board.each_with_index do |row, i|
  pad = mid_plane[y + i].size - row.size
  lpad = pad / 2
  rpad = pad / 2
  rpad += 1 if pad.odd?
  mid_plane[y + i] = '.' * lpad + row + '.' * rpad
end

def clone_hyper(hyper)
  hyper.map do |cube|
    cube.map do |plane|
      plane.map do |row|
        row.dup
      end
    end
  end
end

def count_surrounds(hyper, w, z, y, x)
  count = 0
  ([w-1, 0].max..[w+1, hyper.size-1].min).each do |dw|
    ([z-1, 0].max..[z+1, hyper[dw].size-1].min).each do |dz|
      ([y-1, 0].max..[y+1, hyper[dw][dz].size-1].min).each do |dy|
        ([x-1, 0].max..[x+1, hyper[dw][dz][dy].size-1].min).each do |dx|
          next if dw == w && dz == z && dy == y && dx == x
          count += 1 if hyper[dw][dz][dy][dx] == '#'
        end
      end
    end
  end
  count
end

def tick_hyper(hyper)
  result = clone_hyper(hyper)
  hyper.each_with_index do |cube, w|
    cube.each_with_index do |plane, z|
      plane.each_with_index do |row, y|
        row.chars.each_with_index do |char, x|
          live = count_surrounds(hyper, w, z, y, x)
          if char == '#' && (live < 2 || live > 3)
            result[w][z][y][x] = '.'
          elsif char == '.' && live == 3
            result[w][z][y][x] = '#'
          end
        end
      end
    end
  end
  result
end

def count_live(hyper)
  hyper.map { |cube| cube.map { |plane| plane.map { |row| row.count('#') }.sum }.sum }.sum
end

puts count_live(hyper)
6.times do
  hyper = tick_hyper(hyper)
  puts count_live(hyper)
end

