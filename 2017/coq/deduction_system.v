(* https://en.wikipedia.org/wiki/Propositional_calculus#Example_2._Natural_deduction_system *)

Theorem modus_ponens : forall p q : Prop, p -> (p -> q) -> q.
Proof.
  intros p q.
  intros proof_p.
  intros p_imp_q.
  exact (p_imp_q proof_p).
Qed.

Theorem neg_intro : forall p q : Prop, (p -> q) /\ (p -> not q) -> not p.
Proof.
  intros p q.
  intros p_imp_q_and_p_imp_not_q.
  destruct p_imp_q_and_p_imp_not_q as [p_imp_q p_imp_not_q].
  unfold not. (* convert ~ p to p -> False *)
  intro assume_P.
  apply p_imp_not_q. (* ??? *)
  - (* p *) exact assume_P.
  - (* q *) exact (p_imp_q assume_P).
Qed.

Theorem neg_elim : forall p q : Prop, not p -> (p -> q).
Proof.
  intros p q.
  intros not_p.
  intros proof_p.
  (* We either have not_p or proof_p. Consider the case of not_p. *)
  destruct not_p. (* discharge current goal q by p -> False, p .:. False *)
  exact proof_p.
Qed.

Theorem double_neg_intro : forall p : Prop, p -> not (not p).
Proof.
  intros p.
  intros proof_p.
  unfold not. (* convert ~a to a -> False *)
  intros p_imp_false.
  (* exact (modus_ponens p False proof_p p_imp_false). *)
  (* or *)
  exact (p_imp_false proof_p).
Qed.

(*
If we had bool instead of Prop, we could have used induction here.
But, Prop and bool are two different beasts.

We cannot prove this in an intuitionnistic settings without excluded_middle axiom.
The difference between Prop and bool is having to do with provability.
bool is either true or false, Prop is either provable or not.

Prop is a universe of propositions: when you have `P : Prop`,
you don't know anything about the provability of P, unless you can build a term `p : P`.

So in general you cannot "compute" a proposition.
The ability to decide for any proposition if it's true or false is exactly the excluded middle

`P \/ ~P` is a valid statement, but you cannot prove it in general.
Because not every statement is decidable. E.g. the halting problem, or the continuum hypothesis.
*)
(* We cannot prove some theorems in "vanilla" Coq, because it is based on intuitionistic logic *)
Axiom excluded_middle : forall p : Prop, p \/ ~ p.

Theorem double_neg_elim : forall p : Prop, not (not p) -> p.
Proof.
  intros p.
  intros not_not_p.
  destruct (excluded_middle p).
  - (* case p  *) exact H.
  - (* case ~p *) apply not_not_p in H. contradiction.
Qed.

Theorem and_intro : forall p q : Prop, p -> q -> p /\ q.
Proof.
  intros p q.
  intros proof_p proof_q.
  split.
  exact proof_p.
  exact proof_q.
Qed.

Theorem and_elim_l : forall p q : Prop, p /\ q -> p.
Proof.
  intros p q.
  intros p_and_q.
  destruct p_and_q as [proof_p proof_q].
  exact proof_p.
Qed.

Theorem and_elim_r : forall p q : Prop, p /\ q -> q.
Proof.
  intros p q.
  intros p_and_q.
  destruct p_and_q as [proof_p proof_q].
  exact proof_q.
Qed.

Theorem or_intro_l : forall p q : Prop, p -> p \/ q.
Proof.
  intros p q.
  intros proof_p.
  exact (or_introl proof_p : p \/ q).
Qed.

Theorem or_intro_r : forall p q : Prop, q -> p \/ q.
Proof.
  intros p q.
  intros proof_p.
  exact (or_intror proof_p : p \/ q).
Qed.

Theorem or_elim : forall p q r : Prop, p \/ q -> (p -> r) -> (q -> r) -> r.
Proof.
  intros p q r.
  intros p_or_q.
  intros p_imp_r q_imp_r.
  case p_or_q.
  - (* p *) intros proof_p. exact (p_imp_r proof_p).
  - (* q *) intros proof_q. exact (q_imp_r proof_q).
Qed.

Theorem bicond_intro : forall p q : Prop, (p -> q) -> (q -> p) -> (p <-> q).
Proof.
  intros p q.
  intros p_imp_q q_imp_p.
  unfold iff.
  split.
  exact p_imp_q.
  exact q_imp_p.
Qed.

Theorem bicond_elim_l : forall p q : Prop, (p <-> q) -> (p -> q).
Proof.
  intros p q.
  intros p_iff_q.
  intros proof_p.
  destruct p_iff_q as [p_imp_q q_imp_p].
  exact (p_imp_q proof_p).
Qed.

Theorem bicond_elim_r : forall p q : Prop, (p <-> q) -> (q -> p).
Proof.
  intros p q.
  intros p_iff_q.
  intros proof_q.
  destruct p_iff_q as [p_imp_q q_imp_p].
  exact (q_imp_p proof_q).
Qed.
