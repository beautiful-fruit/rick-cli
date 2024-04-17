CFLAGS	 ?= -g -Wall -Wextra -pedantic -Wwrite-strings

all: rick

rick: rick.c
	gcc $(CFLAGS) rick.c -o rick
	if [ ! -d ~/.rick ]; then
		mkdir ~/.rick
	fi
	mv rick ~/.rick/rick
	echo -e "alias rick=~/.rick/rick\n" >> ~/.bashrc

clean:
	-rm -rf ~/.rick
	sed -i "s/alias rick=~\/.rick\/rick//g" .bashrc
