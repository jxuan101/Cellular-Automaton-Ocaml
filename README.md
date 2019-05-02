
## Cellular Automata Modeling Project
This is a group project on cellular automata inspired by Conway's Game Of Life written in OCaml.

### Build Instructions
1. `make all`
2. edit 2d_seed.txt to desired starting generation
3. create a new directory "generations" if not already existing
4. `./two_ca <number of generations> <survive> <born>` For example, ./two_ca 50 23 3 produces a c.a. with 50 generations with conway 23/3 rules.
5. output of generations will be in `./generations` directory

#### Notes
In order to have the size of the generation be `rowSz` by `colSz`, you must change two things:
1. `rowSz` and `colSz` variables located in the `two_ca.ml` file.
2. create a bitmap of the desired size `rowSz` and `colSz` 
3. the S/B family format is for example, 23/3 read as survive if 2 or 3 neighbors and born if 3 neighbors
4. S and B could both be multiple digits

#### Clear Generations
`make clear` - removes all the png files in the `./generations` folder.


### Timeline

**April 4, 2019** - Implemented a one dimensional cellular automata that generates 8 generations from a provided generation 0. 

**April 11, 2019** - Begin implementation on 2d cellular automata.

**April 15, 2019** - 2d CA generations now are generated; but with no rules.

**April 15, 2019** - 2d CA implemented with rules by Conway.

**April 29, 2019** - updating readme and utilizing command line arguments.

**May 1, 2019** - 2d CA now accepts custom user input of rules in S/B format

### Examples

**Conway's 3 Simple Rules**

**Immortal Butteryfly**

![Immortal Butterfly](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/2d-ca/2d-conway.gif?raw=true)


**Glider & Oscillator**

![Conway Glider](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/2d-ca/2d-glider.gif?raw=true)


**Colliding Gliders**

![Conway Glider](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/2d-ca/exploding_gliders.gif?raw=true)


**Maze**

![Maze](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/master/2d-maze-12345-3.gif?raw=true)


