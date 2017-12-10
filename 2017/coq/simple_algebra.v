Add LoadPath "/Users/boro/Downloads/cpdt/src/" as Cpdt.

Require Import Bool Arith List Cpdt.CpdtTactics.
Set Implicit Arguments.
Set Asymmetric Patterns.

Inductive binop : Set := Plus | Times.

Inductive exp : Set :=
 | Const: nat -> exp
 | Binop: binop -> exp -> exp -> exp.

Compute Const 5.
Compute Binop Plus (Const 3) (Const 5).

(* This is sugary *)
Definition binopDenote (b : binop) : nat -> nat -> nat :=
  match b with
  | Plus => plus
  | Times => mult
  end.

(* What we actually have is *)
Definition binopDenote' : binop -> nat -> nat -> nat :=
  fun (b : binop) => match b with
  | Plus  => plus
  | Times => mult
  end.

Check binopDenote Plus.

Fixpoint calculateExp (e : exp ) : nat :=
  match e with
  | Const a => a
  | Binop op a b => (binopDenote op) (calculateExp a) (calculateExp b)
  end.

Compute calculateExp (Binop Plus (Const 3) (Const 5)).

Compute binop.