require 'awesome_print'
require 'set'

BagDesc = Struct.new(:count, :color)

$rules = {}
STDIN.readlines.each do |line|
  outer, rest = line.split(' bags contain ')
  rest = rest.split(/[,.]/).map(&:strip).reject(&:empty?)
  rest = rest.map do |d|
    m = d.match(/(\d+|no) (.+) bags?/)
    BagDesc.new(m[1].to_i, m[2])
  end
  $rules[outer] = rest
end

def find_containers(color)
  containers = []
  $rules.each do |k, v|
    containers << k if v.map(&:color).include?(color)
  end
  containers
end

def recursive_find(visited, color)
  ret = Set.new
  return ret if visited.include?(color)
  visited << color
  containers = find_containers(color)
  return ret if containers.empty?
  ret.merge(containers)
  containers.each do |subcolor|
    ret.merge(recursive_find(visited.dup, subcolor))
  end
  ret
end

visited = Set.new
colors = recursive_find(visited, 'shiny gold')
ap colors
puts colors.size

def count_nested_bags(color)
  return 0 unless $rules.key?(color)
  $rules[color].map { |info| info.count + info.count * count_nested_bags(info.color) }.sum
end

puts count_nested_bags('shiny gold')
