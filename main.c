#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "lib.h"

int main() {
  char s1[] = "hello world";
  char s2[1024] = { 0 };

  void* ptr = lib_func(s2, s1, strlen(s1));

  printf("s1='%s', ret=%p\n", s1, ptr);
  printf("s2='%s', ret=%p\n", s2, ptr);

  return 0;
}
