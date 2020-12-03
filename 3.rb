map = STDIN.readlines.map(&:strip)
row = 0
col = 0
dr = 1
dc = 3
trees = 0
while row < map.size
  sub = ''
  cc = col % map[row].size
  if map[row][cc] == '#'
    sub = 'X'
    trees += 1
  else
    sub = 'O'
  end
  map[row][cc] = sub
  puts map[row]
  col += dc
  row += dr
end
puts trees
