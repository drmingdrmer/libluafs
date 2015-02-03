
VERSION     = 1.0

OUT         = testlib.so

TEST_FILE   = 'test_file.txt'

$(OUT): testlib.c Makefile
	cc -fPIC `lua-config --include` -DRELEASE=\"$(VERSION)\" -pedantic -ansi -Wall -O2 -c -o testlib.o testlib.c
	cc -o testlib.so -shared testlib.o
	strip testlib.so
	touch $(TEST_FILE)
	cd .. && make && cp libluafs.so tests/ && make clean

run:
	@for i in *.lua; do echo -e "\nRunning test : $$i" ;  lua $$i; done
	@echo -e "\n"

clean:
	-find . -name '*~' -exec rm \{\} \;
	-find . -name '.#*' -exec rm \{\} \;
	-rm -f testlib.so testlib.o libluafs.so $(TEST_FILE)

