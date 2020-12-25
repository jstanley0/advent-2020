// if brute force doesn't work, you're not using enough :P

#include <iostream>
#include <string>
#include <vector>
#include <stdexcept>
using namespace std;

const string SEED_INPUT = "364297581";
const int SIZE = 1000000;
const int ITERATIONS = 10000000;

class Ring
{
  vector<int> m_next;
  int m_current;

public:
  Ring()
  {
    m_next.resize(SIZE + 1);
    m_next[0] = 0;  // unused, because 1-based labels
    int i = 0;
    m_current = SEED_INPUT[0] - '0';
    for(; i < SEED_INPUT.size() - 1; ++i) {
      int from = SEED_INPUT[i] - '0';
      int to = SEED_INPUT[i + 1] - '0';
      m_next[from] = to;
    }
    m_next[SEED_INPUT[i++] - '0'] = SEED_INPUT.size() + 1;
    for(i++; i < SIZE; ++i) {
      m_next[i] = i + 1;
    }
    m_next[SIZE] = m_current;
  }

  void iterate()
  {
    int cut1 = m_next[m_current];
    int cut2 = m_next[cut1];
    int cut3 = m_next[cut2];
    int afterCut = m_next[cut3];
    m_next[m_current] = afterCut;

    int destination = m_current - 1;
    if (destination < 1) destination = SIZE;
    while(destination == cut1 || destination == cut2 || destination == cut3) {
      --destination;
      if (destination < 1) destination = SIZE;
    }
    int spliceAfter = m_next[destination];
    m_next[destination] = cut1;
    m_next[cut3] = spliceAfter;

    m_current = m_next[m_current];
  }

  int from(int start, int count)
  {
    int n = start;
    for(int i = 0; i < count; ++i) {
      n = m_next[n];
    }
    return n;
  }

  void print()
  {
    cout << '(' << m_current << ") ";
    for(int i = m_next[m_current]; i != m_current; i = m_next[i]) {
      if (i == 0) {
        throw runtime_error("fail");
      }
      cout << i << ' ';
    }
    cout << endl;
  }

};

int main()
{
  Ring ring;
  for(int i = 0; i < ITERATIONS; ++i) {
    //ring.print();
    ring.iterate();
  }
  //ring.print();
  int a = ring.from(1, 1);
  int b = ring.from(1, 2);
  cout << a << " * " << b << " = " << (long long)a * b << endl;

  return 0;
}
