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

Theorem mult_0_r : forall n:nat, n * 0 = 0.
Proof.
  intros n.
  induction n.
  - (* base *) simpl. reflexivity.
  - (* i.h. *) simpl. exact IHn.
  Show Proof.
Qed.

Definition proof_mult_0_r := fun n : nat =>
 nat_ind (fun n0 : nat => n0 * 0 = 0) eq_refl (fun (n0 : nat) (IHn : n0 * 0 = 0) => IHn) n.

Check nat.
Check nat_rect.
Check nat_ind.
Check nat_rec.
Check eq_refl.

(*
P = (fun n0 : nat => n0 * 0 = 0)
base case: P 0 = eq_refl
hypothesis: (forall n : nat, P n -> P (S n)) = (fun (n0 : nat) (IHn : n0 * 0 = 0) => IHn)
*)
Check nat_ind (fun n0 : nat => n0 * 0 = 0).
Check nat_ind (fun n0 : nat => n0 * 0 = 0) eq_refl.
Check nat_ind (fun n0 : nat => n0 * 0 = 0) eq_refl (fun (n0 : nat) (IHn : n0 * 0 = 0) => IHn).

(* IHn has an interesting type! *)

Check 2 * 0 = 0. (* Type *)
(* It's a Prop, but remember that (a : b : c) means (a : b) and (b : c) *)
(* So f we have b = [n * 0 = 0], c = [Prop], then it makes sense *)
Variable a : 2 * 0 = 0.
Check 2 * 0.
Check a.

(* Variable a' : 2. *) (* Error: term a' has type nat, should be Set/Prop/Type *)
Variable someType : Type.
Variable a' : someType.

(* nat_ind is automatically generated for every Inductive *)
Theorem mult_0_r_2 : forall n:nat, n * 0 = 0. refine proof_mult_0_r.