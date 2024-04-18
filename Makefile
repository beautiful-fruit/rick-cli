CC ?= gcc
CFLAGS ?= -g -Wall -Wextra -pedantic -Wwrite-strings

RC_FILE = 

ifeq ($(OS),Windows_NT)

all:
	@echo Compiling rick roll...
	@$(CC) $(CFLAGS) rick.c -o rick.exe
	@echo Compile success.
	@echo
	@echo Output file rick.exe
	@echo Please exec \"Set-ItemProperty HKCU:\Console VirtualTerminalLevel -Type DWORD 1\" in powershell\(admin\) for colorful output.

clean:
	@echo Remove rick.exe...
	del rick.exe
	@echo Remove success.

else

ifneq (,$(wildcard ~/.bashrc))
RC_FILE = ~/.bashrc
else
RC_FILE = ~/.zshrc
endif

all:
	@echo Compiling rick roll...
	@$(CC) $(CFLAGS) rick.c -o rick
	@echo Compile success.

	@echo Create .rick directory...
	@if [ ! -d ~/.rick ]; then mkdir ~/.rick; fi
	@echo Move rick into .rick directory...
	@mv rick ~/.rick/rick
	@if [ -f $(RC_FILE) ]; then \
		echo Create alias to $(RC_FILE)...; \
		sed -i "s/alias rick=~\/.rick\/rick//g" $(RC_FILE); \
		echo "\nalias rick=~/.rick/rick\n" >> $(RC_FILE); \
		echo ""; \
		sed -i "/^$$/{:a;N;s/\\n$$//;ta}" $(RC_FILE); \
		echo "All finish, please \033[33mrestart your terminal\033[m or exec \033[33m\"source $(RC_FILE)\"\033[m"; \
	fi


clean:
	@echo Remove rick...
	@rm -f rick
	@echo Remove ~/.rick directory...
	@rm -rf ~/.rick

	@if [ -f $(RC_FILE) ]; then \
		echo Remove rick alias from $(RC_FILE)...; \
		sed -i "s/alias rick=~\/.rick\/rick//g" $(RC_FILE); \
	fi
	@echo Remove success.

endif
