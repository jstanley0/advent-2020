require 'amazing_print'
require 'byebug'

Tile = Struct.new(:id, :data, :edge_ids)
tiles = []
loop do
  top = ARGF.gets&.chomp
  break if top.nil? || top.empty?
  raise "parse error" unless top.match(/Tile (\d+):/)
  tile = Tile.new($1.to_i, [], [])
  loop do
    line = ARGF.gets&.chomp
    break if line.nil? || line.empty?
    $ts = line.size if $ts.nil?
    tile.data << line
  end
  raise "non-square tile" unless tile.data.size == $ts
  tiles << tile
end

$w = w = Math.sqrt(tiles.count).to_i
puts "#{tiles.count} tiles (#{w}x#{w})"

def edge_id(s)
  [s, s.reverse].min
end

def compute_edge_ids!(tile) # TRBL
  tile.edge_ids = [edge_id(tile.data[0].dup)]
  tile.edge_ids << edge_id(tile.data.map { |row| row[-1] }.join)
  tile.edge_ids << edge_id(tile.data[-1].dup)
  tile.edge_ids << edge_id(tile.data.map { |row| row[0] }.join)
end

def recompute_edge_ids!(tile)
  old_edge_ids = tile.edge_ids.map(&:dup)
  compute_edge_ids!(tile)
  raise "rotate/flip invariant violation" unless old_edge_ids.sort == tile.edge_ids.sort
end

tiles.each do |tile|
  compute_edge_ids!(tile)
end

edge_map = {}
tiles.each do |tile|
  tile.edge_ids.each do |edge_id|
    edge_map[edge_id] ||= []
    edge_map[edge_id] << tile.id
  end
end

def find_by_connectedness(edge_map, n)
  ids = []
  things = edge_map.values.select { |v| v.size > 1 }.flatten
  things.uniq.each do |val|
    if things.count(val) == n
      ids << val
    end
  end
  ids
end

corner_ids = find_by_connectedness(edge_map, 2)
puts "corners: #{corner_ids.inspect} (#{corner_ids.inject(:*)})"

edge_ids = find_by_connectedness(edge_map, 3)
puts "edges: #{edge_ids.inspect} (#{edge_ids.size})"

interior_ids = find_by_connectedness(edge_map, 4)
puts "interiors: #{interior_ids.inspect} (#{interior_ids.size})"

$links = {}
edge_map.values.select { |v| v.size > 1 }.each do |edge|
  ($links[edge[0]] ||= []) << edge[1]
  ($links[edge[1]] ||= []) << edge[0]
end

#ap $links

# figure out tile positions
used_tiles = []
puzzle = w.times.map { Array.new(w) }
puzzle[0][0] = corner_ids.first
used_tiles << corner_ids.first
# build the top row
(1...w).each do |x|
  tile_to_link = ($links[puzzle[0][x-1]] - used_tiles - interior_ids).first
  used_tiles << tile_to_link
  puzzle[0][x] = tile_to_link
end
# build the left column
(1...w).each do |y|
  tile_to_link = ($links[puzzle[y - 1][0]] - used_tiles - interior_ids).first
  used_tiles << tile_to_link
  puzzle[y][0] = tile_to_link
end
# now fill in the middle
(1...w).each do |x|
  (1...w).each do |y|
    tile_to_link = (($links[puzzle[y - 1][x]] & $links[puzzle[y][x - 1]]) - used_tiles).first
    used_tiles << tile_to_link
    puzzle[y][x] = tile_to_link
  end
end

#ap puzzle

# because this isn't indexed yet and this problem is geological in nature
$tiles = {}
tiles.each do |tile|
  $tiles[tile.id] = tile
end
$puzzle = puzzle

def print_puzzle
  $puzzle.each do |pr|
    for i in 0...$ts
      for x in 0...$w
        tile = $tiles[pr[x]]
        print tile.data[i] + ' '
      end
      puts
    end
    puts "\n\n"
  end
end

def find_common_edge(y1, x1, y2, x2)
  common_edge = $tiles[$puzzle[y1][x1]].edge_ids & $tiles[$puzzle[y2][x2]].edge_ids
  raise "no common edge" unless common_edge.size == 1
  common_edge.first
end

def rotate_thing_90_degrees!(thing)
  raise "non-square thing" unless thing.size == thing[0].size
  temp_thing = thing.map(&:dup)
  for x in 0...thing.size
    for y in 0...thing.size
      thing[y][x] = temp_thing[x][thing.size - y - 1]
    end
  end
end

def rotate_tile_90_degrees!(tile)
  rotate_thing_90_degrees!(tile.data)
  recompute_edge_ids!(tile)
end

def rotate_tile!(tile, edge_id, to_pos)
  3.times do
    return if tile.edge_ids[to_pos] == edge_id
    rotate_tile_90_degrees!(tile)
  end
  raise "geometry fail" unless tile.edge_ids[to_pos] == edge_id
end

def flip_tile_horizontally!(tile)
  tile.data.each(&:reverse!)
  recompute_edge_ids!(tile)
end

def flip_tile_vertically!(tile)
  tile.data.reverse!
  recompute_edge_ids!(tile)
end

# figure out tile rotation: top row
edge = find_common_edge(0,0, 0,1)
rotate_tile!($tiles[$puzzle[0][0]], edge, 1)
for x in 1...w
  tile = $tiles[$puzzle[0][x]]
  edge = find_common_edge(0, x, 0, x - 1)
  rotate_tile!(tile, edge, 3)
end

# flip top row tiles to align with second row
for x in 0...w
  tile = $tiles[$puzzle[0][x]]
  edge = find_common_edge(0, x, 1, x)
  pos = tile.edge_ids.index(edge)
  raise "wat" unless [0, 2].include?(pos)
  flip_tile_vertically!(tile) if pos == 0
end

# rotate/flip tiles: left column
for y in 1...w
  tile = $tiles[$puzzle[y][0]]
  edge = find_common_edge(y, 0, y - 1, 0)
  rotate_tile!(tile, edge, 0)

  edge = find_common_edge(y, 0, y, 1)
  pos = tile.edge_ids.index(edge)
  raise "wat" unless [1, 3].include?(pos)
  flip_tile_horizontally!(tile) if pos == 3
end

# rotate/flip: all the other dang tiles!
for y in 1...w
  for x in 1...w
    tile = $tiles[$puzzle[y][x]]
    edge = find_common_edge(y, x, y - 1, x)
    rotate_tile!(tile, edge, 0)

    edge = find_common_edge(y, x, y, x - 1)
    pos = tile.edge_ids.index(edge)
    raise "wat" unless [1, 3].include?(pos)
    flip_tile_horizontally!(tile) if pos == 1
  end
end

print_puzzle
