.PHONY: run install

run:
	csi -s main.scm

main: main.scm
	csc $<

install: 
	chicken-install sdl2
	chicken-install loops
