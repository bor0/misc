Theorem my_theorem : (forall a b : Prop, a /\ b -> b /\ a).
Proof.
  intros a b.
  intros a_and_b.
  destruct a_and_b as [proof_a proof_b].
  split.
  exact proof_b.
  exact proof_a.
Qed.

Theorem my_theorem_2 : (forall a b : Prop, a \/ b -> b \/ a).
Proof.
  intros a b.
  intros a_or_b.
  elim a_or_b.
    intros proof_a.
    pose (proof_b_or_a := or_intror proof_a : b \/ a).
    exact proof_b_or_a.

    intros proof_b.
    left.
    exact proof_b.
Qed.

(* If we try to use Definition, we get fact is not defined *)
(* Coq provides a special syntax Fixpoint for recursion *)
Fixpoint even (n : nat) : bool :=
  match n with
    | S (S n) => even n
    | S n => false
    | 0 => true
end.

Theorem even_4 : forall a : nat, a = 4 -> even a = true.
Proof.
  intros a.
  intros a_eq_4.
  rewrite a_eq_4.
  simpl.
  reflexivity.
Qed.

Inductive test: Set := | member: test.
Theorem cardinality_set : (forall i : test, member = i).
Proof.
  intros i.
  induction i.
  reflexivity.
Qed.

Axiom max_a_0 : forall a : nat, (max a 0) = a.
Axiom max_0_a : forall a : nat, (max 0 a) = a.

Theorem testtest : forall a b c : nat, (max (max a b) c) = (max a (max b c)).
Proof.
  intros a.
  induction a.
    (* Base case *)
      destruct b.
simpl.
reflexivity.
destruct c.
simpl. reflexivity.

simpl. reflexivity.
simpl. destruct b.
destruct c. simpl. reflexivity.
simpl.
reflexivity.
simpl.
destruct c.
reflexivity.
rewrite IHa.
reflexivity.
Qed.

Theorem testtest2 : forall a b : nat, (max a b) = (max b a).
Proof.
  intros a.
  induction a.
  intros b.

  simpl. rewrite max_a_0. reflexivity.
  simpl. destruct b. rewrite max_0_a. reflexivity.
  rewrite IHa.
  simpl.
  reflexivity.
Qed.