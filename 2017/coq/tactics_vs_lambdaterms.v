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

Theorem test : forall P Q : Prop, P -> P \/ Q.
Proof (fun (P Q : Prop) (proof_P : P) => or_introl proof_P : P \/ Q).

Print or_introl.

Locate "*".

Check prod.
Compute prod nat nat.

Definition a_swap p q := prod q p.
Check a_swap.
Compute pair 1 2.

Theorem cool_swap : forall p q : Type, (prod p q) -> (prod q p).
Proof.
  intros p q.
  intros prod_p_q.
  exact (pair (snd prod_p_q) (fst prod_p_q)).
  Show Proof.
Qed.

Theorem cool_swap_2 : forall p q : Type, (prod p q) -> (prod q p).
Proof fun p q prod_p_q => pair (snd prod_p_q) (fst prod_p_q).

Definition fun_prod (x:nat) (y:nat) := fun (f:nat->nat->nat) => f x y.
Definition fun_fst (a:nat) (b:nat) := a.
Definition fun_snd (a:nat) (b:nat) := b.

Compute (fun_prod 1 2) fun_snd.

(*
We can define product in typed lambda calculus, but inductive types:
 <benzrf> functions arent quite that extensional in the calculus of constructions
 <benzrf> that said, i believe even if they're nice and extensional there are still good reasons to use inductive types
 <benzrf> but im no expert on that
 <bor0> I totally forgot about induction. we get pair_ind for free when we do "Inductive pair"
...
 <benzrf> strictly speaking it could be the fundamental language primitive (and in some type theories, it is) but in gallina the base level is fix expressions and match expressions
*)

