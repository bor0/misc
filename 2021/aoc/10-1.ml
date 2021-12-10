open Printf

let explode s = List.init (String.length s) (String.get s)

let get_char_points x = match x with
  | ')' -> 3
  | ']' -> 57
  | '}' -> 1197
  | '>' -> 25137
  | _ -> 0

let closing_for x = match x with
  | '(' -> ')'
  | '[' -> ']'
  | '{' -> '}'
  | '<' -> '>'
  | x -> x

let rec get_syntax_points str acc =
  match str with
    | [] -> 0
    | x::xs ->
      if List.mem x [ '('; '{'; '['; '<' ]
      then get_syntax_points xs (x :: acc)
      else if closing_for (List.hd acc) != x
      then get_char_points x
      else get_syntax_points xs (List.tl acc)

let calculate_points str = get_syntax_points (explode str) []

let rec handle_list l acc =
  match l with
    | [] -> acc
    | head::body -> handle_list body (calculate_points head + acc)

let read_file filename = 
  let lines = ref [] in
    let chan = open_in filename in
      try
        while true; do
          lines := input_line chan :: !lines
        done; !lines
      with End_of_file ->
        close_in chan;
        List.rev !lines

exception Invalid_input;;
printf "%d\n" (handle_list (read_file "input") 0);;
