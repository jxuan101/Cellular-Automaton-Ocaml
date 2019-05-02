all: ca two_ca

ca: main.ml 
	ocamlfind ocamlopt -package imagelib -linkpkg -o ca main.ml
two_ca: 2d-ca.ml	
	ocamlfind ocamlopt -package imagelib -linkpkg -o two_ca str.cmxa sb.ml marg.ml 2d-ca.ml

clean:
	-rm ca two_ca *.o *.cmx *.cmi

clear:
	-rm ./generations/*.png
	
