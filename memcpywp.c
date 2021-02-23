#include <stdio.h>
#include <stddef.h>
#include <string.h>

__asm__ (".symver memcpywp, memcpy@@GLIBC_2.4");
void *memcpywp(void *dest, const void *src, size_t n) {
  printf("memcpy(%p, %p, %zu)\n", dest, src, n);
  return memmove(dest, src, n);
}
