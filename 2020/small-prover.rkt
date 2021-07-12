#lang racket
(define zero 'z)
(define (succ x) (list 's x))

(define (add-1 a) (list '= (list '+ a zero) a))
(define (add-2 a b) (list '= (list '+ a (succ b)) (succ (list '+ a b))))

(define (eq-refl a) (list '= a a))
(define (eq-left a) (cadr a))
(define (eq-right a) (caddr a))

(define (subst x y expr)
  (cond ((null? expr) '())
        ((equal? x expr) y)
        ((not (pair? expr)) expr)
        (else (cons (subst x y (car expr))
                    (subst x y (cdr expr))))))

(define (rewrite-left eq1 eq2)
  (subst (eq-left eq1) (eq-right eq1) eq2))

(define (rewrite-right eq1 eq2)
  (subst (eq-right eq1) (eq-left eq1) eq2))

(define (valid-theorem? theorem)
  (and (equal? theorem (eq-refl (eq-left theorem)))
       (equal? theorem (eq-refl (eq-right theorem)))))

(define (display-theorem theorem)
  (display theorem)
  (display ", ")
  (display (valid-theorem? theorem))
  (newline))

(define theorem '(= (+ a (s z)) (s a)))
(display-theorem theorem)

(define step1 (rewrite-left (add-2 'a zero) theorem))
(display-theorem step1)

(define step2 (rewrite-left (add-1 'a) step1))
(display-theorem step2)