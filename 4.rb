require 'amazing_print'

def validate_year(y, min, max)
  y =~ /^\d{4}$/ && y.to_i >= min && y.to_i <= max
end

$valid_stuff = {}
$invalid_stuff = {}

VALIDATORS = {
  'byr' => ->(y) { validate_year(y, 1920, 2002) },
  'iyr' => ->(y) { validate_year(y, 2010, 2020) },
  'eyr' => ->(y) { validate_year(y, 2020, 2030) },
  'hgt' => ->(h) {
    if h =~ /^([0-9]+)cm$/
      $1.to_i >= 150 && $1.to_i <= 193
    elsif h =~ /^([0-9]+)in$/
      $1.to_i >= 59 && $1.to_i <= 76
    else
      false
    end
  },
  'hcl' => ->(c) { c =~ /^#[0-9a-f]{6}$/ },
  'ecl' => ->(c) { %w(amb blu brn gry grn hzl oth).include?(c) },
  'pid' => ->(id) { id =~ /^\d{9}$/ },
  'cid' => ->(v) { true }
}

def valid_passport?(pp)
  return false unless (%w(byr iyr eyr hgt hcl ecl pid) - pp.keys).empty?
  pp.all? do |k, v|
    valid = VALIDATORS[k].call(v)
    if valid
      $valid_stuff[k] ||= []
      $valid_stuff[k] << v
    else
      $invalid_stuff[k] ||= []
      $invalid_stuff[k] << v
    end
    valid
  end
end

pp = {}
valid = 0
loop do
  line = STDIN.gets&.strip
  if line.nil? || line.empty?
    if valid_passport?(pp)
      valid += 1
      #puts "VALID: #{pp.inspect}"
    else
      #puts "INVALID: #{pp.inspect}"
    end
    pp = {}
    break if line.nil?
  else
    line.split.each do |field|
      key, val = field.split(':')
      pp[key] = val
    end
  end
end

def uniquify(stuff)
  stuff.transform_values! { |v| v.sort!.uniq! }
end

puts "invalid stuff:"
ap uniquify($invalid_stuff)

puts "valid stuff:"
ap uniquify($valid_stuff)

puts "valid count:"
puts valid
