(* Tipova definicija za binary drvo *)
Inductive BTree {X : Type} : Type :=
| TLeaf : X -> BTree
| TNode : BTree -> X -> BTree -> BTree.

(*
Ova e slednoto drvo:
  2
 / \
1   3
*)
Definition ex1_tree := TNode (TLeaf 1) 2 (TLeaf 3) : @BTree nat.

(*
Ova e slednoto drvo:
     4
   /   \
  2     6
 / \   / \
1   3 5   7
*)
Definition ex2_tree := TNode (TNode (TLeaf 1) 2 (TLeaf 3)) 4 (TNode (TLeaf 5) 6 (TLeaf 7)) : @BTree nat.

(* Fold rekurzija na drva *)
Fixpoint tfold {X Y : Type} (fbranch : Y -> Y -> X -> Y) (fleaf : X -> Y) (tr : @BTree X) : Y :=
  match tr with
    | TNode tr1 x tr2 => fbranch (tfold fbranch fleaf tr1) (tfold fbranch fleaf tr2) x
    | TLeaf x         => fleaf x
  end.

(* Dolzina na drvo e fold na istoto kade fold funkcijata e suma na akumulatorot plus 1
za sekoj leaf *)
Definition tsize {X : Type} (tr : @BTree X) : nat :=
  tfold (fun x y _ => x + y + 1) (fun _ => 1) tr.

(* Primer deka ex1_tree ima 3 vrednosti *)
Example ex1_tree_size : tsize ex1_tree = 3. Proof. reflexivity. Qed.

(* Primer deka ex2_tree ima 7 vrednosti *)
Example ex2_tree_size : tsize ex2_tree = 7. Proof. reflexivity. Qed.

Require Import List.
Import ListNotations.

(* tflat pominuva niz site leafovi i gradi lista od istite *)
Definition tflat {X : Type} (tr : @BTree X) : list X :=
  tfold (fun x y z => x ++ z :: y) (fun x => [x]) tr.

(* Primer deka flat ex1_tree e 1, 2, 3 *)
Example ex1_tree_flat : tflat ex1_tree = [1; 2; 3]. Proof. reflexivity. Qed.

(* Primer deka flat ex1_tree e 1, 2, 3, 4, 5, 6, 7 *)
Example ex2_tree_flat : tflat ex2_tree = [1; 2; 3; 4; 5; 6; 7]. Proof. reflexivity. Qed.

(* Lema: dolzina na drvo e ednakvo na dolzina na left leaf plus right leaf plus 1 *)
Lemma wat1 : forall (X : Type) (tr1 : @BTree X) (x : X) (tr2 : @BTree X),
  tsize (TNode tr1 x tr2) = tsize tr1 + tsize tr2 + 1.
Proof.
  reflexivity.
Qed.

(* Lema: dolzina na flatirano drvo e ednakvo na dolzina na flatiran left leaf plus flatiran right leaf plus 1 *)
(* TODO: Pretvori vo lema *)
Axiom wat2 : forall (X : Type) (tr1 : @BTree X) (x : X) (tr2 : @BTree X),
  length (tflat (TNode tr1 x tr2)) = length (tflat tr1) + length (tflat tr2) + 1.

(* Dokaz deka dolzina na flatirano drvo (lista) e ednakvo so tsize na istoto drvo *)
Theorem flattened_tree_length : forall (X : Type) (tr : @BTree X),
  length (tflat tr) = tsize tr.
Proof.
  intros X tr.
  induction tr.
    - (* case leaf   *) reflexivity.
    - (* case branch *) rewrite wat1. rewrite wat2. rewrite IHtr1. rewrite IHtr2. reflexivity.
Qed.