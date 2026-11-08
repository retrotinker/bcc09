PREFIX=/usr/local/bcc09

DIRS=ar as bcc copt cpp ld unproto

.PHONY: all check clean install

all: $(DIRS)
	for i in $^ ;\
	do \
		make PREFIX=$(PREFIX) -C $$i || exit 1 ;\
	done

# regression tests: compare outputs with the references in tests/ref,
# and run programs on sim6809 (from the plm09 project; see tests/sim)
SIM=tests/sim/sim6809

check: all $(SIM)
	tests/run.sh

$(SIM): tests/sim/*.c tests/sim/*.h
	$(CC) -std=c11 -O2 -DPLM09_VERSION='"0.4.2"' -o $@ tests/sim/*.c

# There is bound to be some more clever way to do this than copying
# the "all" rule...
clean: $(DIRS)
	for i in $^ ;\
	do \
		make PREFIX=$(PREFIX) -C $$i clean || exit 1 ;\
	done
	rm -f $(SIM)

install: $(DIRS)
	for i in $^ ;\
	do \
		make PREFIX=$(PREFIX) LIBEXECDIR=$(PREFIX)/libexec/bcc09 \
			-C $$i install || exit 1 ;\
	done
