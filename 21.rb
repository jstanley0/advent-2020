require 'amazing_print'
require 'byebug'

Food = Struct.new(:ingredients, :allergens)
foods = []
ARGF.readlines.map do |line|
  line =~ /(.*) \(contains (.*)\)/
  foods << Food.new($1.split, $2.split(',').map(&:strip))
end

all_ingredients = foods.map(&:ingredients).flatten.uniq
all_allergens = foods.map(&:allergens).flatten.uniq

allergen_map = {}

all_allergens.each do |allergen|
  common_ingredients = nil
  foods.select { |food| food.allergens.include?(allergen) }.each do |food|
    if common_ingredients
      common_ingredients &= food.ingredients
    else
      common_ingredients = food.ingredients
    end
  end
  allergen_map[allergen] = common_ingredients
end

ap all_allergens
ap allergen_map

safe_ingredients = all_ingredients - allergen_map.values.flatten
ap safe_ingredients

appearances = 0
foods.each do |food|
  appearances += food.ingredients.count { |ingredient| safe_ingredients.include?(ingredient) }
end
puts appearances

canonical_allergens = []
loop do
  ap allergen_map
  known_allergen = allergen_map.detect { |_k, v| v.size == 1 }
  break unless known_allergen
  allergen = known_allergen[0]
  ingredient = known_allergen[1].first
  canonical_allergens << [allergen, ingredient]
  allergen_map.each { |_k, v| v.delete(ingredient) }
end

puts "..."
puts canonical_allergens.sort.map{|t|t[1]}.join(',')
