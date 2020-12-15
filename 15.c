#include <stdio.h>

int spoken[30000000] = {0,13,1,16,6,17};
//int spoken[30000000] = {0,3,6};

int main()
{
  int n = 6, i, j, k;
  while(n < 30000000)
  {
    i = spoken[n - 1];
    k = -1;
    for(j = n - 2; j >= 0; --j) {
      if (spoken[j] == i) {
        k = j;
        break;
      }
    }
    if (k >= 0) {
      spoken[n] = n - k - 1;
    } else {
      spoken[n] = 0;
    }
    n++;
  }
  printf("%d\n", spoken[n - 1]);
}

