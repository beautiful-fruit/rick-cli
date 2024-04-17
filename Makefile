CFLAGS	 ?= -g -Wall -Wextra -pedantic -Wwrite-strings

all: rick
	@echo Create .rick directory...
	@if [ ! -d ~/.rick ]; then mkdir ~/.rick; fi
	@echo Move rick into .rick directory...
	@mv rick ~/.rick/rick
	@if [ -f ~/.bashrc ]; then \
		@echo Create alias to .bashrc... \
		@sed -i "s/alias rick=~\/.rick\/rick//g" ~/.bashrc \
		@echo "\nalias rick=~/.rick/rick\n" >> ~/.bashrc \
		@echo "" \
		@echo "All finish, please \033[33mrestart your terminal\033[m or exec \033[33m\"source ~/.bashrc\"\033[m" \
	@elif [ -f ~/.zshhrc ]; then \
		@echo Create alias to .zshrc... \
		@sed -i "s/alias rick=~\/.rick\/rick//g" ~/.zshrc \
		@echo "\nalias rick=~/.rick/rick\n" >> ~/.zshrc \
		@echo "" \
		@echo "All finish, please \033[33mrestart your terminal\033[m or exec \033[33m\"source ~/.zshrc\"\033[m" \
	@fi

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
