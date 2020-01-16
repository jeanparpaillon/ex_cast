SOURCES = hello.c hello.h
AST = hello.xml

all: $(AST)

$(AST): $(SOURCES)
	castxml -c -x c -std=gnu11 --castxml-cc-gnu gcc --castxml-gccxml -o $@ $<

clean:
	rm -f $(AST)

.PHONY: all clean
