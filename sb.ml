(* Draws an image. *)
let draw row col state img =
	match state with
	  	| 0 -> Image.write_rgb img col row 255 255 255
	  	| 1 -> Image.write_rgb img col row 0 0 0
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

(* Returns the neighbor count. *)
let countNeighbors r c oldGen =
  Printf.printf "(%i, %i)\n" r c; 
	let count = 0
	|> (+) (M.find (r-1,c-1) oldGen)
	|> (+) (M.find (r,c-1) oldGen)
	|> (+) (M.find (r+1,c-1) oldGen)
	|> (+) (M.find (r-1,c) oldGen)
	|> (+) (M.find (r+1,c) oldGen)
	|> (+) (M.find (r-1,c+1) oldGen)
	|> (+) (M.find (r,c+1) oldGen)
	|> (+) (M.find (r+1,c+1) oldGen)
	in count

(* compares the amount of neighbors to survive or born *)
let rec compare neighbors ls =
	match ls with
	| h::t -> if (neighbors = h) then true else compare neighbors t
	| [] -> false

(* Generating the next generation according to rule given. *)
let nextGen oldGen rowSz colSz survive born =
	let nextMap = M.empty in
	M.fold (fun (r,c) value nextMap ->
		if (r > 0 && r < (rowSz-1) && c > 0 && c < (colSz-1)) then (
			(* count neighbors *)
			let neighbors = countNeighbors r c oldGen in
			if (neighbors > 0) then(
				(*Printf.printf "# of neighbors @ (%i, %i) -> %i -> %i\n" (r) (c) (neighbors);*)
				if (value = 1 && (compare neighbors survive) = true) then
					M.add (r,c) value nextMap
				else if (value = 1 && (compare neighbors survive) = false) then
				 	M.add (r,c) 0 nextMap
				else if (value = 0 && (compare neighbors born) = true) then
					M.add (r,c) 1 nextMap
				else
					M.add (r,c) 0 nextMap
			)
			else (
				M.add (r,c) 0 nextMap
				);

		)
		else(
			(* Printf.printf "[OUT OF BOUNDS](%i, %i) -> %i\n" r c value; *)
			M.add (r,c) value nextMap
		)
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
	ImageLib.writefile final_string img

(* Generates the remaining generations. *)
let rec drawRemainder currentGen img numGen rSz cSz inc survive born =
	if (numGen > 0 && inc <= numGen) then (
		(* create a new generation *)
		let newGen = nextGen currentGen rSz cSz survive born in
		drawGen newGen img inc;
		drawRemainder newGen img numGen rSz cSz (inc+1) survive born
	)else(
		()
	)

(* Converts an int to a list of its digits. *)
let digits_of_int x =
  let rec digits x acc =
  	if x < 10 then 
  	(
  	  if x != 9 then x::acc 
  	  else acc
  	)
  	else digits (x/10) ((x mod 10)::acc) in
  digits x []

(* Parses the rules of Margolus to a list containing each transition. *)
let parser x =
	let split = Str.split (Str.regexp "/") in
  split x
