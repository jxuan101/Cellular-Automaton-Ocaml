(*
	Author: Kent Feng ,Jin Huai Xuan
	Implementation of Conway's Game of Life in two dimensions.
	Specs:
	Default size: 		  50 x 50 pixels
	Seed generation file: 2d_seed.txt
*)
(*removes the head element from a list*)
let cut x =
  match x with
  | [] -> []
  | h::t -> t

(* file reading functions *)
let input_line_opt ic =
	try Some (input_line ic)
	with End_of_file -> None

let read_lines ic =
	let rec aux acc =
		match input_line_opt ic with
		| Some line -> aux (line::acc)
		| None -> (List.rev acc)
	in
	aux []

let lines_of_file filename =
	let ic = open_in filename in
	let lines = read_lines ic in
	close_in ic;
	(lines)

let draw row col state img =
	match state with
	  	| 0 -> Image.write_rgb img col row 0 0 0
	  	| 1 -> Image.write_rgb img col row (Random.int 255) (Random.int 255) (Random.int 255)
	  	| _ -> ()

(* Parses a string to a list of ints. *)
let list_of_string str =
  let rec ls_of_string str acc =
    match str.[0] with
    | '0' -> if ((String.length str) > 1) then
      ls_of_string (String.sub str 1 ((String.length str)-1)) (0::acc)
      else (0::acc)
    | '1' -> if ((String.length str) > 1) then
      ls_of_string (String.sub str 1 ((String.length str)-1)) (1::acc)
      else (1::acc)
    | _ -> if ((String.length str) > 1) then
      ls_of_string (String.sub str 1 ((String.length str)-1)) (0::acc)
      else (0::acc)
  in
  ls_of_string str []

(* transforms list of strings to list of list of strings *)
let array_stuffer arr =
	let rec helper arr acc =
		match arr with
		| h::t -> (
			let arrOfString = list_of_string h in
			helper t (arrOfString::acc)

		)
		| [] -> (List.rev acc)
	in
	helper arr []

let rec print_int_array ls =
	match ls with
	| h::t -> print_int h; print_int_array t
	| [] -> print_endline ""

(* Converts an int to a list of its digits. *)
let digits_of_int x =
	let rec digits x acc =
		if x < 10 then x::acc
		else digits (x/10) ((x mod 10)::acc) in
	digits x []

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

let countNeighbors r c oldGen =
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

let nextGen oldGen rowSz colSz survive born =
	let nextMap = M.empty in
	M.fold (fun (r,c) value nextMap ->
		if (r > 0 && r < (rowSz-1) && c > 0 && c < (colSz-1)) then (
			(* count neighbors *)
			let neighbors = countNeighbors r c oldGen in
			if (neighbors > 0) then(
				(* Printf.printf "# of neighbors @ (%i, %i) -> %i\n" (r) (c) (neighbors); *)
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

let rec drawRemainder currentGen img numGen rSz cSz inc survive born =
	if (numGen > 0 && inc <= numGen) then (
		(* create a new generation *)
		let newGen = nextGen currentGen rSz cSz survive born in
		drawGen newGen img inc;
		drawRemainder newGen img numGen rSz cSz (inc+1) survive born
	)else(
		()
	)

(* MAIN *)
let () =

	(* get command line arguments into a list*)
  	let argv_list_original = Array.to_list Sys.argv in
  	let cleaned_list = cut argv_list_original in


  	let list_len = List.length cleaned_list in
  	if list_len < 3
    	then Printf.printf "usage: ./two_ca <numOfGenerations> <survive> <born>\n"
  	else
    	let numGen = int_of_string(List.nth cleaned_list 0) in
    	(* if(numGen <= 0) then let numGen = 50 in *)
			let s = int_of_string(List.nth cleaned_list 1) in
			let survive = digits_of_int s in
			let b = int_of_string(List.nth cleaned_list 2) in
			let born = digits_of_int b in

	let rowSz = 50 in
	let colSz = 50 in

	(* Build seed generation *)
	let img = Image.create_rgb ~alpha:false ~max_val:255 rowSz colSz in

  	(* retrieve and draw generation 0 from txt.file *)
  	let lines = lines_of_file "2d_seed.txt" in
  	let newLines = array_stuffer lines in
  	let genZero = insert_into_map newLines in
  	drawGen genZero img 0;

  	drawRemainder genZero img (numGen-1) rowSz colSz 1 survive born;