(*
I.O. stuff
 <benzrf> and the induction theorems are actually just normal definitions (i think) in terms of those
 <bor0> so when you use the term "fix", is it the fix point combinator?
 <benzrf> basically, but it's highly restricted
 <Cypi> (this is in contrast with other languages where you do get the recursors for free because they are primitive)
 <Cypi> "bottom" usually means "False" or something equivalent to it
 <bor0> is it called bottom because it has no constructors?
 <benzrf> it's minimal in some partial order
 <benzrf> bottom also commonly means least-defined term, tho, i.e. something that doesnt halt
 <Cypi> True would be "top", with the same idea
 <Cypi> but yeah, it can mean different things depending on context
 <benzrf> well... "doesn't halt" is a bit wrong
 <bor0> ahh. so I can say 0 is bottom for nat?
 <benzrf> sure, but people dont say it often
 <benzrf> (halting is an operational notion and bottom is a denotational notion)
 <bor0> something that doesn't terminate? it's probably the Haskell bottom I've seen. so what's the analogy of "doesn't terminate"  in Coq? doesn't have a proof?
 <benzrf> no analogy
 <benzrf> gallina is total, as it has to be if coq is gonna be consistent
 <bor0> come on! I'm reading this paper Props as Types and it's all about drawing analogies :D
 <benzrf> not having a proof is not particularly similar to not halting
 <benzrf> well...
 <benzrf> there's no need for an analogy, because the concept directly applies already
 <benzrf> you can already talk about halting for gallina
 <benzrf> and the answer is: that doesnt happen
 <bor0> ah, is it because recursion always works on reducing one of the arguments?
 <bor0> ok, I think I get it. there is no analogy because of this additional "constraint" of weak normalization
 <Cypi> A fixpoint will be accepted only if the recursive argument structurally decreases at any recuersive call
 <bor0> yeah that's what I meant, thank you! so is that the weak normalization property? or is it something else
 <Cypi> That's where the theory of inductive types is useful: you can then prove that this corresponds to some well-founded order, and so that it terminates
 <Cypi> You need that to ensure weak normalization, sure
 <benzrf> anyway:
 <benzrf> bor0: to be precise, it's common to give semantics to propositional logic in some sort of poset, famously a boolean algebra, and then (writing bars for "value assigned to") |P -> Q| ends up being equal to |True| precisely when |P| <= |Q|
 <benzrf> hence |False| is least, or "bottom", in this poset, since we want |False -> P| = |True| for all P
 <benzrf> in the case of loops in haskell: in the canonical denotational semantics for haskell, you interpret types as posets where the ordering is, intuitively, "definedness"
 <benzrf> so for example, in Bool, undefined <= True and undefined <= False but True and False are non-comparable
 <benzrf> in (Bool, Bool), (undefined, True) <= (False, True)
 <benzrf> hence "bottom" for undefined; the semantics given to nonterminating programs is an adjoined least element
 <benzrf> however, note that this is not /operational/ semantics; we aren't talking about rules for reducing terms, but rules for assigning denotations to them
 <benzrf> hence "halting" isn't quite what bottom means
 <bor0> thanks for the poset algebraic explanation. that makes things much cleaner for me why they are defined as such
 <benzrf> :)
 <bor0> also undefined <= True and undefined <= False but True and False not being comparable is... dirty? :D
 <benzrf> how so?
 <dh_work> no, that's perfectly normal
 <dh_work> True <= False would be very weird
 <benzrf> two "fully-defined" terms never have comparable semantics unless they have equal semantics
 <bor0> well if they are in the same poset I would expect undefined <= False <= True
 <dh_work> so would False <= True
 <dh_work> at least for normal boolean logic
 <benzrf> no, False <= True is normal for boolean logic
 <benzrf> but this isn't about ordering the canonical inhabitants of a type
 <benzrf> it's about ordering /all/ of the inhabitants of a type
 <dh_work> that would mean, roughly speaking, that the behavior or meaning of False is included in the behavior/meaning of True
 <benzrf> the point is ordering based on "amount of information", nothing to do with the information itself
 <benzrf> that is: intuitively, A <= B when you can get the same info by scrutinizing B as you can by scrutinizing A, and possibly more
 <bor0> btw, lambdabot answers True to [> False < True]. I don't know if I'm missing context here
 <benzrf> entirely different ordering
 <dh_work> that's something else
 <benzrf> that's a haskell-internal ordering, and it's an ordering on the canonical inhabitants of Bool
 <benzrf> this is a semantics that's externally applied to haskell
 <benzrf> the posets involved are mathematical objects, not language constructs
 <benzrf> you interpret types as posets and terms with those types as elements of those posets
 <benzrf> the point of this semantics is to talk about the /non/-ideal behavior of haskell
 <benzrf> i.e., looping, halting, partially-defined
 <benzrf> so the posets are supposed to capture *all* of the inhabitants of a type, not just the *canonical* ones, and the interesting parts of the ordering have to do with the relationships between non-canonical inhabitants
 <benzrf> any two distinct canonical inhabitants will always be non-comparable
 <bor0> what are canonical inhabitants?
 <benzrf> the things you normally think of as being the "values of the type"
 <bor0> ah! I thought of that!
 <benzrf> like True, False, [1, 2, 3], [1, 1, 1, 1, 1...]
 <bor0> ok, so Haskell is comparing values is what you are saying
 <benzrf> (the last of those would not describe any canonical inhabitant of [Integer] in a strict language)
 <benzrf> yeah basicall
 <benzrf> y
 <benzrf> well to be precise Ord instances for some types are well-defined on some non-canonical inhabitants
 <benzrf> e.g.:
 <benzrf> Haskell> (1, undefined) < (3, undefined)
 <benzrf> True
 <bor0> it checks fst lazily?
 <benzrf> yeah
 <benzrf> but ultimately sort of the point is that you can't from *inside* haskell scrutinize something for whether it's defined or not
 <benzrf> that would be the halting problem!
 <benzrf> you could detect literal "undefined", of course, but not arbitrary looping stuff like "let loop = loop in ..."
 <dh_work> uh.....
 <bor0> what is the advantage of having that in Haskell, and the disadvantage of not having that in Coq?
 <dh_work> oh wait n/m
 <benzrf> in haskell you have total lack of restrictions on your code's structure, which is very liberating
 <bor0> is that it? nothing around expressiveness?
 <benzrf> well, it makes haskell turing complete, while gallina is not
 <benzrf> but turing completeness is a bug, not a feature ;)
 <bor0> ahh
 <benzrf> a lot of the time it's not easy to convince the computer that a given definition is guaranteed to halt
 <dh_work> that's debatable :-)
 <benzrf> in haskell, you don't need to
 <benzrf> on the other hand, this means that you aren't protected from fucking up
 <bor0> so I've read Coq has IO but I'm far from that. anyway, how does that relate to all of this?
 <benzrf> it's not too dissimilar to any other restriction - compare side effects vs pure
 <benzrf> it does?? i didn't know that myself
 <dh_work> it's convenient for the way that coq is laid out that code is always safe without any implicit conditions or proof obligations
 <dh_work> but it's not the only way to run the world...
 <bor0> sorry it was a separate library, coq.io
 <benzrf> a
 <dh_work> there's an IO monad in the ynot library, and maybe other instances
 <benzrf> but arent all of these things just stuff for generating a program in coq and then exporting something in another language
 <benzrf> i.e., you're not "running a coq program"
 <dh_work> pretty much, but that's more or less true of everything in coq
 <benzrf> perhaps it's a specious distinction
 <dh_work> I suppose it matters some if you can't [Eval compute in IO.print "hello"]
 <benzrf> hue hue hue
 <dh_work> and I don't think there's any mechanism by which that could be made to work
*)