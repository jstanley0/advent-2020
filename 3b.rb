def slide(map, slope)
  row = 0
  col = 0
  dc, dr = slope
  trees = 0
  while row < map.size
    cc = col % map[row].size
    trees += 1 if map[row][cc] == '#'
    col += dc
    row += dr
  end
  puts trees
  trees
end

slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
map = STDIN.readlines.map(&:strip)

puts slopes.map { |slope| slide(map, slope) }.inject(:*)

