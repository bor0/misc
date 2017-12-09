(* Sort Set : Type. *)
Variable CoolSet : Set.
Variable a : CoolSet.

(* Sort Prop : Set. *)
(* Variable 3 = 3 : Prop. *)
Variable a' : 3 = 3.


Variable moo : Type.
Variable mooo : moo.
(* Can't do this, because it's not a sort. *)
(* Variable moooo : mooo *)

(*
 <Cypi> If S is a sort and `ty : S`, then ty is a type and can be used as such
 We can't define our own sort 
 <bor0> I mean, why can I use the values of a sort as a type, but not the values of a type as a type?
 <bor0> (if that question makes any sense)
 <lyxia> bor0: those would be the type of what inhabitants?
 <Cypi> I want to answer "because". It's in the typing rules of the language, Prop, Set and Type are sorts, and the inhabitants of a sort are types
 <bor0> so a : 3 : Nat, a will be inhabitant of 3? what is wrong with that?
 <bor0> well, I don't know :) I was just curious why we need this special definition of sorts, and not just allow a : 3
 <cq1> bor0: More specifically, Girard's paradox.
*)
