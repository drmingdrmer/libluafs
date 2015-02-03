VERSION     = 1.0

OUT         = libluafs.so

$(OUT): libluafs.c Makefile
	cc -fPIC `lua-config --include` -DRELEASE=\"$(VERSION)\" -pedantic -ansi -Wall -O2 -c -o libluafs.o libluafs.c
	cc -o libluafs.so -shared libluafs.o
	strip libluafs.so


clean:
	-find . -name '*~' -exec rm \{\} \;
	-find . -name '.#*' -exec rm \{\} \;
	-rm -f libluafs.so libluafs.o


test:
	cd tests && make


uninstall:
	rm -f /usr/lib/lua/5.0/$(OUT)
	rm -f /usr/share/lua50/libluafs.lua

