#lang racket
(define (init-env)
  (define ht (make-hash))
  (hash-set! ht 'car (lambda (x) (car x)))
  (hash-set! ht 'cdr (lambda (x) (cdr x)))
  (hash-set! ht 'eq? (lambda (x y) (eq? x y)))
  (hash-set! ht 'equal? (lambda (x y) (equal? x y)))
  (hash-set! ht 'cons (lambda (x y) (cons x y)))
  (hash-set! ht 'list? (lambda (x) (list? x)))
  ht)

(define global-env (init-env))

(define (my-eval ast)
    (cond ((number? ast) ast)
          ;check env for atom (single retrieval of variable)
          ((and (symbol? ast) (hash-has-key? global-env ast)
                (apply (hash-ref global-env ast) '())))
          ;check env for atom
          ((hash-has-key? global-env (car ast))
           (apply (hash-ref global-env (car ast)) (map my-eval (cdr ast))))
          ;quote
          ((and (eq? (car ast) 'quote)) (cadr ast))
          ;lambda todo
          ((eq? (car ast) 'lambda) '())
          ;if
          ((eq? (car ast) 'if) (if (my-eval (cadr ast)) (my-eval (caddr ast)) (my-eval (cadddr ast))))
          ;define
          ((eq? (car ast) 'define) (hash-set! global-env (cadr ast) (lambda () (my-eval (caddr ast)))) (cadr ast))
          ;print with eval
          ((and (eq? (car ast) 'print) (list? (cadr ast))) (displayln (my-eval (cadr ast))))
          ;print atom
          ((eq? (car ast) 'print) (displayln (my-eval (cadr ast))))
          (else "undefined")))

(define (evaluate-string str) (my-eval (read (open-input-string str))))

#|
 <bor0> so it took me 38 lines of code to implement a lisp that has support for: car, cdr, eq?, equal?, cons, list?, if, define, quote, print
 <bor0> I did something similar a few years ago in PHP and it was a bit harder but I guess it has to do with the underlying structure of the programming language
 <bor0> I think I see why DSLs are much easier to do in a lisp (assuming my implementation doesn't cheat -- it doesn't use eval at all)
|#


;=== examples ===

(begin (evaluate-string "(define x (quote (1 2)))") (evaluate-string "(car x)"))
(my-eval '(car (quote (1 2))))
(my-eval '(quote (1 2)))
(my-eval '(define a 123))
(my-eval '(define b (car (quote (1 2)))))
(my-eval '(define c (quote (1 2))))
(my-eval '(print a))
(my-eval '(print b))
(my-eval '(print c))
(my-eval '(print (car (quote (1 2)))))
(my-eval '(define a 123))
(my-eval '(if (eq? a 1) 2 3))
(my-eval '(if (eq? a 123) 2 3))