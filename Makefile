.PHONY: run install deploy

run:
	csi -s main.scm

main: main.scm
	csc  $<

deploy: 
	csc -deploy -o deploy main.scm
	chicken-install -deploy -p deploy sdl2
	chicken-install -deploy -p deploy loops

install: 
	chicken-install sdl2
	chicken-install loops
