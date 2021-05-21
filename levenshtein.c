#define MIN2(a, b) (a < b ? a : b)
#define MIN3(a, b, c) (MIN2(a, b) < c ? MIN2(a, b) : c)
#define MIN4(a, b, c, d) (MIN2(MIN3(a, b, c), d))
#define MIN5(a, b, c, d, e) (MIN3(MIN3(a, b, c), d, e))
#define MIN6(a, b, c, d, e, f) (MIN4(MIN3(a, b, c), d, e, f))
#define MIN7(a, b, c, d, e, f, g) (MIN5(MIN3(a, b, c), d, e, f, g))

#include <string.h>
#include <stdio.h>

int levenshtein(char *s1, char *s2) {
    unsigned int s1len, s2len, x, y, lastdiag, olddiag;
    s1len = strlen(s1);
    s2len = strlen(s2);
    unsigned int column[s1len+1];
    for (y = 1; y <= s1len; y++)
        column[y] = y;
    for (x = 1; x <= s2len; x++) {
        column[0] = x;
        for (y = 1, lastdiag = x-1; y <= s1len; y++) {
            olddiag = column[y];
            column[y] = MIN3(column[y] + 1, column[y-1] + 1, lastdiag + (s1[y-1] == s2[x-1] ? 0 : 1));
            lastdiag = olddiag;
        }
    }
    return(column[s1len]);
}

int main (int argc, char **argv)
{
 if (argc < 2)
  perror ("usage: levenshtein string1 string2");
    
 if (argc > 2)
  // printf("Distance de levensthein entre %s et %s : %i\n",argv[1],argv[2],levenshtein(argv[1],argv[2]));
  printf("%i",levenshtein(argv[1],argv[2]));

 return 0;
}
