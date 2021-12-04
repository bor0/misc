(*
rm 4-1.hs
echo "import System.IO" > 4-1.hs
echo "import Data.List.Split (splitOn, chunksOf)" >> 4-1.hs
mv 4-1.v tmp.v # `coqc` doesn't play well with dashes in filenames
coqc tmp.v >> 4-1.hs
mv tmp.v 4-1.v
cat 4-1.after.hs >> 4-1.hs
sed -i '' 's/module Main where//g' 4-1.hs
stack repl 4-1.hs
*)
Require Import Coq.Lists.List.
Import ListNotations.

Require Import Nat.

Require Extraction.
Extraction Language Haskell.

Fixpoint forallb {X : Type} (test : X -> bool) (l : list X) : bool :=
  match l with
  | [] => true
  | x :: l' => andb (test x) (forallb test l')
  end.

Fixpoint existsb {X : Type} (test : X -> bool) (l : list X) : bool
:= match l with
  | []      => false
  | x :: xs => if (test x) then true else existsb test xs
end.

Inductive bingo : Type :=
  | marked (x : nat)
  | unmarked (x : nat).

Definition is_marked (b : bingo) : bool :=
  match b with
  | marked _ => true
  | _ => false
  end.

Definition extract (b : bingo) : nat :=
  match b with
  | marked n => n
  | unmarked n => n
  end.

Definition single_mark (b : bingo) (n : nat) : bingo :=
  match b with
  | unmarked n' => if eqb n n' then marked n else unmarked n'
  | n => n
  end.

Fixpoint get_table_rows (t : list bingo) : list (list bingo) :=
  match t with
  | (a::b::c::d::e::xs) => [a;b;c;d;e] :: get_table_rows xs
  | _ => []
  end.

Definition get_table_cols (t : list bingo) : list (list bingo) :=
  let chunks := get_table_rows t in
  map (fun n => map (fun t => nth n t (marked 0)) chunks) [0;1;2;3;4]. (* TODO: safer way instead of defaulting to 0 *)

Definition mark_number (n : nat) (bs : list bingo) : list bingo := map (fun x => single_mark x n) bs.

Definition table_any_rowcol_marked (t : list bingo) : bool :=
  (existsb (forallb is_marked) (get_table_cols t))
  || existsb (forallb is_marked) (get_table_rows t).

Fixpoint calculate (tables : list (list bingo)) (numbers : list nat) : nat :=
  match numbers with
  | nil => 0 (* TODO: safer way instead of defaulting to 0 *)
  | x :: xs =>
    let new_tables := map (mark_number x) tables in
    if existsb table_any_rowcol_marked new_tables
    then let found_table := hd [marked 0] (filter table_any_rowcol_marked new_tables) in (* TODO: safer way instead of defaulting to 0 *)
    x * list_sum (map extract (filter (fun k => negb (is_marked k)) found_table))
    else calculate new_tables xs
  end.

Fixpoint list_sum (l : list nat) : nat :=
  match l with
  | nil     => 0
  | x :: l' => x + list_sum l'
  end.

Recursive Extraction calculate.
