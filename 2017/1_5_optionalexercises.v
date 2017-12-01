Theorem andb_true_elim2 : forall b c : bool,
  andb b c = true -> c = true.
Proof.
  intros b c. induction b.
  - (* base *)simpl. intros c_true. exact c_true.
  - (* ih *) induction c.
    + (* base *) simpl. intros f_t. reflexivity.
    + (* ih *) simpl. intros f_t. exact f_t.
Qed.

Fixpoint beq_nat (n m : nat) : bool :=
  match n with
  | 0 => match m with
         | 0 => true
         | S m' => false
         end
  | S n' => match m with
            | 0 => false
            | S m' => beq_nat n' m'
            end
  end.


Theorem zero_nbeq_plus_1 : forall n : nat,
  beq_nat 0 (n + 1) = false.
Proof.
  intros n.
  induction n.
  - (* base *) simpl. reflexivity.
  - (* ih *) simpl. reflexivity.
Qed.

Compute pred 1.
Compute pred 0.

(*
Fixpoint fact (n : nat) : nat :=
  match n with
  | 0 => 1
  | m => fact (pred n)
  end.

vs
*)
Fixpoint fact (n : nat) : nat :=
  match n with
  | 0 => 1
  | S m => fact m
  end.
