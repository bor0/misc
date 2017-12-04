(*
 <cq1> This "destruct" IS doing case analysis, but across all zero cases that are the constructors of False.
 <cq1> Here's how you should think of what happened:
 <cq1> Recall that ~p is simply p -> False.
 <cq1> destruct makes one case for the current goal for each constructor of False.
 <cq1> There are no constructors of False, so it makes zero cases. This effectively discharges the current goal of "q".
 <cq1> HOWEVER, destruct used the assumption p in order to build that term of type False that it did case analysis on. So it emits a goal corresponding to that obligation.
 <cq1> So it looks like your goal changed from "q" to "p".
 <cq1> There is no general way of doing case analysis on a proposition. Had your hypothesis instead been "p -> q" or something like that then destruct would give you "Error: Not an inductive product."
 <bor0> ow, I see. we proved the current goal q to be False, and are left with proving p (by not_p)?
 <bor0> is this correct? destruct not_p. (* discharge current goal q by p -> False, p .:. False *)
*)

Theorem neg_elim_1 : forall p q : Prop, not p -> (p -> q).
Proof.
  intros p q.
  intros not_p.
  intros proof_p.
  exfalso. exact (not_p proof_p).
Qed.

Theorem neg_elim_2 : forall p q : Prop, not p -> (p -> q).
Proof.
  intros p q.
  intros not_p.
  intros proof_p.
  unfold not in not_p.
  apply not_p in proof_p.
  contradiction.
Qed.

Theorem neg_elim_3 : forall p q : Prop, not p -> (p -> q).
Proof.
  intros p q.
  intros not_p.
  intros proof_p.
  destruct not_p.
  exact proof_p.
Qed.
