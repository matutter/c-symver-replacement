.RECIPEPREFIX = -
.PHONE: all clean check

#
# Ref. https://stackoverflow.com/questions/8823267/linking-against-older-symbol-version-in-a-so-file
# Ref. https://sourceware.org/legacy-ml/glibc-linux/2000-q2/msg00012.html
# Ref. https://stackoverflow.com/questions/847179/multiple-glibc-libraries-on-a-single-host
#
#

all: main mainwp
- ./main
- ./mainwp
- @echo NORMAL  && objdump -t main   | grep memcpy
- @echo WRAPPED && objdump -t mainwp | grep memcpy

lib.a:
- gcc -c -o lib.o lib.c
- ar rc lib.a lib.o

main: lib.a
- gcc -c -o main.o main.c
- gcc -o main main.o lib.a

mainwp: lib.a
- gcc -c memcpywp.c -o memcpywp.o
- gcc -c main.c -o mainwp.o
- gcc -o mainwp -Wl,--version-script sym.map memcpywp.o mainwp.o lib.a

clean:
- rm -f memcpywp.o mainwp.o main mainwp lib.o lib.a main.o
