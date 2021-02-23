#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "lib.h"

int main() {
  char s1[] = "hello world";
  char* s2 = (char*)malloc(1024);

  lib_func(s2, s1, strlen(s1));

  printf("%s\n", s1);
  printf("%s\n", s2);
  return 0;
}
