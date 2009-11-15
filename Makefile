all: ar as bcc copt cpp ld unproto
	for i in $^ ;\
	do \
		make -C $$i ;\
	done

# There is bound to be some more clever way to do this than copying
# the "all" rule...
clean: ar as bcc copt cpp ld unproto
	for i in $^ ;\
	do \
		make -C $$i clean ;\
	done
