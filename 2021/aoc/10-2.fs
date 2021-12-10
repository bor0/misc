open System

let explode s = List.init (String.length s) (fun index -> s.[index])

let get_points x =
  match x with
  | ')' -> 1I
  | ']' -> 2I
  | '}' -> 3I
  | '>' -> 4I
  | _ -> 0I

let closing_for x =
  match x with
  | '(' -> ')'
  | '[' -> ']'
  | '{' -> '}'
  | '<' -> '>'
  | x -> x

let rec get_completion_symbols str acc =
  match str with
    | [] -> acc // Only return incomplete
    | x::xs ->
      // Append the corresponding close parenthesis
      if List.exists (fun elem -> elem = x) [ '('; '{'; '['; '<' ]
      then get_completion_symbols xs (closing_for x :: acc)

      // Parenthesis mismatch, this doesn't count as it's corrupted
      else if closing_for (List.head acc) <> x
      then [] // acc

      // Parenthesis match, remove from acc and keep recursing
      else get_completion_symbols xs (List.tail acc)

let calculate_points str =
  let input = Seq.toList str
  let symbols = get_completion_symbols input []
  // 0I is (bigint 0)
  List.fold (fun acc elem -> get_points elem + 5I * acc) 0I symbols

[<EntryPoint>]
let main argv =
  let lines = System.IO.File.ReadLines("input")
  let list = Seq.toList lines
  let list = List.map (fun x -> calculate_points x) list
  let list = List.filter (fun x -> x <> 0I) list
  let list = List.sort list
  let middle = Convert.ToInt32 (ceil (float (List.length list)) / 2.0)
  printfn "%A" list.[middle]
  0
