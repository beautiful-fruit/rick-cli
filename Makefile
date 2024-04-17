CFLAGS	 ?= -g -Wall -Wextra -pedantic -Wwrite-strings

all: rick
	chmod 755 install.sh
	./install.sh

rick: rick.c
	gcc $(CFLAGS) rick.c -o rick

clean:
	-rm -rf ~/.rick
	sed -i "s/alias rick=~\/.rick\/rick//g" .bashrc
