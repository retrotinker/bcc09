CFLAGS=-Wall -Wstrict-prototypes

all: bcc09-cpp

bcc09-cpp: main.o cpp.o hash.o token1.o token2.o
	$(CC) $(CFLAGS) -o bcc09-cpp main.o cpp.o hash.o token1.o token2.o

clean realclean:
	rm -f bcc09-cpp main.o cpp.o hash.o token1.o token2.o tmp.h

maintclean: realclean
	rm -f token1.h token2.h

install: bcc09-cpp
	install -d $(LIBDIR)
	install -m 755 bcc09-cpp $(LIBDIR)/bcc09-cpp

main.o: cc.h
cpp.o: cc.h
hash.o: cc.h
tree.o: cc.h

token1.o: token1.h
token2.o: token2.h

token1.h: token1.tok
	gperf -aptTc -N is_ctok -H hash1 token1.tok > tmp.h
	mv tmp.h token1.h

token2.h: token2.tok
	gperf -aptTc -k1,3 -N is_ckey -H hash2 token2.tok > tmp.h
	mv tmp.h token2.h
