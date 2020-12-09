require 'awesome_print'
require 'set'

Inst = Struct.new(:opcode, :arg, :hit)

$source = STDIN.readlines

def compile
  $source.map do |line|
    opcode, arg = line.split(' ')
    Inst.new(opcode, arg.to_i)
  end
end

def run(program)
  ip = 0
  ax = 0
  while ip < program.size
    inst = program[ip]
    if inst.hit
      puts "cycle at #{ip}"
      return false
    end
    #old_ip = ip
    case inst.opcode
    when 'acc'
      ax += inst.arg
      ip += 1
    when 'jmp'
      ip += inst.arg
      #puts "#{old_ip} => #{ip}"
    else
      #puts "#{old_ip} ?? #{ip + inst.arg}"
      ip += 1
    end
    inst.hit = true
  end
  puts "completed! #{ax}"
  true
end

(0...$source.size).each do |munge_ix|
  prog = compile
  if prog[munge_ix].opcode == 'jmp'
    prog[munge_ix].opcode = 'nop'
  elsif prog[munge_ix].opcode == 'nop'
    prog[munge_ix].opcode = 'jmp'
  else
    next
  end
  puts "attempting #{munge_ix}"
  break if run(prog)
end
