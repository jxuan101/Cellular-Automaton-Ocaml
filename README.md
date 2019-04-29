
## Cellular Automata Modeling Project
This is a group project on cellular automata inspired by Conway's Game Of Life written in OCaml.

### Build Instructions
1. `make all`
2. edit 2d_seed.txt to desired starting generation
3. `./two_ca <number of generations>`
4. output of generations will be in `./generations` directory

#### Notes
In order to have the size of the generation be `rowSz` by `colSz`, you must change two things:
1. `rowSz` and `colSz` variables located in the `two_ca.ml` file.
2. create a bitmap of the desired size `rowSz` and `colSz` 

#### Clear Generations
`make clear` - removes all the png files in the `./generations` folder.


### Timeline

**April 4, 2019** - Implemented a one dimensional cellular automata that generates 8 generations from a provided generation 0. 

**April 11, 2019** - Begin implementation on 2d cellular automata.

**April 15, 2019** - 2d CA generations now are generated; but with no rules.

**April 15, 2019** - 2d CA implemented with rules by Conway.

**April 29, 2019** - updating readme and utilizing command line arguments.

### Examples

**Conway's 3 Simple Rules**

**Glider & Oscillator**

![Conway Glider](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/2d-ca/2d-glider.gif?raw=true)

**Colliding Gliders**
![Conway Glider](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/2d-ca/exploding_gliders.gif?raw=true)


