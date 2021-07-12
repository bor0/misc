#lang racket
(require "gentzen.rkt")

#| TNT |#
; Helpers
(define (subst-arith x v e)
  (match x
    [`(s ,x) `(s ,(subst-arith x v e))]
    [`(plus ,x ,y) `(plus ,(subst-arith x v e) ,(subst-arith y v e))]
    [`(mult ,x ,y) `(mult ,(subst-arith x v e) ,(subst-arith y v e))]
    [x
     #:when (equal? x v)
     e]
    [_ x]))

(define (subst-propcalc x v e)
  (match x
    [`(proof ,x) `(proof ,(subst-propcalc-go x v e))]))
(define (subst-propcalc-go x v e)
  (match x
    [`(eq ,x ,y) `(eq ,(subst-arith x v e) ,(subst-arith y v e))]
    [`(forall ,x ,y) `(forall ,x ,(subst-propcalc-go y v e))]
    [`(exists ,x ,y) `(exists ,x ,(subst-propcalc-go y v e))]
    [`(not ,x) `(not ,(subst-propcalc-go x v e))]
    [`(and ,x ,y) `(and ,(subst-propcalc-go x v e) ,(subst-propcalc-go y v e))]
    [`(or ,x ,y) `(or ,(subst-propcalc-go x v e) ,(subst-propcalc-go y v e))]
    [`(imp ,x ,y) `(imp ,(subst-propcalc-go x v e) ,(subst-propcalc-go y v e))]    
    [_ x]))

(define (get-arith-vars x)
  (remove-duplicates (get-arith-vars-go x)))
(define (get-arith-vars-go x)
  (match x
    [(? symbol? x) #:when (not (equal? x 'z)) (list x)]
    [`(s ,x) (get-arith-vars x)]
    [`(plus ,x ,y) (append (get-arith-vars x) (get-arith-vars y))]
    [`(mult ,x ,y) (append (get-arith-vars x) (get-arith-vars y))]
    [_ '()]))

(define (get-bound-vars x)
  (remove-duplicates (get-bound-vars-go x)))
(define (get-bound-vars-go x)
  (match x
    [`(forall ,x ,y) (cons x (get-bound-vars-go y))]
    [`(exists ,x ,y) (cons x (get-bound-vars-go y))]
    [_ '()]))

(define (get-vars x)
  (remove-duplicates (get-vars-go x)))
(define (get-vars-go x)
  (match x
    [`(eq ,x ,y) (append (get-arith-vars x) (get-arith-vars y))]
    [`(forall ,x ,y) (get-vars-go y)]
    [`(exists ,x ,y) (get-vars-go y)]
    [`(not ,x) (get-vars-go x)]
    [`(and ,x ,y) (append (get-vars-go x) (get-vars-go y))]
    [`(or ,x ,y) (append (get-vars-go x) (get-vars-go y))]
    [`(imp ,x ,y) (append (get-vars-go x) (get-vars-go y))]))

(define (get-free-vars x)
  (set-subtract (get-vars x) (get-bound-vars x)))

(define (from-proof x)
  (match x
    [`(proof ,x) x]
    [_ #f]))

; Axioms
(define (axiom-1 x) `(proof (forall ,x (not (eq (s ,x) z)))))
(define (axiom-2 x) `(proof (forall ,x (eq (plus ,x z) ,x))))
(define (axiom-3 x y) `(proof (forall ,x (forall ,y (eq (plus ,x (s ,y)) (s (plus ,x ,y)))))))
(define (axiom-4 x) `(proof (forall ,x (eq (mult ,x z) z))))
(define (axiom-5 x y) `(proof (forall ,x (forall ,y (eq (mult ,x (s ,y)) (plus (mult ,x ,y) ,x))))))

; Rules
(define (rule-spec e y)
  (match y
    [`(proof (forall ,x ,y))
     #:when (empty? (set-intersect (get-arith-vars e) (get-bound-vars y)))
     (subst-propcalc `(proof ,y) x e)]
    [_ #f]))
(define (rule-generalize x premises y)
  (match y
    [`(proof ,y)
     #:when (and (false? (member x (get-bound-vars y)))
                 (false? (member x (append-map (compose get-free-vars from-proof) premises))))
     `(proof (forall ,x ,y))]
    [_ #f]))
(define (rule-interchange-l x)
  (match x
    [`(proof (forall ,x (not ,y))) `(proof (not (exists ,x ,y)))]
    [_ #f]))
(define (rule-interchange-r x)
  (match x
    [`(proof (not (exists ,x ,y))) `(proof (forall ,x (not ,y)))]
    [_ #f]))
(define rule-existence 'todo)
(define (rule-symmetry x)
  (match x
    [`(proof (eq ,x ,y)) `(proof (eq ,y ,x))]
    [_ #f]))
(define (rule-transitivity x y)
  (match* (x y)
    [(`(proof (eq ,x1 ,y1)) `(proof (eq ,x2 ,y2)))
     #:when (equal? y1 x2)
     `(proof (and ,x1 ,y2))]
    [(_ _) #f]))
(define (rule-add-s x)
  (match x
    [`(proof (eq ,x ,y)) `(proof (eq (s ,x) (s ,y)))]
    [_ #f]))
(define (rule-drop-s x)
  (match x
    [`(proof (eq (s ,x) (s ,y))) `(proof (eq ,x ,y))]
    [_ #f]))
(define (rule-induction x y)
  (match* (x y)
    [(`,base `(forall ,x (imp ,y ,z)))
     #:when (and (equal? base (subst-propcalc `(proof ,y) x 'z))
                 (equal? `(proof ,z) (subst-propcalc `(proof ,y) x `(s ,x))))
     `(proof (forall ,x ,y))]
    [(_ _) #f]))

(rule-induction '(proof (eq z (plus z z))) '(forall a (imp (eq a (plus z a)) (eq (s a) (plus z (s a))))))
(define base '(proof (eq z (plus z z))))
(define x 'a)
(define y '(eq a (plus z a)))
(define z '(eq (s a) (plus z (s a))))
