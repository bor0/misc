(*
 <Chobbes> bor0: if your goal is "X" and you have a theeorem "H : X" you can apply H to solve the goal.
 <bor0> isn't that just exact H?
 <Chobbes> If your theorem is H : A -> X then applying will leave A as the goal.
 <benzrf> yes, apply generalizes exact
 <benzrf> in some sense it's like exact is apply for a 0-arg function :-)
 <bor0> "exact is apply for a 0-arg function" that's really interesting!
*)

Require Import Arith.

(*
 <benzrf> consider this theorem: [Nat.lt_le_incl: forall n m : nat, n < m -> n <= m]
 <benzrf> if your current goal is something like [p <= q], you can do [apply Nat.lt_le_incl]
 <benzrf> this generate an incomplete proof of [p <= q] of the form [Nat.lt_le_incl p q _]
 <benzrf> then the missing proof of [p < q] will be a new obligation
 <benzrf> (the p and q appear there because apply infers that it needs to do that)
*)

Check Nat.lt_le_incl.


Theorem asdf : forall n m : nat, n < m -> n <= m.
Proof.
  intros n m.
  intro n_lt_m.
  apply Nat.lt_le_incl.
Qed

(*
 <benzrf> [exact (P_imp_Q proof_P)] is precisely [apply P_imp_Q; exact proof_P]
 <benzrf> [apply f] is basically like [exact (f _)] and then your goal is to prove the _
*)
Theorem asdf2: forall P Q R : Prop, (P -> R -> Q) -> P /\ R -> Q.
Proof.
  intros P Q R.
  intros P_imp_R_imp_Q.
  intros P_and_R.
  destruct P_and_R as [proof_P proof_R].
  apply P_imp_R_imp_Q.
  exact proof_P. exact proof_R.
Qed.

(*
 <bor0> ok I just used my first apply. I assume it gets better and better the longer the implication is, because exact will be more complex to be used?
 <bor0> ah, neat. two subgoals for P_imp_Q_imp_R for (P -> R -> Q) -> P /\ R -> Q
 <bor0> instead of (exact P_imp_Q_imp_R proof_R proof_P) which can get trickier
*)

Theorem asdf3: forall P Q R : Prop, (P -> R -> Q) -> P /\ R -> Q.
Proof.
  intros P Q R.
  intros P_imp_R_imp_Q.
  intros P_and_R.
  destruct P_and_R as [proof_P proof_R].
  exact (P_imp_R_imp_Q proof_P proof_R).
Qed.
