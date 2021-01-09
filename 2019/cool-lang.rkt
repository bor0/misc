#lang racket

#|
Our language has two types: a bool and a natural number.
The evaluator returns a mixed combination of these.

Let eval be represented by ->. We list the rules:

    v2 -> v2'
----------------- (E-IfTrue)
if T v2 v3 -> v2'

    v3 -> v3'
----------------- (E-IfFalse)
if F v2 v3 -> v3'

         v1 -> v1'
--------------------------- (E-If)
if v1 v2 v3 -> if v1' v2 v3

     v1 -> v1'
------------------- (E-Succ)
succ v1 -> succ v1'

----------- (E-PredZero)
pred O -> O

------------------ (E-PredSucc)
pred (succ v) -> v

     v1 -> v1'
------------------- (E-Pred)
pred v1 -> pred v1'

-------------- (E-IsZeroZero)
is-zero O -> T

--------------------- (E-IsZeroSucc)
is-zero (succ v) -> F

        v1 -> v1'
------------------------- (E-IsZero)
is-zero v1 -> is-zero v1'

- (E-O)
O

- (E-T)
T

- (E-F)
F
|#
(define (eval expr)
  (match expr
    [(list 'if 'T v2 _) (eval v2)] ; E-IfTrue
    [(list 'if 'F _ v3) (eval v3)] ; E-IfFalse
    [(list 'if v1 v2 v3) (eval (list 'if (eval v1) v2 v3))] ; E-If
    [(list 'succ v1) (cons 'succ (eval v1))] ; E-Succ
    [(list 'pred O) 'O] ; E-PredZero
    [(list 'pred (list 'succ k)) k] ; E-PredSucc
    [(list 'pred v1) (cons 'pred (eval v1))] ; E-Pred
    [(list 'is-zero 'O) 'T] ; E-IsZeroZero
    [(list 'is-zero (list 'succ v)) 'F] ; E-IsZeroSucc
    [(list 'is-zero v1) (list 'is-zero (eval v1))] ; E-IsZero
    ['O 'O] ; E-O
    ['T 'T] ; E-T
    ['F 'F] ; E-F
    [_ error "No rule applies"]))

#|
Since eval cannot distinguish between various types, we need
another computation in order to see if types match.

Let the type checking relation (type-of) be represented by :. We list the rules:

--------- (T-True)
T : TBool

--------- (T-False)
F : TBool

-------- (T-Zero)
O : TNat

t1 : TBool, t2 : T, t3 : T
-------------------------- (T-If)
     if t1 t2 t3 : T

  t : TNat
------------- (T-Succ)
succ t : TNat

  t : TNat
------------- (T-Pred)
pred t : TNat

    t : TNat
----------------- (T-IsZero)
is-zero t : TBool

|#
(define (type-of expr)
  (match expr
    ['T 'TBool] ; T-True
    ['F 'TBool] ; T-False
    ['O 'TNat] ; T-Zero
    [(list 'if t1 t2 t3) ; T-If
     (let ([t1t (type-of t1)]
           [t2t (type-of t2)]
           [t3t (type-of t3)])
       (if (and
            (eq? t1t 'TBool)
            (eq? t2t t3t)) t2t #f))]
    [(list 'succ t1) ; T-Succ
     (let ([t1t (type-of t1)])
       (if (eq? t1t 'TNat) t1t #f))]
    [(list 'pred t1) ; T-Pred
     (let ([t1t (type-of t1)])
       (if (eq? t1t 'TNat) t1t #f))]
    [(list 'is-zero t1) ; T-IsZero
     (let ([t1t (type-of t1)])
       (if (eq? t1t 'TNat) 'TBool #f))]
    [_ error #f]))

(define (safe-eval expr)
  (let ([t (type-of expr)])
    (if (false? t)
        (error "Expression does not type check!")
        (cons t (eval expr)))))

(safe-eval 'O)
(safe-eval '(succ O))
(safe-eval '(if (is-zero (pred O)) (succ O) O))
(safe-eval '(if (is-zero (succ O)) (succ O) O))
(safe-eval '(if (is-zero (pred O)) T F))
(safe-eval '(if (is-zero (succ O)) T F))
(safe-eval '(if (is-zero (succ O)) T O)) ; not valid
