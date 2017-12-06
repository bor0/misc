Theorem id : forall A : Prop, A -> A.
Proof.
  intros a.
  intros a_imp_a.
  exact a_imp_a.
  Show Proof.
Qed.

Definition proof_id2 := fun (a : Prop) (a_imp_a : a) => a_imp_a.
Check proof_id2.
Theorem id2 : forall A : Prop, A -> A. refine proof_id2.

Theorem modus_ponens : forall A B : Prop, A -> (A -> B) -> B.
Proof.
  intros a b.
  intros proof_a.
  intros a_imp_b.
  exact (a_imp_b proof_a).
  Show Proof.
Qed.

Definition proof_modus_ponens := fun (a b : Prop) (proof_a : a) (a_imp_b : a -> b) => a_imp_b proof_a.
Check proof_modus_ponens.
Theorem modus_ponens2 : forall A B : Prop, A -> (A -> B) -> B. refine proof_modus_ponens.
