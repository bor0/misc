Require Import Coq.Lists.List.
Require Import PeanoNat.

(*
 <bor0> to avoid XY problem, I want to actually prove that n < length l -> s = nth n (firstn n l ++ s :: nil) d
 <lyxia> [...] you can reason about it in independent steps
 <lyxia> first that    first n l   has length   n  , because n < length l
 <lyxia> and second that   s = nth (u ++ s :: v) d   if u has length l
 <bor0> found [first step] [...] `firstn_length_le`
*)

Lemma lemma_1 : forall {X:Type} (l : list X) (n : nat),
  n <= length l
  ->
  length (firstn n l) = n.
Proof.
exact firstn_length_le.
Qed.

Axiom lemma_2 : forall {X:Type} n l1 l2 (s:X) d,
  length l1 = n
  ->
  s = nth n (l1 ++ s :: l2) d.

Lemma thm_1 : forall {X:Type} (n : nat) (l1 l2 : list X) (s : X) (d : X),
  n <= length l1
  ->
  s = nth n (firstn n l1 ++ s :: l2) d.
Proof.
  intros x n l1 l2 s d n_lt_length_l.
(* Implicit: auto all subgoals
  apply lemma_2. apply thm2_l2; auto.
*)
  apply lemma_2. exact (lemma_1 l1 n n_lt_length_l).
(* For the more explicit version
  assert (th2 := lemma_1 l1 n_lt_length_l).
  assert (th1 := lemma_2 n (firstn n l1) l2 s d th2).
  exact th1.
*)
Qed.

(*
 <bor0> [...] how did you come up with these 2 indepepdent steps [...]
 <lyxia> well you are trying to prove s = nth n (firstn n l ++ s :: nil) d
 <lyxia> that involves at least nth, firstn, ++
 <lyxia> and, a reasonable guess is that you won't find a lemma about all three in the standard library
 <lyxia> so you try to remove one
 <lyxia> s = nth n (_ ++ s :: nil)
 <lyxia> here I removed firstn
 <lyxia> and here you can tell that something nice is going on because there is a simple condition under which that equation is true
 <lyxia> which is that the underscore contains a list of length n
 <lyxia> exactly n
*)
