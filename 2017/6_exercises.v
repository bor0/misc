Theorem identity_fn_applied_twice :
  forall (f : bool -> bool),
  (forall (x : bool), f x = x) ->
  forall (b : bool), f (f b) = b.
Proof.
  intros f.
  intros f_id.
  intros b.
  rewrite f_id.
  rewrite f_id.
  reflexivity.
Qed.

Theorem andb_eq_orb :
  forall (b c : bool),
  (andb b c = orb b c) ->
  b = c.
Proof.
  intros b c. induction b.
    - induction c.
      + simpl. intro t_t. exact t_t.
      + simpl. intro f_t. rewrite f_t. reflexivity.
    - simpl. intro f_c. exact f_c.
Admitted.

Module NatPlayground.
Inductive binary_nat : Type :=
| O : binary_nat
| E : binary_nat -> binary_nat
| D : binary_nat -> binary_nat.

Definition incr (n : binary_nat) : binary_nat :=
  match n with
  | O => E O
  | E n => D n
  | D (E n) => D (D n)
  | D n => D (E n)
  end.

Fixpoint bin_to_nat (n : binary_nat) : nat :=
  match n with
  | O => 0
  | E n => 1 + (bin_to_nat n)
  | D n => 2 + (bin_to_nat n)
  end.

Example test_bin_incr1 : bin_to_nat O = 0.
Proof.
simpl. reflexivity.
Qed.

Example test_bin_incr2 : bin_to_nat (incr O) = 1.
Proof.
simpl. reflexivity.
Qed.

Example test_bin_incr3 : bin_to_nat (incr (incr O)) = 2.
Proof.
simpl. reflexivity.
Qed.

Example test_bin_incr4 : bin_to_nat (incr (incr (incr O))) = 3.
Proof.
simpl. reflexivity.
Qed.

Example test_bin_incr5 : bin_to_nat (incr (incr (incr (incr O)))) = 4.
Proof.
simpl. reflexivity.
Qed.

End NatPlayground.