.PHONY: run install deploy

# run: main.scm
# 	csi -s $<

%.o: %.scm
	csc -c $<

main: main.o vectors.o controller.o
	csc -o $@ $+

deploy: 
	csc -deploy -o deploy main.scm
	chicken-install -deploy -p deploy sdl2
	chicken-install -deploy -p deploy loops

install: 
	chicken-install sdl2
	chicken-install loops
