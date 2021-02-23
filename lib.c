#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void* lib_func(void* dest, void* src, size_t n) {
  printf("in lib func\n");
  return memcpy(dest, src, n);
}
