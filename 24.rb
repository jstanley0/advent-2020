require 'set'

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
    case dir
    when 'w'
      q -= 1
    when 'e'
      q += 1
    when 'nw'
      r -= 1
    when 'ne'
      q += 1
      r -= 1
    when 'sw'
      q -= 1
      r += 1
    when 'se'
      r += 1
    end
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

NEIGHBORS = [[-1, 0], [1, 0], [0, -1], [0, 1], [1, -1], [-1, 1]]

def neighboring_coordinates(q, r)
  NEIGHBORS.each do |dq, dr|
    yield [q + dq, r + dr]
  end
end

def frickin_life(grid)
  newgrid = grid.dup
  white_cells_to_inspect = Set.new
  grid.each do |black_cell|
    neighbor_count = 0
    neighboring_coordinates(*black_cell) do |cell|
      if grid.include?(cell)
        neighbor_count += 1
      else
        white_cells_to_inspect << cell
      end
    end
    if neighbor_count == 0 || neighbor_count > 2
      newgrid.delete(black_cell)
    end
  end
  white_cells_to_inspect.each do |white_cell|
    neighbor_count = 0
    neighboring_coordinates(*white_cell) do |cell|
      neighbor_count += 1 if grid.include?(cell)
    end
    newgrid << white_cell if neighbor_count == 2
  end
  newgrid
end

100.times do |x|
  hexes = frickin_life(hexes)
  puts "Day #{x + 1}: #{hexes.size}"
end
