require 'set'

NEIGHBORS = {w: [-1, 0], e: [1, 0], nw: [0, -1], se: [0, 1], ne: [1, -1], sw: [-1, 1]}

def split_line(line)
  dirs = []
  i = 0
  while i < line.size
    case line[i]
    when 'n', 's'
      dirs << line[i,2]
      i += 2
    else
      dirs << line[i]
      i += 1
    end
  end
  dirs
end

def follow_dirs(dirs)
  q = 0
  r = 0
  dirs.each do |dir|
    offsets = NEIGHBORS[dir.to_sym]
    raise "bad dir #{dir}" unless offsets
    q += offsets[0]
    r += offsets[1]
  end
  [q, r]
end

hexes = Set.new
ARGF.readlines.each do |line|
  dirs = split_line(line.strip)
  coords = follow_dirs(dirs)
  if hexes.include?(coords)
    hexes.delete(coords)
  else
    hexes << coords
  end
end

puts hexes.size

def neighboring_coordinates(q, r)
  NEIGHBORS.values.each do |dq, dr|
    yield [q + dq, r + dr]
  end
end

def frickin_life(grid)
  newgrid = grid.dup
  white_cell_neighbors = {}
  grid.each do |black_cell|
    neighbor_count = 0
    neighboring_coordinates(*black_cell) do |cell|
      if grid.include?(cell)
        neighbor_count += 1
      else
        white_cell_neighbors[cell] ||= 0
        white_cell_neighbors[cell] += 1
      end
    end
    if neighbor_count == 0 || neighbor_count > 2
      newgrid.delete(black_cell)
    end
  end
  newgrid.merge white_cell_neighbors.select { |_cell, count| count == 2 }.keys
end

100.times do |x|
  hexes = frickin_life(hexes)
  puts "Day #{x + 1}: #{hexes.size}"
end
