Inductive woot (a : Type) : Type :=
  | Prazno : woot a
  | Samo : a -> woot a.

Inductive optiona (A : Type) : Type :=
    Somee : A -> optiona A | Nonee : optiona A.

Print option.
Check Some 3.
Check (Samo nat).
Check woot nat.
Check option nat.

Inductive type : Set := Nat | Bool.

Inductive tbinop : type -> type -> type -> Set :=
| TPlus : tbinop Nat Nat Nat
| TTimes : tbinop Nat Nat Nat
| TEq : forall t, tbinop t t Bool
| TLt : tbinop Nat Nat Bool.

Check TPlus.
Check TEq Nat.

Definition wat := (fun x : True : Prop => x).
Definition wat2 := (fun x : True : Prop => False).
Compute (wat I).
Compute (wat2 I).

Theorem a : False -> True.
Proof.
  intros a. exact I.
Qed.

Inductive myunit : Set := just_tt.

(* myunit is really a singleton type *)
Theorem myunit_singleton : forall t : myunit, t = just_tt.
Proof.
  intros t.
  induction t. (* we induct on the constructors, identical with case for non-recursive types *)
  reflexivity.
Qed.

Check myunit_ind.
(* Sets values are programs, Props values are proofs *)
(* myunit in Set is unit, and in Prop is exactly True *)

(* Empty set has no elements. We can prove fun theorems about it *)
Inductive Empty_set : Set := .

Theorem the_sky_is_falling: forall x : Empty_set, 2 + 2 = 5.
Proof.
  intros x.
  destruct x.
  Show Proof.
Qed.

Definition aaa := (fun x : Empty_set => match x return (2 + 2 = 5) with end).
Check aaa.

Definition aaa' (x : Empty_set) : 2 + 2 = 5 :=
  match x with
  end.

Check aaa'.

(* note this is Empty_set -> Prop instead of Empty_set -> 2 + 2 = 5 *)
Check (fun _ : Empty_set => 2 + 2 = 5).

Check Empty_set_rect.
Definition aaa'' (x : Empty_set) : 2 + 2 = 5 := Empty_set_rect x.

Definition empty_implies_contra_one (S : Empty_set) : 2 + 2 = 5 :=
  match S with
  end.

Definition empty_implies_contra_two (S : Empty_set) :=
  match S return 2 + 2 = 5 with
  end.


Check empty_implies_contra_one.
Check empty_implies_contra_two.

Check Empty_set_ind.

Theorem skyfall2 : forall x : Empty_set, 2 + 2 = 5.
Proof (fun __ : _ => woott).