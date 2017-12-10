(*
Informally, a dependent type is something like a type that says, "a string 5 characters long"

With dependent types we can add additional constraints to types.
The idea is that given a type, or in this case a value, you get another type.
You can have constraints that depend on *values*, not just types.

E.g.: head : forall a (s : string a), (length s > 0) -> a
You can't write that function type without dependent types

In Coq, types can be entire programs unto themselves, where the result of the computation is a type.

Formally, suppose we're given a type A : U in universe of types. Let B : A -> U.
That is, B assigns to every a : A, a type B(a) : U.

In the example above, B s = length s > 0, so B : string a -> Prop.
*)
Module Example_1.
Definition B n := n = 0.
Check B.

(*
Note that B is a nat -> Prop. It's a function that provides
a Proposition based on the value of nat
*)

Theorem example : forall n : nat, B n -> n = 0.
Proof.
  intros n n_eq_0.
  exact n_eq_0.
Qed.

(*
We should understand that dependent types are everywhere.
To be precise ? -> Prop.
*)
End Example_1.

Module Example_2.
(*
For this case, let's see where dependent types can cause issues.
*)

Inductive vector (A : Type) : nat -> Type :=
| nilvec: vector A 0.

Check nilvec.
Check vector.
(* Note that vector is a parametrized (dependent) type *)

Variables n m : nat.
Variable xs : vector nat n.
Variable ys : vector nat m.

(* Type error: *)
(*
Check xs = ys. (* ill typed program, Coq typechecker rejects this *)
*)

(* Now our theorem is dependently typed, concerning vectors that are themselved dependently typed *)
(* Type error: *)
(*
Theorem example : n = m -> xs = ys.
*)
(*
Even knowing m = n isn't good enough, since the type checker will still fail.
One way to fix it is to have:
*)
(*
Axiom example' : m = n -> vector nat m = vector nat n.
*)
(*
But axioms should generally be avoided.
*)

(* However, we can still prove this *)
Theorem example : forall m n : nat, forall xs ys, xs = vector nat m /\ ys = vector nat n /\ m = n -> xs = ys.
Proof.
  intros m n.
  intros xs ys.
  intros m_eq_n.
  destruct m_eq_n as [H0 [H1 H2]].
  rewrite H2 in H0.
  rewrite H0. rewrite H1.
  reflexivity.
Qed.
(* The reason for above is *)
Check vector nat 3.
(* Because xs : Prop and ys : Prop *)

End Example_2.