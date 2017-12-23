(* Nat-specific *)
Inductive and : Prop :=
  conj : nat -> nat -> and.

Theorem and_intro : nat -> nat -> and.
Proof.
  intros x1 x2.
  exact (conj x1 x2).
Qed.

Definition and'_intro := fun (proof_a : nat) (proof_b : nat) => conj proof_a proof_b.

(* Polymorphic version *)
Inductive and' (A B : Prop) : Prop :=
  conj' : A -> B -> and' A B.

Print and_comm.

Theorem and'_intro : forall (A B : Prop), A -> B -> @and' A B.
Proof.
  intros a b.
  intros proof_a proof_b.
  exact (conj' a b proof_a proof_b).
Qed.


(*Definition and'_intro' := fun A B : Prop => conj' A B.*)
Definition and'_intro' := fun (A B : Prop) (proof_a : A) (proof_b : B) => conj' A B a b.

Print and'_intro.
Print and'_intro'.

Check and'_intro.
Check and'_intro'.