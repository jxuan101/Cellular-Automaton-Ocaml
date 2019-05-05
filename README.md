
## Cellular Automata Modeling Project
This is a group project on cellular automata inspired by Conway's Game Of Life written in OCaml.

### Build Instructions
1. `make all`
2. edit 2d_seed.txt to desired starting generation.
3. `./2dca <numOfGenerations> <colorMode> <seedfile> <rule> <format>` 
	For example, ./two_ca 50 rainbow seed.txt sb 23/3 produces a colorful c.a. using `seed.txt` with 50 generations using the S/B format and 23/3 rules.
4. output of generations will be in `./generations` directory

### Formats
Click below for the cellular automaton rule lexicon:
http://psoup.math.wisc.edu/mcell/ca_rules.html

1. sb - Implemented. Rules in the S/B format are for example, 23/3 meaning survive if 2 or 3 neighbors, born if 3. Some examples are <br/>
  `./2dca 80 normal 2d_seed.txt sb 23/3` -Conway's Life <br/>
  `./2dca 80 normal 2d_seed.txt sb 12345/3` -Maze <br/>
  `./2dca 80 normal 2d_seed.txt sb 238/357` -Pseudo Life <br/>
  `./2dca 80 normal 2d_seed.txt sb 1358/357` -Amoeba <br/>
  
2. marg - Implemented. Rules in the Margulos format are for example, 0;8;4;3;2;5;9;6;1;6;10;11;12;13;14;15. The MS,D prefix   is automatically assumed. Instead of using a semi-colon as a delimiter, our program uses a comma separated list. <br/>
  `./2dca 50 normal 2d_seed.txt marg 0,8,4,3,2,5,9,7,1,6,10,11,12,13,14,15` -BBM <br/>
  `./2dca 40 poop sand.txt marg 0,4,8,12,4,12,12,13,8,12,12,14,12,13,14,15` -Sand (Try with sand.txt) <br/>
  
#### Notes
1. S and B could both be multiple digits

#### Clear Generations
`make clear` - removes all the png files in the `./generations` folder.

#### Convert PNG to GIF
`convert -delay 15 -loop 0 ./generations/*.png caoutput.gif` - assuming you have png files in the generations folder and the ImageMagick library properly installed we can run this command to create a gif


### Timeline

**April 4, 2019** - Implemented a one dimensional cellular automata that generates 8 generations from a provided generation 0. 

**April 11, 2019** - Begin implementation on 2d cellular automata.

**April 15, 2019** - 2d CA generations now are generated; but with no rules.

**April 15, 2019** - 2d CA implemented with rules by Conway.

**April 29, 2019** - updating readme and utilizing command line arguments.

**May 1, 2019** - 2d CA now accepts custom user input of rules in S/B format

**May 2, 2019** - modularized the 2d CA and allowed for multiple formats, incomplete Margulos

**May 4, 2019** - completed and implemented Margulos format

**May 4, 2019** - auto-detect generation size based on seed file which can be included by user prior to execution.

**May 5, 2019** - added some color options and specs output

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


**Another Maze**

![Another Maze](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/master/anothermaze.gif?raw=true)


**Brown Sand**

![Brown Sand](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/master/brownsand.gif?raw=true)


**Pong Particles**

![Pong Particles](https://github.com/ocamlca/Cellular-Automaton-Ocaml/blob/master/pongesque.gif?raw=true)

