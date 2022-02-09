first(L, E) :- L = [H|_], E = H.
second(L, E) :- L = [_,H|_], E = H.

% in terms of first
nth(L, 1, E) :- first(L, K), E is K, !.
% being explicit with E
nth(L, N, E) :- L = [_|T], F is N - 1, nth(T, F, K), E is K, !.

nth2([H|_], 1, H) :- !.
nth2([_|T], N, E) :- N2 is N - 1, nth2(T, N2, E), !.

/*
y = nth2(y::T,N-1)
------------------- (Nth)      ---------------- (Fst)
x = nth2(x::y::T,N)            x = nth2(x::T,1)

E.g. x::y::z

First:

---------------- (Fst)
x = nth2(x::T,1)

Second:

---------------- (Fst)
  x = nth2(x::T,1)
------------------- (Nth)
y = nth2(y::x::T,2)

Third:

---------------- (Fst)
   x = nth2(x::T,1)
 ------------------- (Nth)
 y = nth2(y::x::T,2)
---------------------- (Nth)
z = nth2(z::y::x::T,3)
*/
