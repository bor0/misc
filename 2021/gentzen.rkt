#lang racket

#| Gentzen |#
; Helpers
(define (apply-prop-rule path rule formula)
  (match formula
    [`(proof ,x) `(proof ,(apply-prop-rule-go path rule x))]))
(define (apply-prop-rule-go path rule formula)
  (match* (path formula)
    [((cons _ paths) `(not ,x)) `(not ,(apply-prop-rule-go paths rule x))]
    [((cons 'l paths) `(and ,x ,y)) `(and ,(apply-prop-rule-go paths rule x) ,y)]
    [((cons 'l paths) `(or ,x ,y)) `(or ,(apply-prop-rule-go paths rule x) ,y)]
    [((cons 'l paths) `(imp ,x ,y)) `(imp ,(apply-prop-rule-go paths rule x) ,y)]
    [((cons 'r paths) `(and ,x ,y)) `(and ,x ,(apply-prop-rule-go paths rule y))]
    [((cons 'r paths) `(or ,x ,y)) `(or ,x ,(apply-prop-rule-go paths rule y))]
    [((cons 'r paths) `(imp ,x ,y)) `(imp ,x ,(apply-prop-rule-go paths rule y))]
    [(_ _) (cadr (rule `(proof ,formula)))]))

; Rules
(define (rule-join x y)
  (match* (x y)
    [(`(proof ,x) `(proof ,y)) `(proof (and ,x ,y))]
    [(_ _) #f]))
(define (rule-sep-l x)
  (match x
    [`(proof (and ,x ,y)) `(proof ,x)]
    [else #f]))
(define (rule-sep-r x)
  (match x
    [`(proof (and ,x ,y)) `(proof ,y)]
    [else #f]))
(define (rule-double-tilde-intro x)
  (match x
    [`(proof ,x) `(proof (not (not ,x)))]
    [else #f]))
(define (rule-double-tilde-elim x)
  (match x
    [`(proof (not (not ,x))) `(proof ,x)]
    [else #f]))
(define (rule-fantasy x f)
  (let [(prf (f `(proof ,x)))]
    (when prf `(proof (imp ,x ,(cadr prf))))))
(define (rule-detachment x y)
  (match* (x y)
    [(`(proof ,x) `(proof (imp ,y ,z)))
     #:when (equal? x y)
     `(proof ,z)]
    [(_ _) #f]))
(define (rule-contra x)
  (match x
    [`(proof (imp (not ,x) (not ,y))) `(proof (imp ,y ,x))]
    [`(proof (imp ,x ,y)) `(proof (imp (not ,y) (not ,x)))]
    [else #f]))
(define (rule-de-morgan x)
  (match x
    [`(proof (and (not ,x) (not ,y))) `(proof (not (or ,x ,y)))]
    [`(proof (not (or ,x ,y))) `(proof (and (not ,x) (not ,y)))]
    [else #f]))
(define (rule-switcheroo x)
  (match x
    [`(proof (or ,x ,y)) `(proof (imp (not ,x) ,y))]
    [`(proof (imp (not ,x) ,y)) `(proof (or ,x ,y))]
    [else #f]))

#| Examples |#
(define s1prf1 (rule-fantasy 'x identity))
(define s1prf9
  (rule-fantasy
   '(and x y)
   (lambda (premise) (rule-join (rule-sep-r premise) (rule-sep-l premise)))))
(define s2prf1
  (rule-fantasy
   '(and x (imp x y))
   (lambda (premise)
     (let ([prfx (rule-sep-l premise)]
           [prfxtoy (rule-sep-r premise)])
       (rule-detachment prfx prfxtoy)))))
(define s1lemma1
  (rule-fantasy
   '(not (imp x y))
   (lambda (premise)
     (letrec ([step1 (apply-prop-rule '(l l) rule-double-tilde-intro premise)]
              [step2 (apply-prop-rule '(l) rule-switcheroo step1)]
              [step3 (rule-de-morgan step2)])
       (apply-prop-rule '(l) rule-double-tilde-elim step3)))))
(define s3lemma2
  (rule-fantasy
   '(or x y)
   (lambda (premise)
     (letrec ([step1 (rule-switcheroo premise)]
              [step2 (rule-contra step1)]
              [step3 (rule-switcheroo step2)])
       (apply-prop-rule '(r) rule-double-tilde-elim step3)))))

(define (gentzen-example)
  (for ([thm (list s1prf1 s1prf9 s2prf1 s1lemma1 s3lemma2)])
    (displayln thm)))

(provide
 apply-prop-rule
 rule-join
 rule-sep-l
 rule-sep-r
 rule-double-tilde-intro
 rule-double-tilde-elim
 rule-fantasy
 rule-detachment
 rule-contra
 rule-de-morgan
 rule-switcheroo
 gentzen-example)
