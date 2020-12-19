$rules = {}
loop do
  line = gets.chomp
  break if line.empty?

  key, val = line.split(':')
  val = val.split('|').map { |side| side.split.map { |thing| eval thing } }
  $rules[key.to_i] = val
end

def match?(code, message)
  puts "#{message} #{code.inspect}"
  return true if code.empty? && message.empty?
  return false if code.empty? || message.empty?
  if code[0].is_a?(String)
    code[0] == message[0] && match?(code[1..-1], message[1..-1])
  else
    rule = $rules[code[0]]
    rule.any? do |subcode|
      match?(subcode + code[1..-1], message)
    end
  end
end

def match_rule?(rule, message)
  rule.any? do |code|
    match?(code, message)
  end
end

count = 0
rule = $rules[0]

loop do
  message = gets&.chomp
  break if message.nil? || message.empty?
  count += 1 if match_rule?(rule, message)
end

puts count
