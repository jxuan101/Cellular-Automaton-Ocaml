(* Draws an image. *)
let draw row col state img =
	match state with
	  	| 0 -> Image.write_rgb img col row 0 0 0
	  	| 1 -> Image.write_rgb img col row (Random.int 255) (Random.int 255) (Random.int 255)
	  	| _ -> ()

(* int pair struct*)
module IntPair = struct
	type t = int * int
	let compare = Pervasives.compare
end

module M = Map.Make(IntPair)

let rec fold_left_index f ls acc index =
	match ls with
	| h::t -> fold_left_index f t (f h acc index) (index+1)
	| [] -> acc

let insert_into_map ls =
	let m = M.empty in
	fold_left_index (
		fun col_lst m row ->(
			fold_left_index (
				fun v m col -> (
					M.add (row,col) v m
				)
			) col_lst m 0
		)
	) ls m 0

let zero = [0;0;0;0]
let one = [1;0;0;0]
let two = [0;1;0;0]
let three = [1;1;0;0]
let four = [0;0;1;0]
let five = [1;0;1;0]
let six = [0;1;1;0]
let seven = [1;1;1;0]
let eight = [0;0;0;1]
let nine = [1;0;0;1]
let ten = [0;1;0;1]
let eleven = [1;1;0;1]
let twelfth = [0;0;1;1]
let thirteenth = [1;0;1;1]
let fourteenth = [0;1;1;1]
let fifteenth = [1;1;1;1]

(* compares the square to the presets above *)
let compare2 square =
  if square = zero then 0
  else if square = one then 1
  else if square = two then 2
  else if square = three then 3
  else if square = four then 4
  else if square = five then 5
  else if square = six then 6
  else if square = seven then 7
  else if square = eight then 8
  else if square = nine then 9
  else if square = ten then 10
  else if square = eleven then 11
  else if square = twelfth then 12
  else if square = thirteenth then 13
  else if square = fourteenth then 14
  else 15

(* compares the amount of neighbors to survive or born *)
let compare square rule r c nextMap =
	let index = compare2 square in
  let change = List.nth rule index in
  match change with
  | "0" -> M.add (r,c) 0 nextMap; M.add (r,c+1) 0 nextMap;
           M.add (r+1,c) 0 nextMap; M.add (r+1,c+1) 0 nextMap;
  | "1" -> M.add (r,c) 1 nextMap; M.add (r,c+1) 0 nextMap;
           M.add (r+1,c) 0 nextMap; M.add (r+1,c+1) 0 nextMap;
  | "2" -> M.add (r,c) 0 nextMap; M.add (r,c+1) 1 nextMap;
           M.add (r+1,c) 0 nextMap; M.add (r+1,c+1) 0 nextMap;
  | "3" -> M.add (r,c) 1 nextMap; M.add (r,c+1) 1 nextMap;
           M.add (r+1,c) 0 nextMap; M.add (r+1,c+1) 0 nextMap;
  | "4" -> M.add (r,c) 0 nextMap; M.add (r,c+1) 0 nextMap;
           M.add (r+1,c) 1 nextMap; M.add (r+1,c+1) 0 nextMap;
  | "5" -> M.add (r,c) 1 nextMap; M.add (r,c+1) 0 nextMap;
           M.add (r+1,c) 1 nextMap; M.add (r+1,c+1) 0 nextMap;
  | "6" -> M.add (r,c) 0 nextMap; M.add (r,c+1) 1 nextMap;
           M.add (r+1,c) 1 nextMap; M.add (r+1,c+1) 0 nextMap;
  | "7" -> M.add (r,c) 1 nextMap; M.add (r,c+1) 1 nextMap;
           M.add (r+1,c) 1 nextMap; M.add (r+1,c+1) 0 nextMap;
  | "8" -> M.add (r,c) 0 nextMap; M.add (r,c+1) 0 nextMap;
           M.add (r+1,c) 0 nextMap; M.add (r+1,c+1) 1 nextMap;
  | "9" -> M.add (r,c) 1 nextMap; M.add (r,c+1) 0 nextMap;
           M.add (r+1,c) 0 nextMap; M.add (r+1,c+1) 1 nextMap;
  | "10" -> M.add (r,c) 0 nextMap; M.add (r,c+1) 1 nextMap;
           M.add (r+1,c) 0 nextMap; M.add (r+1,c+1) 1 nextMap;
  | "11" -> M.add (r,c) 1 nextMap; M.add (r,c+1) 1 nextMap;
           M.add (r+1,c) 0 nextMap; M.add (r+1,c+1) 1 nextMap;
  | "12" -> M.add (r,c) 0 nextMap; M.add (r,c+1) 0 nextMap;
           M.add (r+1,c) 1 nextMap; M.add (r+1,c+1) 1 nextMap;
  | "13" -> M.add (r,c) 1 nextMap; M.add (r,c+1) 0 nextMap;
           M.add (r+1,c) 1 nextMap; M.add (r+1,c+1) 1 nextMap;
  | "14" -> M.add (r,c) 0 nextMap; M.add (r,c+1) 1 nextMap;
           M.add (r+1,c) 1 nextMap; M.add (r+1,c+1) 1 nextMap;
  | "15" -> M.add (r,c) 1 nextMap; M.add (r,c+1) 1 nextMap;
           M.add (r+1,c) 1 nextMap; M.add (r+1,c+1) 1 nextMap;


(* Generating the next generation according to rule given. *)
let nextGen oldGen rowSz colSz rule =
	let nextMap = M.empty in
	M.fold (fun (r,c) value nextMap ->
      if ((r%2) = 0 && (c%2) = 0) then
      (
  			let square = [value;(M.find (r,c+1) oldGen);(M.find (r+1,c) oldGen);
          (M.find (r+1,c+1) oldGen)] in
        (compare square rule r c nextMap)
      )
      else ()
	) oldGen nextMap

(* Draws and outputs a given generation. *)
let drawGen gen img numGen =
	M.iter (fun (r,c) value ->
  		draw r c value img
  	) gen;

	let output_destination = "./generations/gen_" in
	let file_extension = ".png" in
	let num = string_of_int numGen in
	let final_string = output_destination ^ num ^ file_extension in

	(* create the image *)
	ImageLib.writefile final_string img;

(* Generates the remaining generations. *)
let rec drawRemainder currentGen img numGen rSz cSz inc rule =
	if (numGen > 0 && inc <= numGen) then (
		(* create a new generation *)
		let newGen = nextGen currentGen rSz cSz rule in
		drawGen newGen img inc;
		drawRemainder newGen img numGen rSz cSz (inc+1) rule
	)
  else ()

(* Parses the rules of Margulos to a list containing the 16 mappings. *)
let parser x =
	let split = Str.split (Str.regexp ",") in
  split x
