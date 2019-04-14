
(*removes the head element from a list*)
let cut x = 
  match x with
  | [] -> []
  | h::t -> t



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

(* Creates the next generation of cells.
  Note: starting with S/B = 1/2
  Survive if one neighbor, born if 2 neighbors. *)

let next ls =
  let rec nextgen ls x acc =
    match ls with
    | a::b::c::t -> (match a, b, c with
                    | 0, 0, 0 -> nextgen (b::c::t) b (x::acc)
                    | 0, 0, 1 -> nextgen (b::c::t) b (x::acc)
                    | 0, 1, 0 -> nextgen (b::c::t) 0 (x::acc)
                    | 0, 1, 1 -> nextgen (b::c::t) b (x::acc)
                    | 1, 0, 0 -> nextgen (b::c::t) b (x::acc)
                    | 1, 0, 1 -> nextgen (b::c::t) 1 (x::acc)
                    | 1, 1, 0 -> nextgen (b::c::t) b (x::acc)
                    | 1, 1, 1 -> nextgen (b::c::t) 0 (x::acc)
                    | _ -> nextgen (0::0::t) 0 (0::acc)
                    )
    | a::b::[] -> (match a, b with
                  | 0, 1 -> 0::acc
                  | 1, 0 -> b::acc
                  | 1, 1 -> b::acc
                  | _ -> 0::acc
                  )
    | a::[] -> 0::acc
    | [] -> acc
  in
  nextgen ls 0 []

(* main *)
let () =

  (* get command line arguments into a list*)
  let argv_list_original = Array.to_list Sys.argv in 
  let cleaned_list = cut argv_list_original in
  (* let numGen = 8 in *)

  let list_len = List.length cleaned_list in
  if list_len = 0 
    then Printf.printf "usage: ./ca numOfGenerations\n" 
  else 
    (* Printf.printf "%s\n" (List.nth cleaned_list 0); *)
    let numGen = int_of_string(List.nth cleaned_list 0) in
  


  let img = Image.create_rgb ~alpha:false ~max_val:255 50 50 in

  (* retrieve generation 0 from txt.file *)
  let ic = open_in "genzero.txt" in
  let genzero = List.rev(list_of_string(input_line ic)) in
  (* drawing onto the img *)
  let f x y =
    match y with
    | 0 -> ()
    | 1 -> Image.write_rgb img x 0 (Random.int 255) (Random.int 255) (Random.int 255)
    | _ -> ()
  in
  List.iteri f genzero;

  (* draw 8 generations after generation 0 *)
  let rec draw_gens n ls =
    if (n < 40) then let genk = List.rev(next ls) in
    let f x y =
      match y with
      | 0 -> ()
      | 1 -> Image.write_rgb img x n (Random.int 255) (Random.int 255) (Random.int 255)
      | _ -> ()
    in
    List.iteri f genk; draw_gens (n+1) genk
  in
  draw_gens 1 genzero;

  (* create the image *)
  ImageLib.writefile "output.png" img;

  close_in ic
