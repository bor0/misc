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

Theorem and'_intro2 : forall (A B : Prop), A -> B -> @and' A B.
Proof.
  intros a b.
  intros proof_a proof_b.
  exact (conj' a b proof_a proof_b).
Qed.


(*Definition and'_intro' := fun A B : Prop => conj' A B.*)
Definition and'_intro' := fun (A B : Prop) (proof_a : A) (proof_b : B) => conj' A B proof_a proof_b.

Print and'_intro.
Print and'_intro'.

Check and'_intro.
Check and'_intro'.

Theorem wat : forall (n m : nat), n = m -> n = m.
Proof.
  intros n m eq1.
  exact eq1.
  Show Proof.
Qed.

Definition wat' : forall (n m : nat), n = m -> n = m :=
fun (n m : nat) =>
  fun (H : n = m) => H.