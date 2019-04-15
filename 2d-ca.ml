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
	  	| 0 -> ()
	  	| 1 -> Image.write_rgb img row col (Random.int 255) (Random.int 255) (Random.int 255)
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
	(* List.iter (print_int) ls in print_endline "" *)
	match ls with
	| h::t -> print_int h; print_int_array t
	| [] -> print_endline ""


(* int pair struct*)
module IntPair = struct 
	type t = int * int
	let compare = Pervasives.compare
end


module M = Map.Make(IntPair)

(* let insert_into_map ls m =
	List.iteri (
		fun row col_lst -> (List.iteri (fun col value -> M.add (row,col) value; ()) col_lst)
		) ls *)
let insert_into_map ls=
	List.iteri (
		fun row col_lst -> (
			List.iteri (
				fun col value ->  
					M.add (row,col) value; () 
			) col_lst
		)
	) ls


let () =

	(* Build seed generation *)
	let img = Image.create_rgb ~alpha:false ~max_val:255 50 50 in

  	(* retrieve generation 0 from txt.file *)
	  	let lines = lines_of_file "2d_seed.txt" in
	  	List.iter print_endline lines;
	  	let newLines = array_stuffer lines in
	  	let m = M.empty in
	  	insert_into_map newLines;
	  	M.iter (fun (r,c) value ->
	  		Printf.printf "(%i, %i) -> %i" r c value;print_endline "" ) m;
	  	(* insert into map *)



