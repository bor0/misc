#lang racket
#|
A type
======

--------- Bool Formation      -------- Nat Formation
Bool type                     Nat type

A kind    B kind
---------------- * Formation (kind)
    A*B kind
|#

(define-struct kind (type args) #:transparent)
(define bool (kind "Bool" #f))
(define nat (kind "Nat" #f))
(define (prod a b) (kind "Prod" (cons a b)))

; Check for valid judgment (kind)
(define (judgment-kind a)
  (cond ((and (kind? a) (eq? "Bool" (kind-type a))) #t)
        ((and (kind? a) (eq? "Nat" (kind-type a))) #t)
        ((and (kind? a) (eq? "Prod" (kind-type a))) (and (judgment-kind (car (kind-args a)))
                                                         (judgment-kind (cdr (kind-args a)))))
        (else #f)))

; check if these kinds are valid
(printf "kind Bool judgment ~a\n" (judgment-kind bool))
(printf "kind Nat judgment ~a\n" (judgment-kind nat))
(printf "kind Bool*Bool judgment ~a\n" (judgment-kind (prod bool bool)))
(printf "kind Bool*Nat judgment ~a\n" (judgment-kind (prod bool nat)))
(printf "kind Not valid * judgment ~a\n" (judgment-kind (prod bool "wat")))
(printf "===============\n")

#|
Now, for some variables and products

----------- Bool-Intro-T     ------------ Bool-Intro-F
True : Bool                  False : Bool

                             x : Nat
----------- Nat-Intro-Z      --------- Nat-Intro-S
Z : Nat                      S x : Nat

M : A    N : B
-------------- * Formation (type)
 (M, N) : A*B
|#

(define-struct variable (val kind) #:transparent)

(define bool-intro-t (variable 'True bool))
(define bool-intro-f (variable 'False bool))

(define nat-intro-z (variable 'Z nat))
(define (nat-intro-s n) (variable (cons 'S (variable-val n)) nat))

(define-struct var-prod (fst snd))

(define (prod-intro a-val b-val a-type b-type)
  (variable (var-prod a-val b-val) (prod a-type b-type)))

(define one (nat-intro-s nat-intro-z))
(define two (nat-intro-s one))
(define one-and-two (prod-intro one two nat nat))

; For simplicity there are no rules for split/destruct, but we still implement it
(define (destruct-prod p)
  (variable-val p))

; Check for valid judgment (type)
(define (judgment-type v)
  (and (judgment-kind (variable-kind v))
       (cond ((eq? (kind-type (variable-kind v)) "Prod")
              (let ([p (destruct-prod v)])
                (and (judgment-type (var-prod-fst p))
                     (judgment-type (var-prod-snd p)))))
             ((and (eq? (variable-kind v) nat) (eq? (variable-val v) 'Z)) #t)
             ((and (eq? (variable-kind v) nat) (pair? (variable-val v)) (eq? (car (variable-val v)) 'S)) #t)
             ((and (eq? (variable-kind v) bool) (or (eq? (variable-val v) 'True)
                                                    (eq? (variable-val v) 'False))) #t)
             (else #f))))

; check if these types are valid
(printf "type Bool judgment ~a\n" (judgment-type bool-intro-t))
(printf "type Nat judgment ~a\n" (judgment-type nat-intro-z))
(printf "type Nat judgment ~a\n" (judgment-type one))
(printf "type Nat judgment ~a\n" (judgment-type two))
(printf "type Nat*Nat judgment ~a\n" (judgment-type one-and-two))
(printf "not valid type judgment ~a\n" (judgment-type (variable "a" "b")))
(printf "===============\n")

#|
Next, we should define what it means to be a context of typed variables, using a new judgment G ctx:

G ctx
=====

------ empty context
<> ctx

G    A type    x not in G
------------------------- new var context
       G |- x : A
|#

(struct ctx-entry (name variable) #:transparent)

(define (new-var-ctx ctx entry)
  (cons entry ctx))

(define (judgment-ctx ctx)
  (foldr (lambda (x acc) (and acc (judgment-type (ctx-entry-variable x)))) #t ctx))

; Finally, judgment check according to the rules
(define ctx '())
(printf "Is context valid? (empty) ~a\n" (judgment-ctx ctx))

(define ctx-1 (new-var-ctx ctx (ctx-entry "t" bool-intro-t)))
(printf "Is context valid? (bool-intro-t) ~a\n" (judgment-ctx ctx-1))

(define ctx-2 (new-var-ctx ctx-1 (ctx-entry "f" bool-intro-f)))
(printf "Is context valid? (bool-intro-t, bool-intro-f) ~a\n" (judgment-ctx ctx-2))

(define ctx-3 (new-var-ctx ctx-2 (ctx-entry "onetwo" one-and-two)))
(printf "Is context valid? (bool-intro-t, bool-intro-f, one-and-two) judgment ~a\n" (judgment-ctx ctx-3))

(define bad-ctx (new-var-ctx ctx-3 (ctx-entry "badtype" (variable "a" "b"))))
(printf "Is context valid? (bool-intro-t, bool-intro-f, one-and-two, badtype) judgment ~a\n" (judgment-ctx bad-ctx))

; To conclude: listing out the rules mathematically hides implementation details and only captures the idea
; Doing the implementation is a matter of picking the right trade-offs (do we implement Gamma as a list, as a set, etc.)
