all: ca

ca: main.ml 
	ocamlfind ocamlopt -package imagelib -linkpkg -o ca main.ml

clean:
	-rm ca *.o *.cmx *.cmi
