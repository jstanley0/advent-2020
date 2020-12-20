require 'amazing_print'
require 'byebug'

$notes = {}
$my_ticket = []
$other_tickets = []

def read_notes
  loop do
    line = STDIN.gets.chomp
    break if line.empty?
    legend, ranges = line.split(':').map(&:chomp)
    ranges = ranges.split(' or ').map do |range|
      range = range.split('-').map(&:to_i)
      range[0]..range[1]
    end
    $notes[legend] = ranges
  end
end

def read_my_ticket
  raise 'expected your ticket' unless STDIN.gets.include? 'your ticket:'
  $my_ticket = gets.split(',').map(&:to_i)
  gets
end

def read_other_tickets
  raise 'expected nearby ticket' unless STDIN.gets.include? 'nearby tickets:'
  loop do
    line = STDIN.gets&.chomp
    break if line.nil? || line.empty?
    $other_tickets << line.split(',').map(&:to_i)
  end
end

read_notes
read_my_ticket
read_other_tickets

test_vals = (0...$my_ticket.size).map { Array.new }
bad_sum = 0
ranges = $notes.values.flatten
$other_tickets.each do |ticket|
  ok = true
  ticket.each do |num|
    unless ranges.any? { |range| range.include?(num) }
      #puts "bad number: #{num}"
      bad_sum += num
      ok = false
    end
  end
  if ok
    ticket.each_with_index do |num, index|
      test_vals[index] << num
    end
  end
end
puts "error rate: #{bad_sum}"

possibilities = []
test_vals.each_with_index do |slate, index|
  poss = []
  #puts "slate #{index}: #{slate.join(',')}"
  $notes.each do |field, ranges|
    if slate.all? { |num| ranges.any? { |range| range.include?(num) } }
      poss << field
    end
  end
  possibilities[index] = poss
end

p2 = possibilities.each_with_index.map { |p, i| [p, i] }.sort_by { |thing| thing[0].size }
ap p2

def match_stuff(p, i, ex)
  p[i][0].each do |option|
    z = ex.index(option)
    if z.nil? || z >= i
      ex[i] = option
      if i == p.size - 1
        p ex
        m = 1
        ex.each_with_index do |field, index|
          if field =~ /^departure/
            m *= $my_ticket[p[index][1]]
          end
        end
        puts m
        exit
      else
        match_stuff(p, i + 1, ex)
      end
    end
  end
end

match_stuff(p2, 0, [])

