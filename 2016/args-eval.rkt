#lang racket
; All arguments are evaluated
(begin (display "Function") (newline))
(define (my-if a b c) (if a b c))

(my-if #t (print 1) (print 2))
(newline)
(my-if #f (print 1) (print 2))
(newline)

; Arguments are lazily evaluated within macros
(begin (display "Macro") (newline))
(define-syntax my-if-2
  (syntax-rules ()
    ((_ a b c) (if a b c))))

(my-if-2 #t (print 1) (print 2))
(newline)
(my-if-2 #f (print 1) (print 2))
(newline)

; Hacky approach, implement lazy-call where the function to be called is passed rather than the actual call
(begin (display "Hacky lazy-call") (newline))
(define (lazy-call f ...) (lambda () (f ...)))
(define (my-if-3 a b c) (if a (b) (c)))

(my-if-3 #t (lazy-call print 1) (lazy-call print 2))
(newline)
(my-if-3 #f (lazy-call print 1) (lazy-call print 2))
(newline)
