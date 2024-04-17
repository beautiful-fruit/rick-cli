CFLAGS	 ?= -g -Wall -Wextra -pedantic -Wwrite-strings

all: rick
	if [ ! -d ~/.rick ]; then mkdir ~/.rick; fi
	mv rick ~/.rick/rick
	sed -i "s/alias rick=~\/.rick\/rick//g" ~/.bashrc
	echo "\nalias rick=~/.rick/rick\n" >> ~/.bashrc
	. ~/.bashrc

rick: rick.c
	gcc $(CFLAGS) rick.c -o rick

clean:
	rm -f rick
	rm -rf ~/.rick
	sed -i "s/alias rick=~\/.rick\/rick//g" ~/.bashrc
