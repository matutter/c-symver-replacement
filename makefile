.RECIPEPREFIX = -
.PHONE: all clean check

#
# Ref. https://stackoverflow.com/questions/8823267/linking-against-older-symbol-version-in-a-so-file
# Ref. https://sourceware.org/legacy-ml/glibc-linux/2000-q2/msg00012.html
# Ref. https://stackoverflow.com/questions/847179/multiple-glibc-libraries-on-a-single-host
#
#

all: main mainwp mainst
- ./main
- ./mainwp
- ./mainst
- @echo NORMAL  && objdump -t main   | grep memcpy
- @echo WRAPPED && objdump -t mainwp | grep memcpy
- @echo STATIC  && objdump -t mainst | grep memcpy

lib.a:
- gcc -c -o lib.o lib.c
- ar rc lib.a lib.o

# There is not dependency injection here, just using memcpy@@GLIB_2.14
main: lib.a
- gcc -c -o main.o main.c
- gcc -o main main.o lib.a

memcpy.a:
- gcc -c -o memcpy.o memcpy.c
- ar rc memcpy.a memcpy.o

# Compiling in an object that resolves the `memcpy` symbol overrides the libc
# version.
mainst: lib.a memcpy.a
- gcc -g -ggdb -c -o mainst.o main.c
# NOTE: This only works when the dependent comes before the dependency
- gcc -g -ggdb -o mainst mainst.o lib.a memcpy.a

# Using a version script and `.symver` overrides uses our own version of
# `memcpy`. If the version of our implementation were the same as or newer than
# 2.14 then memcpy@@GLIBC_2.14 would be used. In order for our version to be
# used the `.symver` we declare our symbol at must be older to be concidered for
# linking first.
#
# NOTE: I'm not sure what the different is between memcpy@GLIBC and
# memcpy@@GLIBC is. Only "@@" works.
mainwp: lib.a
- gcc -c memcpywp.c -o memcpywp.o
- gcc -c main.c -o mainwp.o
- gcc -o mainwp -Wl,--version-script sym.map memcpywp.o mainwp.o lib.a

clean:
- rm -f memcpywp.o mainwp.o main mainwp lib.o lib.a main.o memcpy.a memcpy.o mainst mainst.o
