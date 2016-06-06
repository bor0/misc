/* 1.3 */
female(mary).
female(sandra).
female(juliet).
female(lisa).
male(peter).
male(paul).
male(dick).
male(bob).
male(harry).
parent(bob, lisa).
parent(bob, paul).
parent(bob, mary).
parent(juliet, lisa).
parent(juliet, paul).
parent(juliet, mary).
parent(peter, harry).
parent(lisa, harry).
parent(mary, dick).
parent(mary, sandra).

father(X, Y) :- parent(X, Y), male(X).
sister(X, Y) :- parent(Z, X), parent(Z, Y), female(X), X \= Y.
grandmother(X, Y) :- parent(Z, Y), parent(X, Z), female(X).
% cousin(X, Y) :- 
brother(X, Y) :- parent(Z, X), parent(Z, Y), male(X), X \= Y.

/* 2.1 */
analyse_list([]) :- write('This is an empty list.').
analyse_list([X | Xs]) :-
    write('This is the head of your list: '),
    write(X), nl,
    write('This is the tail of your list: '),
    write(Xs), nl.

/* 2.2 */
membership(_, []) :- false.
membership(X, [X | _]) :- true.
membership(X, [_ | Xs]) :- membership(X, Xs).

/* 2.3 */
remove_duplicates([], []).
remove_duplicates([X | Xs], L) :-
    membership(X, Xs), remove_duplicates(Xs, L).
remove_duplicates([X | Xs], [X | L]) :-
    not(membership(X, Xs)), remove_duplicates(Xs, L).

/* 2.4 */
reverse_list([], []).
reverse_list([X | Xs], L) :-
    reverse_list(Xs, T),
    append(T, [X], L).

/* 2.5 */
whoami([]).
whoami([_, _ | Rest]) :- whoami(Rest).
/* Only lists of length 2k */

/* 2.6 */
last1([X], X).
last1([_ | Xs], L) :- last1(Xs, L).

/* Find an L such that something appended to singleton list [L] gives the input list
Given [a, a1, ..., an], _ = [a, a1, ..., an-1], [L] = an i.e. L = [an], X = _ append L */
last2(X, L) :- append(_, [L], X).

/* 2.7 */
replace([], _, _, []).
replace([X | Xs], A, B, [X | L]) :- X \= A, replace(Xs, A, B, L).
replace([X | Xs], A, B, [B | L]) :- X = A, replace(Xs, A, B, L).

/* not solved 2.8 */
/*subset([], _).
subset([X | Xs], Y) :- member(X, Y), subset(Xs, Y).

has_duplicates([X | Xs]) :- member(X, Xs), !; has_duplicates(Xs).

power(X, P) :- subset(P, X), not(has_duplicates(P)).*/

/* 2.9 */
longer([_ | _], []).
longer([_ | Xs], [_ | Ys]) :- longer(Xs, Ys).

/* 2.10 */
successor([], [x]).
successor([_ | Xs], [x | L]) :- successor(Xs, L).

plus([], L, L).
plus([x | X], M, [x | L]) :- plus(X, M, L).

% definition m * 0 = 0
times(_, [], []).
% definition m * (n + 1) = (m * n) + m
times(M, [_ | Xs], L) :- times(M, Xs, LL), plus(LL, M, L).

/* 3.1 */
distance((X1, Y1), (X2, Y2), D) :-
    Xd is X2 - X1,
    Yd is Y2 - Y1,
    D is (Xd * Xd + Yd * Yd)^0.5.

/* 3.2 */
writeTimes(0, _) :- !.
writeTimes(X, Y) :-
    write(Y),
    P is X - 1,
    writeTimes(P, Y).

drawSquare(0, _, _) :- !.
drawSquare(X, M, Y) :-
    writeTimes(M, Y), nl,
    P is X - 1,
    drawSquare(P, M, Y).

square(X, Y) :- drawSquare(X, X, Y).

/* 3.3 */
fibonacci(0, X) :- X = 1, !.
fibonacci(1, X) :- X = 1, !.
fibonacci(Y, X) :-
    First is Y - 1,
    Second is Y - 2,
    fibonacci(First, Ret1),
    fibonacci(Second, Ret2),
    X is Ret1 + Ret2.

/* not solved 3.4 */

