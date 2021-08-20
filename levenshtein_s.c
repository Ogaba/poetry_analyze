#define MIN2(a, b) (a < b ? a : b)
#define MIN3(a, b, c) (MIN2(a, b) < c ? MIN2(a, b) : c)

#include <string.h>
#include <stdio.h>

// Levenshtein distance between 2 words
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

// Levenshtein distance in all the words of sentence
int levenshtein_s(char *str) {
  unsigned int lvs = 0;
  char pchlist[8000][500]; 
  char* context = NULL;

  // printf ("Splitting string \"%s\" into tokens:\n",str);
  char* pch = strtok_r (str,";", &context);
  int num_tokens = 0;
  while (pch != NULL)
  {
    strcpy(pchlist[num_tokens], pch);
    num_tokens++;
    pch = strtok_r (NULL, ";", &context);
  }

  // printf("num_tokens = %i\n", num_tokens);
  for (int i=0; i < num_tokens-1; i++) {
    // printf("%s\n", pchlist[i]);
    lvs += levenshtein(pchlist[i], pchlist[i+1]);
    // printf(" levenshtein distance between %s and %s : %i\n", pchlist[i], pchlist[i+1], levenshtein(pchlist[i], pchlist[i+1]));
  }
  return(lvs);
}

// Main programm
int main (int argc, char **argv)
{
 if (argc < 1)
  perror ("usage: levenshtein <sentence>");
    
 if (argc > 2)
  perror ("usage: levenshtein <sentence>");
 
 // printf("Distance de levensthein entre les mots de %s : %i\n",argv[1],levenshtein_s(argv[1]));
 printf("%i",levenshtein_s(argv[1]));
 return 0;
}
