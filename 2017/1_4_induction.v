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

Theorem plus_1_neq_0_firsttry : forall n : nat,
  beq_nat (n + 1) 0 = false.
Proof.
  intros n.
  induction n.
  - (* Base case *) simpl. reflexivity.
  - (* IH *) simpl. reflexivity.
Qed.

Theorem negb_involutive : forall b : bool,
  negb (negb b) = b.
Proof.
  intros b. induction b.
  - reflexivity.
  - reflexivity.
Qed.

Theorem andb_commutative : forall b c, andb b c = andb c b.
Proof.
  intros b c. induction b.
  - induction c. reflexivity. reflexivity.
  - induction c. reflexivity. reflexivity.
Qed.