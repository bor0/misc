open System

type Proof<'a> = Proof of 'a

let fromProof x =
  match x with
  | (Proof a) -> a

type PropCalc<'a> =
  PropVar of 'a
  | Not of PropCalc<'a>
  | And of PropCalc<'a> * PropCalc<'a>
  | Or of PropCalc<'a> * PropCalc<'a>
  | Imp of PropCalc<'a> * PropCalc<'a>

let ruleJoin (x : Proof<PropCalc<'a>>) (y : Proof<PropCalc<'a>>) = Proof (And (fromProof x, fromProof y))

let ruleDeMorgan (x : Proof<PropCalc<'a>>) =
  match (fromProof x) with
  | And (Not x, Not y) -> Proof (Not (Or (x, y)))
  | Not (Or (x, y))    -> Proof (And (Not x, Not y))
  | x -> Proof x

let ruleFantasy (x : PropCalc<'a>) (y : Proof<PropCalc<'a>> -> Proof<PropCalc<'a>>)
  = Proof(Imp(x, fromProof(y (Proof(x)))))

type Vars = A | B | C

[<EntryPoint>]
let main argv =
  printf "%A\n" (ruleFantasy (Not (PropVar A)) (fun x -> ruleDeMorgan (ruleJoin x x)))
  0 // return an integer exit code
