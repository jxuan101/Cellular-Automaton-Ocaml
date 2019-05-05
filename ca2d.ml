(*
	Author: Kent Feng ,Jin Huai Xuan
	Implementation of Cellular Automatons in two dimensions.
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

(* Parses a string to a list of ints. *)
let list_of_string str =
  let rec ls_of_string str acc =
    if String.length str > 0 then
    (
    match str.[0] with
    | '0' -> ls_of_string (String.sub str 1 ((String.length str)-1)) (0::acc)
    | '1' -> ls_of_string (String.sub str 1 ((String.length str)-1)) (1::acc)
    | _ -> ls_of_string (String.sub str 1 ((String.length str)-1)) (0::acc)
    )
    else acc
  in
  ls_of_string str []

(* transforms list of strings to list of list of strings *)
let array_stuffer arr =
	let rec helper arr acc =
		match arr with
		| h::t -> (
			let arrOfString = List.rev(list_of_string h) in
			helper t (arrOfString::acc)

		)
		| [] -> (List.rev acc)
	in
	helper arr []

let rec print_int_array ls =
	match ls with
	| h::t -> print_int h; print_int_array t
	| [] -> print_endline ""


(* Draws an image. *)
let draw row col state img mode =
	match mode with 
	| "inverted" ->(
					match state with
					  	| 0 -> Image.write_rgb img col row 0 0 0
					  	| 1 -> Image.write_rgb img col row 255 255 255
					  	| _ -> ()

					)
	| "poop" -> (
					match state with
					  	| 0 -> Image.write_rgb img col row 255 255 255
					  	| 1 -> Image.write_rgb img col row 101 67 33
					  	| _ -> ()

	)
	| "rainbow" -> (
					match state with
					  	| 0 -> Image.write_rgb img col row 255 255 255
					  	| 1 -> Image.write_rgb img col row (Random.int 255) (Random.int 255) (Random.int 255)
					  	| _ -> ()
	)
	| _ -> (
					match state with
					  	| 0 -> Image.write_rgb img col row 255 255 255
					  	| 1 -> Image.write_rgb img col row 0 0 0
					  	| _ -> ()

	)


(* MAIN *)
let () =
   
	(* get command line arguments into a list*)
  	let argv_list_original = Array.to_list Sys.argv in
  	let cleaned_list = cut argv_list_original in

  	let list_len = List.length cleaned_list in
  	if list_len != 5
    	then Printf.printf "usage: ./2dca <numOfGenerations> <colorMode> <seedfile> <rule> <format>\n"
  	else
		(
			let format = List.nth cleaned_list 3 in
			let numGen = int_of_string(List.nth cleaned_list 0) in
			let seedFileName = List.nth cleaned_list 2 in
			let drawMode = List.nth cleaned_list 1 in 
			match format with
			| "sb" -> (
				let rule = Sb.parser (List.nth cleaned_list 4) in
				let s = int_of_string(List.nth rule 0) in
				let survive = Sb.digits_of_int s in
				let b = int_of_string(List.nth rule 1) in
				let born = Sb.digits_of_int b in
				

			  (* retrieve and draw generation 0 from txt.file *)
			  let lines = lines_of_file seedFileName in
			  let newLines = array_stuffer lines in
			  let firstRow = List.nth newLines 0 in
			  let colLen = List.length newLines in
			  let rowLen = List.length firstRow in 
			  let genZero = Sb.insert_into_map newLines in
			  
			  Printf.printf "Specifications\nSeed Filename: %s\nFormat: s/b\nRule: (s,b) (%i,%i)\nGenerations: %i\nDetected Size\nrow len: %i\ncol len: %i\n" (seedFileName) (s) (b) (numGen) (rowLen) (colLen);
			  

			  (* Build seed generation *)
				let img = Image.create_rgb ~alpha:false ~max_val:255 rowLen colLen in

			  Sb.drawGen genZero img 0 (drawMode) (draw);	

			  Sb.drawRemainder genZero img (numGen) colLen rowLen 1 survive born (drawMode) (draw);
				)
			| "marg" -> (
				let rule = Marg.parser (List.nth cleaned_list 4) in
      
				(* retrieve and draw generation 0 from txt.file *)
			  let lines = lines_of_file seedFileName in
			  let newLines = array_stuffer lines in
			  let firstRow = List.nth newLines 0 in
			  let colSz = List.length newLines in
			  let rowSz = List.length firstRow in 
			  let genZero = Marg.insert_into_map newLines in

			   Printf.printf "Specifications\nSeed Filename: %s\nFormat: marg\nGenerations: %i\nDetected Size\nrow len: %i\ncol len: %i\nRule: " seedFileName numGen rowSz colSz;

			   List.map (fun r -> Printf.printf "%s " r) rule;

			   print_endline "";


			  (* Build seed generation *)
			  let img = Image.create_rgb ~alpha:false ~max_val:255 rowSz colSz in

			  Marg.drawGen genZero img 0 (drawMode) (draw);
    
				Marg.drawRemainder genZero img (numGen) colSz rowSz 1 rule (drawMode) (draw);
				)
			| _ -> ()
	)
