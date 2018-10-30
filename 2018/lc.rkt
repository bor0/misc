#lang racket

; Constructors
(define (lambda-expr? e)
  (and (pair? e)
       (equal? (car e) 'λ)
       (equal? (caddr e) '→)))

(define (make-lambda argn argv) (list 'λ argn '→ argv))
(define (lambda-param e) (cadr e))
(define (lambda-body e) (cadddr e))

; Substitution procedures
(define (lambda-subst e src dst)
  (cond ((equal? e src) dst)
        ((lambda-expr? e) (if (eq? (lambda-param e) src)
                              e ; If this lambda expression has a param name same as src, do not substitute
                              ; Otherwise, construct a new lambda with this param and substitute src to dst in the lambda body
                              (make-lambda (lambda-param e) (lambda-subst (lambda-body e) src dst))))
        ; If it's a list of expressions recursively substitute them
        ((pair? e) (cons (lambda-subst (car e) src dst)
                         (lambda-subst (cdr e) src dst)))
        (else e)))

; Evaluation procedures
(define (can-beta-reduce? e)
  (and (pair? e)
       ; If the first parameter in the list is a lambda expression, or the first parameter can also be reduced
       ;(or (lambda-expr? (car e)) (can-beta-reduce? (car e)))
       (lambda-expr? (car e))
       ; And there is a second value in the list (to apply to the lambda expr)
       (pair? (cdr e))))

(define (beta-reduce e . vs)
  (if (and (pair? vs) (lambda-expr? e))
      ; Substitute current value in lambda-body and recursively reduce the remaining values
      (apply beta-reduce
             (lambda-subst (lambda-body e) (lambda-param e) (car vs))
             (cdr vs))
      ; No values, so just return the expression
      e))

(define (lambda-eval e)
  (cond ((can-beta-reduce? e) (lambda-eval (apply beta-reduce e)))
        ((pair? e) (let ([new-e (cons (lambda-eval (car e))
                                      (lambda-eval (cdr e)))])
                     (if (can-beta-reduce? new-e)
                         (lambda-eval new-e)
                         new-e)))
        (else e)))


; Example
(define zero (make-lambda 'f (make-lambda 'x 'x)))
(define one (make-lambda 'f (make-lambda 'x '(f x))))
(define two (make-lambda 'f (make-lambda 'x '(f (f x)))))

(define succ (make-lambda 'n (make-lambda 'f (make-lambda 'x '(f (n f x))))))
(define plus (make-lambda 'm (make-lambda 'n (make-lambda 'f (make-lambda 'x '(m f (n f x)))))))
(define mult (make-lambda 'm (make-lambda 'n (make-lambda 'f '(m (n f))))))
(define pow (make-lambda 'b (make-lambda 'e '(e b))))

(and
 (equal? one (lambda-eval (list succ zero)))
 (equal? two (lambda-eval (list succ one)))
 (equal? two (lambda-eval (list plus one one)))
 (equal? zero (lambda-eval (list mult zero one)))
 (equal? one (lambda-eval (list mult one one)))
 (equal? two (lambda-eval (list mult one two))))

(equal? two (lambda-eval (list pow two one))) ; ???

(define true (make-lambda 'x (make-lambda 'y 'x)))
(define false (make-lambda 'x (make-lambda 'y 'y)))

(define l-and (make-lambda 'p (make-lambda 'q '(p q p))))
(define l-or (make-lambda 'p (make-lambda 'q '(p p q))))
(define l-not (make-lambda 'p (list 'p false true)))

(and
 (equal? (lambda-eval (list l-and false false)) false)
 (equal? (lambda-eval (list l-and false true)) false)
 (equal? (lambda-eval (list l-and true false)) false)
 (equal? (lambda-eval (list l-and true true)) true)

 (equal? (lambda-eval (list l-or false false)) false)
 (equal? (lambda-eval (list l-or false true)) true)
 (equal? (lambda-eval (list l-or true false)) true)
 (equal? (lambda-eval (list l-or true true)) true)
 
 (equal? (lambda-eval (list l-not true)) false)
 (equal? (lambda-eval (list l-not false)) true))