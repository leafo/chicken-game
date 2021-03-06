.PHONY: run install deploy test

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
	chicken-install fast-generic

test: 
	csi -s test/main.scm

deploy:
	butler push -a http://localhost.com:8080 . leafo/chicken-game:linux
