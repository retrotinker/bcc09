all: ar as bcc copt cpp ld unproto
	for i in $^ ;\
	do \
		make -C $$i ;\
	done
