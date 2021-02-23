void* memcpy(void *dest, void *src, unsigned long n) {
  unsigned char* d = (unsigned char*)dest;
  unsigned char* s = (unsigned char*)src;
  for (; n; n--, d++, s++) {
    unsigned char c = *s;
    *d = c;
  }
  return dest;
}
