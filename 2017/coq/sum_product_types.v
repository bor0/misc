Inductive MyProp : Type.
Inductive MyProp2 : Type.

Inductive MyPair (a b : Type) := conj : a -> b -> MyPair a b.
Inductive MySum  (a b : Type) :=
| sumleft : a -> MySum a b
| sumright : b -> MySum a b.

Definition MyPair_left (a b : Type) (pair : MyPair a b) :=
  match pair with
  | conj _ _ a _ => a
  end.

Definition MyPair_right (a b : Type) (pair : MyPair a b) :=
  match pair with
  | conj _ _ _ b => b
  end.

(*
Definition MySum_elim_left (a b : Type) (sum : MySum a b ) :=
  match sum with
  | sumleft _ _ a => a
  end.
*)

(* A /\ B -> A *)
Theorem th1 : forall a b : Type, MyPair a b -> a.
Proof.
  intros a b.
  intros mp_ab.
  exact (MyPair_left a b mp_ab).
Qed.

(* A -> A \/ B *)
Theorem th2 : forall a b : Type, a -> MySum a b.
Proof.
  intros a b.
  intros ms_ab.
  exact (sumleft a b ms_ab : (MySum a b)).
Qed.

(* B -> A \/ B *)
Theorem th3 : forall a b : Type, b -> MySum a b.
Proof.
  intros a b.
  intros ms_ab.
  exact (sumright a b ms_ab : (MySum a b)).
Qed.