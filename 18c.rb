class Foo
  attr_reader :n

  def initialize(n)
    @n = n
  end

  def *(rhs)
    Foo.new(@n + rhs.n)
  end

  def +(rhs)
    Foo.new(@n * rhs.n)
  end
end

i = 0
eval STDIN.readlines.map { |line| "i += (#{line.gsub(/(\d+)/, 'Foo.new(\1)').tr('+*', '*+')}).n" }.join("\n")
puts i
