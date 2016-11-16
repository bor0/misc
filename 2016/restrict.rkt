#lang racket
(define (contains item list)
  (cond ((eq? list '()) #f)
        ((= (car list) item) #t)
        (else (contains item (cdr list)))))

; https://en.wikipedia.org/wiki/Restriction_(mathematics)
(define (restrict pairs set)
  (filter (lambda (x) (contains (car x) set)) pairs))

(restrict (list (cons 1 2) (cons 3 4) (cons 4 5)) '())
(restrict (list (cons 1 2) (cons 3 4) (cons 4 5)) '(3))
(restrict (list (cons 1 2) (cons 3 4) (cons 4 5)) '(3 4))
