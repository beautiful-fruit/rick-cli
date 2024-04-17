CFLAGS	 ?= -g -Wall -Wextra -pedantic -Wwrite-strings

all: rick

rick: rick.c
	gcc $(CFLAGS) rick.c -o rick
	./install.sh

clean:
	-rm -rf ~/.rick
	sed -i "s/alias rick=~\/.rick\/rick//g" .bashrc
