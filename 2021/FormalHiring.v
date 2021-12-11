(* coqdoc -s --no-index FormalHiring.v *)
(** * FormalHiring: Technical hiring, formalized *)

(* ###################################################################### *)
(** * Introduction *)

(** Hiring is...

    Let C be the candidate, Q be the set of engineering qualities and S be
    the set of scores. Our job is essentially to find a function (mapping)
    f_C : Q -> S which, once defined for all Q, should aid us for a
    "hire"/"don't hire" decision.

    To respect this definition, we start defining partial total and total
    functions as properties in terms of relations. *)

Definition relation (X Y: Type) := X -> Y -> Prop.

Definition partial_function {X Y: Type} (R: relation X Y) :=
  forall (x : X) (y1 y2 : Y), R x y1 -> R x y2 -> y1 = y2.

Definition total_function {X Y:Type} (R: relation X Y) :=
  partial_function R /\ forall (x : X), exists (y : Y), R x y.

(** With just these definitions, it is now easy to define engineering
    qualities and construct a map (for some candidate) such that each
    engineering quality corresponds to a particular score.

    In the following example we will show that ultimately, we are searching
    for a total function in order to get a better sense for a decision. *)
Module Example1.

(** We start with a a small subset of qualities: *)

Inductive quality : Type :=
  | ProblemSolving
  | Communication
  | Learning
  | Knowledge
  .

Inductive scoring_map_1 : quality -> nat -> Prop :=
  | scoring_map_1_1 : scoring_map_1 ProblemSolving 1
  | scoring_map_1_2 : scoring_map_1 Communication 2
  | scoring_map_1_3 : scoring_map_1 Learning 3
  | scoring_map_1_4 : scoring_map_1 Knowledge 4
  .

(** We will now prove that [scoring_map_1] is total, thus it is enough to
    give us a hint for bringing a decision. *)

Theorem scoring_map_1_total :
  total_function scoring_map_1.
Proof.
  unfold total_function. split.
  - unfold partial_function. intros.
    induction x; inversion H; inversion H0; reflexivity.
  - intros. induction x.
    + exists 1. constructor.
    + exists 2. constructor.
    + exists 3. constructor.
    + exists 4. constructor.
Qed.

Inductive scoring_map_2 : quality -> nat -> Prop :=
  | scoring_map_2_1 : scoring_map_2 ProblemSolving 1
  | scoring_map_2_2 : scoring_map_2 Communication 2
  | scoring_map_2_3 : scoring_map_2 Learning 3
  .

(** However, [scoring_map_2] is not total and as such may not be really
    helpful in bringing a decision. *)

Theorem scoring_map_2_not_total :
  ~ (total_function scoring_map_2).
Proof.
  unfold not. unfold total_function. intros. destruct H.
  assert (H1 := H0 Knowledge). destruct H1. inversion H1.
Qed.

End Example1.

(* ###################################################################### *)
(** * Helpful vs non-helpful functions *)

(** As we've seen, a function that is total gives us more information (is
    more helpful) than a function that is partial.

    For a function to be helpful, it has to be total on every quality Q.

    The hiring process starts with a partial function, and then fills in
    gaps throughout the way, potentially converging to a total function,
    in which a decision is possible to be made.

    Note that, for a decision to be made, it is not always necessary to
    have total functions -- e.g. in the case where a candidate has a pretty
    low score on some quality, for example, they are way below the threshold
    and it makes no sense to test for other qualities.

    We will now formalize this thought in the next example. *)

Module Example2.

(** Qualities now also include a weight, such that they will be calculated
    against some threshold. *)

Inductive quality : nat -> Type :=
  | ProblemSolving : quality 5
  | Communication  : quality 5
  | Learning       : quality 3
  | Knowledge      : quality 2
  .

Inductive scoring_map_1 : nat -> Prop :=
  | scoring_map_1_Z : scoring_map_1 0
  | scoring_map_1_1 n k
                    (H : quality n)
                    (Hprev : scoring_map_1 k)
                    :  scoring_map_1 (1 * n + k)
  | scoring_map_1_2 n k
                    (H : quality n)
                    (Hprev : scoring_map_1 k)
                    :  scoring_map_1 (2 * n + k)
  | scoring_map_1_3 n k
                    (H : quality n)
                    (Hprev : scoring_map_1 k)
                    :  scoring_map_1 (3 * n + k)
  | scoring_map_1_4 n k
                    (H : quality n)
                    (Hprev : scoring_map_1 k)
                    :  scoring_map_1 (4 * n + k)
  .
(** We also have a way to calculate the weight of a map. For example,
    given the scoring above, the weight of problem solving is 5. *)
Example ProblemSolving_weight : scoring_map_1 5.
Proof.
  apply scoring_map_1_1 with (n := 5).
  apply ProblemSolving. apply scoring_map_1_Z.
Qed.

(** We can also prove that the total weight is 32, as follows: *)
Example total_weight_1 : scoring_map_1 32.
Proof.
  apply scoring_map_1_1 with (n := 5).
  apply ProblemSolving.
  apply scoring_map_1_2 with (n := 5).
  apply Communication.
  apply scoring_map_1_3 with (n := 3).
  apply Learning.
  apply scoring_map_1_4 with (n := 2).
  apply Knowledge.
  apply scoring_map_1_Z.
Qed.

(** For our second scoring map example, we will consider a partial function
    and show that it has bigger score than the total function: *)
Inductive scoring_map_2 : nat -> Prop :=
  | scoring_map_2_Z : scoring_map_2 0
  | scoring_map_2_1 n k
                    (H : quality n)
                    (Hprev : scoring_map_2 k)
                    :  scoring_map_2 (5 * n + k)
  | scoring_map_2_2 n k
                    (H : quality n)
                    (Hprev : scoring_map_2 k)
                    :  scoring_map_2 (5 * n + k)
  | scoring_map_2_3 n k
                    (H : quality n)
                    (Hprev : scoring_map_2 k)
                    :  scoring_map_2 (5 * n + k)
  .

(** This new map, even though partial, has bigger weight than the previous
    map: *)
Example total_weight_2 : scoring_map_2 65.
Proof.
  apply scoring_map_2_1 with (n := 5).
  apply ProblemSolving.
  apply scoring_map_2_2 with (n := 5).
  apply Communication.
  apply scoring_map_2_3 with (n := 3).
  apply Learning.
  apply scoring_map_2_Z.
Qed.

End Example2.

(** We reached a point where we have to ask ourselves: are total functions
    helpful, and can partial functions also be helpful?

    The simplest answer is yes to both. Total functions are more helpful
    than partial because not every partial function is helpful, but all
    total functions are helpful.

    We have to make a design decision about our system. We have to consider
    either allowing both total and partial functions, or just total
    functions.

    We have already seen how we can work with partial functions and
    weighted scores, so from this point onward we will only consider
    total functions. This simplification will set us free from having
    to define weights on each quality.

    Next, we will put our focus on how we can transition from having a
    partial function to finally a total one, where in each transition step
    we will have gathered new information and encode this information into
    our system.
*)

Module Example3.

(** We will re-use the same qualities as before: *)

Inductive quality : Type :=
  | ProblemSolving
  | Communication
  | Learning
  | Knowledge
  .

(** Together with the same sample map: *)

Inductive scoring_map_2 : quality -> nat -> Prop :=
  | scoring_map_2_1 : scoring_map_2 ProblemSolving 1
  | scoring_map_2_2 : scoring_map_2 Communication 2
  | scoring_map_2_3 : scoring_map_2 Learning 3
  .

(** Note that we have already proven that [scoring_map_2] is partial. Next,
    we want total, thus it is enough to
    give us a hint for bringing a decision. *)

Theorem scoring_map_1_total :
  total_function scoring_map_1.
Proof.
  unfold total_function. split.
  - unfold partial_function. intros.
    induction x; inversion H; inversion H0; reflexivity.
  - intros. induction x.
    + exists 1. constructor.
    + exists 2. constructor.
    + exists 3. constructor.
    + exists 4. constructor.
Qed.

Inductive scoring_map_2 : quality -> nat -> Prop :=
  | scoring_map_2_1 : scoring_map_2 ProblemSolving 1
  | scoring_map_2_2 : scoring_map_2 Communication 2
  | scoring_map_2_3 : scoring_map_2 Learning 3
  .

(** However, [scoring_map_2] is not total and as such may not be really
    helpful in bringing a decision. *)

Theorem scoring_map_2_not_total :
  ~ (total_function scoring_map_2).
Proof.
  unfold not. unfold total_function. intros. destruct H.
  assert (H1 := H0 Knowledge). destruct H1. inversion H1.
Qed.

End Example3.
