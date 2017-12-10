Require Extraction.

Fixpoint length (a : list nat) :=
  match a with
  | cons x a' => 1 + length a'
  | nil       => 0
  end.

Theorem length_ap_list : forall l1 l2 : list nat, length (l1 ++ l2) = length l1 + length l2.
Proof.
  intros l1 l2.
  induction l1.
  - (* base *) simpl. reflexivity.
  - (* i.h. *) simpl. rewrite IHl1. reflexivity.
Qed.

Extraction Language Haskell.
Recursive Extraction length.

(*
data Nat =
   O
 | S Nat deriving (Show)

data List a =
   Nil
 | Cons a (List a) deriving (Show)

add :: Nat -> Nat -> Nat
add n m =
  case n of {
   O -> m;
   S p -> S (add p m)}

lengthh :: (List Nat) -> Nat
lengthh a =
  case a of {
   Nil -> O;
   Cons _ a' -> add (S O) (lengthh a')}

convert O = 0
convert (S n) = 1 + convert n

ffmap _ Nil = []
ffmap x (Cons a y) = (x a) : (ffmap x y)

theList = Cons O (Cons (S O) (Cons (S (S O)) Nil))
theList2 = Cons O (Cons (S O) (Cons (S (S O)) theList))

lolappend x Nil = x
lolappend x (Cons y z) = Cons y (lolappend x z)

theList3 = lolappend theList theList2

main = do
  print theList
  print $ lengthh theList
  print $ ffmap convert theList
  print $ convert $ lengthh theList
  print $ convert $ lengthh theList2
  print $ convert $ lengthh theList3
*)