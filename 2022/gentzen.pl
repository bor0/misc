not(_).
and(_, _).
or(_, _).
imp(_, _).

rule_join(proof(X), proof(Y), proof(and(X, Y))).
rule_elim_l(proof(and(X, _)), proof(X)).
rule_elim_r(proof(and(_, Y)), proof(Y)).
rule_double_tilde_intro(proof(X), proof(not(not(X)))).
rule_double_tilde_elim(proof(not(not(X))), proof(X)).
from_proof(proof(X), X).
rule_fantasy(X, F, proof(imp(X, Z2))) :- from_proof(Z, Z2), call(F, proof(X), Z).
rule_detachment(proof(X), proof(imp(X, Y)), proof(Y)).
rule_contra(proof(imp(not(Y), not(X))), proof(imp(X, Y))).
rule_contra(proof(imp(X, Y)), proof(imp(not(Y), not(X)))).
rule_de_morgan(proof(and(not(X), not(Y))), proof(not(or(X, Y)))).
rule_de_morgan(proof(not(or(X, Y))), proof(and(not(X), not(Y)))).
rule_switcheroo(proof(or(X, Y)), proof(imp(not(X), Y))).
rule_switcheroo(proof(imp(not(X), Y)), proof(or(X, Y))).
identity(X, X).

% Example: ⊢ a∨¬a
eg_proof1(X) :-
  rule_fantasy(not(a), identity, X1), % X1 = proof(imp(not(a), not(a))).
  rule_switcheroo(X1, X). % X = proof(or(a, not(a))).

% Example: a∧<a→b>→b
lemma2(T, X) :-
  rule_elim_l(T, X1), % X1 = proof(a)
  rule_elim_r(T, X2), % X2 = proof(imp(a, b))
  rule_detachment(X1, X2, X). % proof(b)

eg_proof2(X) :-
  rule_fantasy(and(a, imp(a, b)), lemma2, X).
