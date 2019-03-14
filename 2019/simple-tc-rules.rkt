#lang racket
#|
A type
======

--------- Bool Formation      -------- Nat Formation
Bool type                     Nat type

A type    B type
---------------- * Formation
    A*B type
|#

(define-struct kind (type args) #:transparent)
(define bool (kind "Bool" #f))
(define nat (kind "Nat" #f))
(define (prod a b) (kind "Prod" (cons a b)))

; Check for valid judgment
(define (judgment-type a)
  (cond ((and (kind? a) (eq? "Bool" (kind-type a))) #t)
        ((and (kind? a) (eq? "Nat" (kind-type a))) #t)
        ((and (kind? a) (eq? "Prod" (kind-type a))) (and (judgment-type (car (kind-args a)))
                                                         (judgment-type (cdr (kind-args a)))))
        (else #f)))

; check if these types are valid
(judgment-type bool)
(judgment-type nat)
(judgment-type (prod bool bool))
(judgment-type (prod bool nat))
(judgment-type (prod bool "wat"))

#|
Now, for some variables and products

---------------- Bool-Intro-1     ------------ Bool-Intro-2
G |- True : Bool                  G |- False : Bool

                                  G |- x : Nat
---------------- Nat-Intro-1      -------------- Nat-Intro-2
G |- Z : Nat                      G |- S x : Nat

G !- M : A    G !- N : B
------------------------ * Intro
    G !- (M,N) : A*B
|#

(define-struct variable (val type) #:transparent)

(define bool-intro-1 (variable 'True bool))
(define bool-intro-2 (variable 'False bool))

(define nat-z (variable 'Z nat))
(define (nat-s n) (variable (cons 'S (variable-val n)) nat))

(define (prod-intro a-val b-val a-type b-type)
  (variable (cons a-val b-val) (prod a-type b-type)))

(define one (nat-s nat-z))
(define two (nat-s one))
(define one-and-two (prod-intro one two nat nat))

#|
Next, we should define what it means to be a context of typed variables, using a new judgment G ctx:

G ctx
=====

------ empty context
<> ctx

G ctx    A type    x is not in G
-------------------------------- new var context
          G, x : A ctx
|#

(struct ctx-entry (name variable) #:transparent)

(define (new-var-ctx g entry)
  (if (and (judgment-type (variable-type (ctx-entry-variable entry)))
           (not (member (ctx-entry-name entry) (map ctx-entry-name g))))
      (cons entry g)
      g))

(define (get-var-ctx g var)
  (let ([entry (findf (lambda (entry) (eq? var (ctx-entry-name entry))) g)])
    (if entry
        (ctx-entry-variable entry)
        entry)))

(define (judgment-ctx g)
  (foldr (lambda (x acc) (and acc (judgment-type (ctx-entry-variable x)))) #t ctx))

(define ctx '())
(set! ctx (new-var-ctx ctx (ctx-entry "t" bool-intro-1)))
(set! ctx (new-var-ctx ctx (ctx-entry "f" bool-intro-2)))
(set! ctx (new-var-ctx ctx (ctx-entry "onetwo" one-and-two)))

(judgment-ctx ctx) ; is context valid?

; Finally, judgment check according to the rules

; For simplicity there are o rules for split/destruct, but we still implement it
(define (destruct-prod p)
  (cons (variable (variable-val (car (variable-val p)))
                  (car (kind-args (variable-type p))))
        (variable (variable-val (cdr (variable-val p)))
                  (cdr (kind-args (variable-type p))))))

(define (variable-typecheck v)
  (cond ((not (judgment-type (variable-type v))) #f)
        ((eq? (kind-type (variable-type v)) "Prod")
         (let ([vars (destruct-prod v)])
           (and (variable-typecheck (car vars))
                (variable-typecheck (cdr vars)))))
        ((and (eq? (variable-type v) nat) (eq? (variable-val v) 'Z)) #t)
        ((and (eq? (variable-type v) nat) (pair? (variable-val v)) (eq? (car (variable-val v)) 'S))
         (variable-typecheck (variable (cdr (variable-val v)) (variable-type v))))
        ((and (eq? (variable-type v) bool) (or (eq? (variable-val v) 'True)
                                               (eq? (variable-val v) 'False))) #t)
        (else #f)))

(define (judgment-check g v name)
  (let ([new-ctx (new-var-ctx g (ctx-entry name v))])
    (foldr (lambda (x acc) (and acc (variable-typecheck (ctx-entry-variable x)))) #t new-ctx)))

(judgment-check ctx (nat-s bool-intro-1) "test2") ; will not typecheck
(judgment-check ctx one-and-two "test")           ; will typecheck