Inductive list T :=
| Nil: list T
| Cons: T -> list T -> list T.

Check Cons.

Check cons.
Check cons 1 nil.
Check cons true nil.

(* Dependently typed match, because the type of it depends on the value being matched *)
Definition wat x :=
  match x with
  | true  => Prop
  | false => Set
  end.

Check wat.

(* Dependently typed match, because the type of it depends on the value being matched *)
Definition watt x :=
  match x with
  | true  => Prop
  | false => Set
  end.

Compute watt true.
Compute watt false.

(* Nested type example *)
(*
This is an example of a nested inductive type definition,
because we use the type we are defining as an argument to a parameterized type family.
*)
Inductive mytype :=
  | None': mytype
  | Some': option mytype -> mytype.

Check None.
Check None'.
Check Some.
Check Some'.
Check Some' (Some None').
Check Some None'.
Check (Some' (Some None')).
Check Some (Some' (Some None')).