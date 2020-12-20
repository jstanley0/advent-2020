require 'amazing_print'

Tile = Struct.new(:id, :data, :edge_ids)
tiles = []
loop do
  top = gets&.chomp
  break if top.nil? || top.empty?
  raise "parse error" unless top.match(/Tile (\d+):/)
  tile = Tile.new($1.to_i, [], [])
  loop do
    line = gets&.chomp
    break if line.nil? || line.empty?
    tile.data << line
  end
  tiles << tile
end

w = Math.sqrt(tiles.count).to_i
puts "#{tiles.count} tiles (#{w}x#{w})"

def edge_id(s)
  [s, s.reverse].min
end

tiles.each do |tile| # TRBL
  tile.edge_ids << edge_id(tile.data[0])
  tile.edge_ids << edge_id(tile.data.map { |row| row[-1] }.join)
  tile.edge_ids << edge_id(tile.data[-1])
  tile.edge_ids << edge_id(tile.data.map { |row| row[0] }.join)
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

# figure out tile orientations
