Load "cedDefs.v".

Require Import String.
Require Import Coq.Init.Logic.

Local Open Scope string_scope.

(*
A text editor is a computer program that lets a user insert, read, and change text.
We assume that strings can be inserted, read, and changed.
*)

(* Example and proof that we can insert any text *)
Definition example_buffer := fst (EditorEval (InsertLine 1 "a") nil).
Compute example_buffer.

Theorem can_insert_text :
  forall (s : string), exists (n : nat) (buffer : list string),
  fst (EditorEval (InsertLine n s) buffer) = s :: nil.
Proof.
  intros s.
  exists 1.
  exists nil.
  simpl.
  unfold insertLine.
  simpl.
  reflexivity.
Qed.

(* Example and proof that we can read any inserted text *)
Compute snd (EditorEval (ReadLine 0 "") example_buffer).

Theorem can_read_text :
  forall (s : string), exists (n : nat) (buffer : list string),
  snd (EditorEval (ReadLine n "") (fst (EditorEval (InsertLine n s) buffer))) = s.
Proof.
  intros s.
  exists 1.
  exists (s :: nil).
  simpl.
  reflexivity.
Qed.

(* Example and proof that we can change any inserted text *)
Load "cedLemmas.v".

Definition example_buffer_2 := fst (EditorEval (InsertLine 1 "b") (fst (EditorEval (InsertLine 1 "a") nil))).
Compute example_buffer_2.
Compute (fst (EditorEval (ReadLine 1 "") (fst (EditorEval (InsertLine 1 "c") (fst (EditorEval (DeleteLine 1 "") example_buffer_2)))))).
Compute (readLine example_buffer_2 1 "").
Compute (insertLine (deleteLine example_buffer_2 1) 1 "A").

Theorem can_change_text :
  forall (s1 s2 : string) (buffer : list string) (n : nat),
  n <= List.length buffer
  ->
  s1 = snd (EditorEval (ReadLine n "") buffer)
  ->
  s2 = (snd (EditorEval (ReadLine n "") (fst (EditorEval (InsertLine n s2) (fst (EditorEval (DeleteLine n "") buffer)))))).
Proof.
  intros s1 s2 buffer n n_lt_buffer. simpl. intros s1_smth.
  unfold readLine. unfold insertLine. (*unfold deleteLine.*)
  simpl.
  assert (a := thm_1 n (deleteLine buffer n) (skipn n (deleteLine buffer n)) s2 "").

  case a.
    - unfold deleteLine. simpl.
      assert (b := lemma_1 buffer n n_lt_buffer).
      assert (c := app_length (firstn n buffer) (skipn (n + 1) buffer)).
      rewrite c.
      rewrite b.
      assert (d := Nat.le_add_r n (List.length (skipn (n + 1) buffer))).
      exact d.
   - reflexivity.
Qed.
