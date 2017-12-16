(* We can have nat : Type, a : nat, but not b : a. Why? *)

(* Theorems are types and proofs are constructs. *)
Theorem one : exists n, n = 1.
Proof.
  intros n.
  exists 1.
  reflexivity.
Qed.

(* b is not a Type. There is no any inference rule in CoC that allows this.
See rules are limited to K where K = Prop or K = Type *)