/* 3.5 */
element_at([X | _], 1, X) :- !.
element_at([_ | Xs], Y, Z) :-
    Ynew is Y - 1,
    element_at(Xs, Ynew, Z).

/* 3.6 */
mean([], Y, Y).
mean([X | Xs], Y, Z) :-
    Ynew is Y + X,
    mean(Xs, Ynew, Z).

mean([], 0).
mean(Xs, Y) :-
    length(Xs, L),
    mean(Xs, 0, M),
    Y is M/L.

/* 3.7 */
minimum([], M, M).
minimum([X | Xs], M, Z) :-
    X < M, minimum(Xs, X, Z);
    minimum(Xs, M, Z).

minimum([X | Xs], Q) :- minimum(Xs, X, Q), !.

/* 3.8 */
range(A, A, [A]) :- !.
range(A, B, [A | Q]) :-
    A < B, Anew is A + 1,
    range(Anew, B, Q).

/* 3.9 */
born(jan, date(20,3,1977)).
born(jeroen, date(2,2,1992)).
born(joris, date(17,3,1995)).
born(jelle, date(1,1,2004)).
born(jesus, date(24,12,0)).
born(joop, date(30,4,1989)).
born(jannecke, date(17,3,1993)).
born(jaap, date(16,11,1995)).

year(Y, X) :- born(X, date(_, _, Y)).

before(date(D1, M1, Y1), date(D2, Y2, M2)) :-
    date_time_stamp(date(Y1, M1, D1), Stamp1),
    date_time_stamp(date(D2, Y2, M2), Stamp2),
    Stamp1 =< Stamp2.

older(Person, P) :-
    born(Person, date(D1, M1, Y1)),
    date_time_stamp(date(Y1, M1, D1), Stamp1),
    born(P, date(D2, M2, Y2)),
    date_time_stamp(date(Y2, M2, D2), Stamp2),
    Stamp1 < Stamp2.

/* 3.10 */
execute((P, Q), east, move, (Pout, Q), east)   :- Pout is P + 1.
execute((P, Q), west, move, (Pout, Q), west)   :- Pout is P - 1.
execute((P, Q), north, move, (P, Qout), north) :- Qout is Q + 1.
execute((P, Q), south, move, (P, Qout), south) :- Qout is Q - 1.
execute(Position, east, left, Position, north).
execute(Position, west, left, Position, south).
execute(Position, north, left, Position, west).
execute(Position, south, left, Position, east).
execute(Position, east, right, Position, south).
execute(Position, west, right, Position, north).
execute(Position, north, right, Position, east).
execute(Position, south, right, Position, west).

status((P, Q), Orientation, [], (P, Q), Orientation).
status((P, Q), Orientation, [Command | Commands], (Pout, Qout), OrientationOut) :-
    execute((P, Q), Orientation, Command, (TempPout, TempQout), TempOrientationOut),
    status((TempPout, TempQout), TempOrientationOut, Commands, (Pout, Qout), OrientationOut).

status([], (0, 0), north).
status(Commands, NewPosition, NewOrientation) :-
    status((0, 0), north, Commands, NewPosition, NewOrientation).

/* not solved 3.11 */

/* 3.12 */
hasdivisors(Number, Number).
hasdivisors(Number, Start) :-
    Q is Number mod Start, Q \= 0,
    Next is Start + 1,
    hasdivisors(Number, Next).

prime(Number) :- Number >= 2, hasdivisors(Number, 2), !.

/* not solved 3.13 */
goldbach(Number, (A, B)) :-
    2 =< A,
    A >= Number/2,
    prime(A), prime(B).

goldbach(Number, (A, B)) :-
    Anew is A + 1,
    2 =< Anew, Anew >= Number/2,
    B is Number - Anew,
    goldbach(Number, (Anew, B)).

/* 3.14 */
% :- consult("words.pl").
word_letters(Word, Letters) :- atom_chars(Word, Letters).

remove_first([], _, _).
remove_first([Element | List], Element, Output) :- Output = List.
remove_first([El | List], Element, [El | Output]) :- remove_first(List, Element, Output), !.

cover([], _).
cover([X | Xs], Y) :-
    member(X, Y), 
    remove_first(Y, X, Ynew), !,
    cover(Xs, Ynew).

solution(LettersIn, Word, Score) :-
    word(Word),
    word_letters(Word, LettersOut),
    cover(LettersOut, LettersIn),
    length(LettersOut, Score), !.

