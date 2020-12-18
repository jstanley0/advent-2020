homework = STDIN.readlines

puts <<CODE
#include <iostream>
using namespace std;

class dig {
  long long m_i;
public:
  dig(long long i) : m_i(i) {}
  dig operator+(const dig& rhs) { return m_i * rhs.m_i; }
  dig operator*(const dig& rhs) { return m_i + rhs.m_i; }
  long long to_i() { return m_i; }
};

int main() {
long long i = 0;
CODE

homework.map { |line| line.gsub(/(\d+)/, 'dig(\1)').tr('+*', '*+') }.each do |hack|
  puts "i += (#{hack.strip}).to_i();"
end

puts <<CODE
cout << i << endl;
return 0;
}
CODE
