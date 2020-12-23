// if brute force doesn't work, you're not using enough :P

#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
using namespace std;

const string SEED_INPUT = "364297581"; //"389125467";
const int SIZE = 1000000;
const int ITERATIONS = 10000000;

struct Node
{
  int label;
  Node *prev;
  Node *next;
};

class Ring
{
  vector<Node> m_nodes;
  vector<int> m_index;
  Node *m_pCurrent;

public:
  Ring()
  {
    m_nodes.resize(SIZE);
    m_pCurrent = &m_nodes[0];

    int i;
    for(i = 0; i < SEED_INPUT.size(); ++i) {
      m_nodes[i].label = SEED_INPUT[i] - '0';
    }
    for(; i < SIZE; ++i) {
      m_nodes[i].label = i + 1;
    }

    for(i = 0; i < SIZE - 1; ++i) {
      m_nodes[i].next = &m_nodes[i + 1];
      m_nodes[i + 1].prev = &m_nodes[i];
    }
    m_nodes[0].prev = &m_nodes[SIZE - 1];
    m_nodes[SIZE - 1].next = &m_nodes[0];

    int seed_size = SEED_INPUT.size();
    m_index.resize(seed_size);
    for(i = 0; i < seed_size; ++i) {
      m_index[m_nodes[i].label - 1] = i;
    }
  }

  void iterate()
  {
    Node *pFirstCut = m_pCurrent->next;
    Node *pLastCut = pFirstCut->next->next;
    Node *pAfterSplice = pLastCut->next;
    m_pCurrent->next = pAfterSplice;
    pAfterSplice->prev = m_pCurrent;

    int destination = m_pCurrent->label - 1;
    if (destination < 1) destination = SIZE;
    for(;;) {
      bool inCut = false;
      for(Node *p = pFirstCut; p != pAfterSplice; p = p->next) {
        if (p->label == destination) {
          inCut = true;
          break;
        }
      }
      if (inCut) {
        --destination;
        if (destination < 1) destination = SIZE;
      } else break;
    }

    Node *spliceAfter = find(destination);
    Node *spliceBefore = spliceAfter->next;
    spliceAfter->next = pFirstCut;
    pFirstCut->prev = spliceAfter;
    pLastCut->next = spliceBefore;
    spliceBefore->prev = pLastCut;

    m_pCurrent = m_pCurrent->next;
  }

  void print()
  {
    cout << '(' << m_pCurrent->label << ") ";
    for(Node *p = m_pCurrent->next; p != m_pCurrent; p = p->next) {
      cout << p->label << ' ';
    }
    cout << endl;
  }

  Node *find(int label)
  {
    Node *p = 0;
    if (label <= SEED_INPUT.size()) {
      return &m_nodes[m_index[label - 1]];
    } else {
      return &m_nodes[label - 1];
    }
  }
};

int main()
{
  Ring ring;

  for(int i = 0; i < ITERATIONS; ++i) {
  //ring.print();
    ring.iterate();
  }
  Node *one = ring.find(1);
  int a = one->next->label;
  int b = one->next->next->label;
  cout << a << " * " << b << " = " << (long long)a * b << endl;

  return 0;
}
