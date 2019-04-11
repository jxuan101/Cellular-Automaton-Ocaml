(* int pair struct*)
module IntPair = struct 
	type t = int * int
	let compare = Pervasives.compare
end

module M = Map.Make(IntPair) in

let () =
	let m =
		M.empty
		|> M.add(10,15) "Bob"
		|> M.add(3,7) "Alice"
	in
	M.iter (fun x,y) v ->
		Printf.printf "(%i,%i) -> %s" x y v