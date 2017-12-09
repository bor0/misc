Require Import Arith.
Require Import Omega.

Check Nat.succ.

Lemma ez_lemma1 : forall n : nat, S n = n + 1.
Proof.
  intros n.
  omega.
(*
  induction n.
  - (* base *) simpl. reflexivity.
  - (* i.h. *) simpl. rewrite <- IHn. reflexivity.
*)
Qed.

Lemma ez_lemma2 : forall n : nat, S (2 * n + 1) = 2 * (n + 1).
  intros n.
  omega.
(*
  induction n.
  - (* base *) simpl. reflexivity.
  - (* i.h. *) omega.
*)
Qed.

Theorem even_or_odd : forall n : nat, exists k : nat, n = 2 * k \/ n = 2 * k + 1.
Proof.
  intros n.
  induction n.
  - (* base *)
    exists 0. left. simpl. reflexivity.
  - (* i.h. *)
    destruct IHn as [k H]. (* the goal before this point is exists k, P(k). set k = k, H = P(k) *)
    destruct H.            (* we have two cases from the hypothesis (boolean OR) *)
    + (* left, 2k    *)
      exists k. right. rewrite <- H. exact (ez_lemma1 n).
    + (* right, 2k+1 *)
      exists (k + 1). left. rewrite -> H. exact (ez_lemma2 k).
Qed.