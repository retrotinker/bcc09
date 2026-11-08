PREFIX=/usr/local/bcc09

DIRS=ar as bcc copt cpp ld unproto

all: $(DIRS)
	for i in $^ ;\
	do \
		make PREFIX=$(PREFIX) -C $$i || exit 1 ;\
	done

# There is bound to be some more clever way to do this than copying
# the "all" rule...
clean: $(DIRS)
	for i in $^ ;\
	do \
		make PREFIX=$(PREFIX) -C $$i clean || exit 1 ;\
	done

install: $(DIRS)
	for i in $^ ;\
	do \
		make PREFIX=$(PREFIX) LIBEXECDIR=$(PREFIX)/libexec/bcc09 \
			-C $$i install || exit 1 ;\
	done
