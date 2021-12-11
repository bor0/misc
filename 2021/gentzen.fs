open System

type Proof<'a> = Proof of 'a

let fromProof x =
  match x with
  | Proof a -> a

type PropCalc<'a> =
  PropVar of 'a
  | Not of PropCalc<'a>
  | And of PropCalc<'a> * PropCalc<'a>
  | Or of PropCalc<'a> * PropCalc<'a>
  | Imp of PropCalc<'a> * PropCalc<'a>

let ruleJoin (x : Proof<PropCalc<'a>>) (y : Proof<PropCalc<'a>>)
  = Proof (And (fromProof x, fromProof y))

let ruleDoubleTildeIntro (x : Proof<PropCalc<'a>>) =
  match (fromProof x) with
  | x -> Proof (Not (Not x))

let ruleDoubleTildeElim (x : Proof<PropCalc<'a>>) =
  match (fromProof x) with
  | Not (Not x) -> Proof x
  | _ -> x

let ruleFantasy (x : PropCalc<'a>) (y : Proof<PropCalc<'a>> -> Proof<PropCalc<'a>>)
  = Proof(Imp(x, fromProof(y (Proof(x)))))

let ruleDetachment (x : Proof<PropCalc<'a>>) (y : Proof<PropCalc<'a>>) =
  match (fromProof y) with
  | Imp (x', y) -> if (fromProof x) = x' then Proof y else x
  | _ -> x

let ruleContra (x : Proof<PropCalc<'a>>) =
  match (fromProof x) with
  | Imp (Not y, Not x) -> Proof (Imp (x, y))
  | Imp (x, y)         -> Proof (Imp (Not x, Not y))
  | _ -> x

let ruleDeMorgan (x : Proof<PropCalc<'a>>) =
  match (fromProof x) with
  | And (Not x, Not y) -> Proof (Not (Or (x, y)))
  | Not (Or (x, y))    -> Proof (And (Not x, Not y))
  | x -> Proof x

let ruleSwitcheroo (x : Proof<PropCalc<'a>>) =
  match (fromProof x) with
  | Or (x, y)    -> Proof (Imp (Not x, y))
  | Imp (Not x, y) -> Proof (Or (x, y))
  | x -> Proof x

type Vars = A | B | C

[<EntryPoint>]
let main argv =
  printf "%A\n" (ruleFantasy (Not (PropVar A)) (fun x -> ruleDeMorgan (ruleJoin x x)))
  printf "%A\n" (ruleFantasy (Or (PropVar A, PropVar B)) ruleSwitcheroo)
  0 // return an integer exit code