topsolution(LettersIn, Word, Score, OutScore) :-
    not(solution(LettersIn, Word, Score)),
    OutScore is Score - 1,
    solution(LettersIn, Word, OutScore), !.

topsolution(LettersIn, Word, Score, OutScore) :-
    solution(LettersIn, _, Score),
    NewScore is Score + 1,
    topsolution(LettersIn, Word, NewScore, OutScore).

/* not solved 3.15 */

/* 4.1 */
%current_op(P, A, +).
%P = 200,A = fy ;
:- op(100, yfx, plink), op(200, xfy, plonk).
% plink is left associative
% plonk is right associative
/*
tiger plink dog plink fish = X plink Y.
X = tiger plink dog,
Y = fish.

cow plonk elephant plink bird = X plink Y.
% use the fact that plink binds stronger than plonk, i.e. first evaluate plink
% so cow plonk (elephant plink bird)

X = (lion plink tiger) plonk (horse plink donkey).
X = lion plink tiger plonk horse plink donkey
because plink binds stronger
*/

pp_analyse(X plink Y) :-
    write('Principal operator: '), write(plink), nl,
    write('Left sub-term: '), write(X), nl,
    write('Right sub-term: '), write(Y), nl.

pp_analyse(X plonk Y) :-
    write('Principal operator: '), write(plonk), nl,
    write('Left sub-term: '), write(X), nl,
    write('Right sub-term: '), write(Y), nl.

/* solved 4.2 */
% :- op(100, fx, the), op(100, fx, a), op(200, xfx, has).
% claudia has a car => claudia has (a car)
% the lion has hunger = Who has What => Who = the lion, What = hunger
% she has whatever has style => due to xfx, non-associative i.e. no nesting

/* solved 4.3 */
neg(A) :- not(A).
and(A, B) :- A, B.
or(A, B) :- A; B.
implies(A, B) :- or(neg(A), B).

:- op(99, fy, neg).
:- op(100, yfx, and).
:- op(101, yfx, or).
:- op(102, yfx, implies).

% :- a implies ((b and c) and d) = a implies b and c and d.

/* solved 4.4 */
nnf(A and B) :- nnf(A), nnf(B).
nnf(A or B)  :- nnf(A), nnf(B).
nnf(neg A)   :- atom(A), nnf(A).
nnf(A)       :- atom(A).
/*
to_nnf(A and B, F) :- atom(A), F = not A or B; atom(B), F = not nnf(A), nnf(B).
to_nnf(A or B, F)  :- nnf(A), nnf(B).
to_nnf(neg A, F)   :- atom(A), nnf(A).
to_nnf(A, F)       :- not(atom(A)), .
*/

/* solved 4.5 */
cnf(A) :- atom(A).
cnf(neg A) :- atom(A).
cnf(A or B) :- cnf(A), cnf(B).
cnf(A and B) :- cnf(A), cnf(B).

/* not solved 4.6 */
:- op(103, yfx, iff).
iff(A, B) :- (A implies B) and (B implies A).

/* solved 5.1 */
/*
?- (Result = a ; Result = b), !, write(Result).
a
Result = a.
?- member(X, [a, b, c]), !, write(X).
a
X = a.
*/

/* solved 5.2 */
result([_, E | L], [E | M]) :- !, result(L, M).
result(_, []).

/* solved 5.3 */
%gcd(1, B, B).
gcd(A, 0, A) :- !.
gcd(A, B, C) :-
    Anew is B,
    Bnew is A mod B,
    gcd(Anew, Bnew, C).

/* solved 5.4 */
occurences(_, [], 0).
occurences(X, [X | Xs], Count) :-
    occurences(X, Xs, NewCount), !,
    Count is 1 + NewCount.
occurences(X, [_ | Xs], Count) :-
    occurences(X, Xs, Count).

/* solved 5.5 */
divisors(X, X, [X]).
divisors(X, Start, [Start | List]) :-
    X mod Start =:= 0,
    NewStart is Start + 1,
    divisors(X, NewStart, List), !.
divisors(X, Start, List) :-
    X mod Start \= 0,
    NewStart is Start + 1,
    divisors(X, NewStart, List).

divisors(X, Y) :- divisors(X, 1, Y).

/* not solved 5.6 */
/* not solved 5.7 */
