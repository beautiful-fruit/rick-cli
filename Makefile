CFLAGS	 ?= -g -Wall -Wextra -pedantic -Wwrite-strings

all: rick
	@echo Create .rick directory...
	@if [ ! -d ~/.rick ]; then mkdir ~/.rick; fi
	@echo Move rick into .rick directory...
	@mv rick ~/.rick/rick
	@echo Create alias to .bashrc...
	@sed -i "s/alias rick=~\/.rick\/rick//g" ~/.bashrc
	@echo "\nalias rick=~/.rick/rick\n" >> ~/.bashrc
	@echo All finish, please restart your terminal or exec "source ~/.bashrc"

rick: rick.c
	@echo Compiling rick roll...
	@gcc $(CFLAGS) rick.c -o rick
	@echo Compile success.

clean:
	@echo Remove rick...
	@rm -f rick
	@echo Remove ~/.rick directory...
	@rm -rf ~/.rick
	@echo Remove rick alias from ~/.bashrc...
	@sed -i "s/alias rick=~\/.rick\/rick//g" ~/.bashrc
	@echo Remove success.
