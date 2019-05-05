all: 1dca 2dca makeDir

makeDir:
	mkdir -p generations

1dca: ca1d.ml 
	ocamlfind ocamlopt -package imagelib -linkpkg -o 1dca ca1d.ml
2dca: 	
	ocamlfind ocamlopt -package imagelib -linkpkg -g -o 2dca str.cmxa sb.ml marg.ml ca2d.ml

clean:
	-rm 1dca 2dca *.o *.cmx *.cmi

clear:
	-rm ./generations/*.png
	
