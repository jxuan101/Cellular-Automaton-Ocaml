(*
	Author: Kent Feng ,Jin Huai Xuan
	Implementation of Cellular Automatons in two dimensions.
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


(* MAIN *)
let () =

	(* get command line arguments into a list*)
  	let argv_list_original = Array.to_list Sys.argv in
  	let cleaned_list = cut argv_list_original in

  	let list_len = List.length cleaned_list in
  	if list_len != 3
    	then Printf.printf "usage: ./two_ca <numOfGenerations> <format> <rule>\n"
  	else
		(
			let format = List.nth cleaned_list 1 in
			let numGen = int_of_string(List.nth cleaned_list 0) in
			match format with
			| "sb" -> (
				let rule = Sb.parser (List.nth cleaned_list 2) in
				let s = int_of_string(List.nth rule 0) in
				let survive = Sb.digits_of_int s in
				let b = int_of_string(List.nth rule 1) in
				let born = Sb.digits_of_int b in

				let rowSz = 50 in
				let colSz = 50 in

				(* Build seed generation *)
				let img = Image.create_rgb ~alpha:false ~max_val:255 rowSz colSz in

			  (* retrieve and draw generation 0 from txt.file *)
			  let lines = lines_of_file "2d_seed.txt" in
			  let newLines = array_stuffer lines in
			  let genZero = Sb.insert_into_map newLines in
			  Sb.drawGen genZero img 0;

			  Sb.drawRemainder genZero img (numGen-1) rowSz colSz 1 survive born;
				)
			| "marg" -> (
				let rule = Marg.parser (List.nth cleaned_list 2) in

				let rowSz = 50 in
				let colSz = 50 in

				(* Build seed generation *)
				let img = Image.create_rgb ~alpha:false ~max_val:255 rowSz colSz in

				(* retrieve and draw generation 0 from txt.file *)
			  let lines = lines_of_file "2d_seed.txt" in
			  let newLines = array_stuffer lines in
			  let genZero = Marg.insert_into_map newLines in
			  Marg.drawGen genZero img 0;

				Marg.drawRemainder genZero img (numGen-1) rowSz colSz 1 rule;
				)
	)
