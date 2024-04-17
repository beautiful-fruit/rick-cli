CFLAGS	 ?= -g -Wall -Wextra -pedantic -Wwrite-strings

all: rick

rick: rick.c
	gcc $(CFLAGS) rick.c -o rick

clean:
	-rm -f rick
