%https://gist.github.com/jovaneyck/44a5cdaa13b7f6e646e1aa0f91eb747e

%load a prolog file like [this].
%or just send file to REPL

%Peano arithmetic
% https://en.wikipedia.org/wiki/Peano_axioms
% * 0 is a natural number
% * if n is a natural number, s(n) is a natural number
% * equality
%   * 0 = 0
%   * a = b -> s(a) = s(b)
% * Addition
%  * a + 0 = a
%  * a + s(b) = s(a + b)
% * Multiplication
%  * 0 x a = 0
%  * s(a) x b = (a x b) + b

%Knowledge base
%Facts (||)
%Queries
%Variables
%Rules

is_number(0).
is_number(s(N)) :- is_number(N).

eq(0,0).
eq(s(M),s(N)) :- eq(M,N).

sum(A, 0, A).
sum(A, s(B), s(C)) :-
	sum(A, B, C).

mul(0,_,0).
mul(s(A),B,C) :-
    mul(A,B,D), sum(D,B,C).

% added by bor0
%                    ev N
% ---- (EvZero)   ---------- (EvSucc)
% ev 0            ev(s(s(N))

ev(0).
ev(s(s(N))) :- ev(N).
