def tokenize(line)
  # come back to this if we have multi-digit numbers :P
  line.gsub(/\s/,'').chars
end

def evaluate_term(tokens)
  t = tokens.shift
  if t == '('
    sub_tokens = []
    paren_depth = 1
    loop do
      t = tokens.shift
      if t == '('
        paren_depth += 1
      elsif t == ')'
        paren_depth -= 1
        break if paren_depth == 0
      end
      sub_tokens << t
    end
    evaluate(sub_tokens)
  else
    t.to_i
  end
end

def evaluate(tokens)
  val = evaluate_term(tokens)
  op = tokens.shift
  rval = evaluate_term(tokens)

  val = case op
  when '+'
    val + rval
  when '*'
    val * rval
  end

  until tokens.empty?
    op = tokens.shift
    rval = evaluate_term(tokens)

    val = case op
    when '+'
      val + rval
    when '*'
      val * rval
    end
  end

  val
end

def parse_line(line)
  evaluate(tokenize(line))
end

homework = STDIN.readlines
puts homework.map { |line| parse_line(line) }.sum
