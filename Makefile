all: ca two_ca makeDir

makeDir:
	mkdir generations

ca: main.ml 
	ocamlfind ocamlopt -package imagelib -linkpkg -o ca main.ml
two_ca: 	
	ocamlfind ocamlopt -package imagelib -linkpkg -o two_ca 2d-ca.ml

clean:
	-rm ca two_ca *.o *.cmx *.cmi

clear:
	-rm ./generations/*.png
	
