#lang racket
(define-struct variable (name domain) #:prefab)
(define-struct constraint (variables formula) #:prefab)
(define-struct cpair (name value) #:prefab)

(define (get-all-pairs c)
  (letrec ([vars (constraint-variables c)]
           [varnames (map variable-name vars)]
           [tuples (apply cartesian-product (map variable-domain vars))])
    (map (lambda (x) (map cpair varnames x)) tuples)))

(define (eval-expr c)
  (match c
    [(? number? x) x]
    [(? string? x) x]
    [`() #t]
    [`true #t]
    [`false #f]
    [`(if ,co ,tr ,fa) (if (eval-expr co)
                           (eval-expr tr)
                           (eval-expr fa))]
    [`(+ ,l ,r) (+ (eval-expr l) (eval-expr r))]
    [`(+ ,l ,r) (+ (eval-expr l) (eval-expr r))]
    [`(* ,l ,r) (* (eval-expr l) (eval-expr r))]
    [`(- ,l ,r) (- (eval-expr l) (eval-expr r))]
    [`(= ,l ,r) (= (eval-expr l) (eval-expr r))]
    [`(!= ,l ,r) (not (= (eval-expr l) (eval-expr r)))]
    [`(> ,l ,r) (> (eval-expr l) (eval-expr r))]
    [`(< ,l ,r) (< (eval-expr l) (eval-expr r))]
    [`(and ,l) (eval-expr l)]
    [`(and ,l ,r) (and (eval-expr l) (eval-expr r))]
    [`(or ,l ,r) (or (eval-expr l) (eval-expr r))]
    [else #f]))

(define (subst x y expr)
  (cond ((null? expr) '())
        ((equal? x expr) y)
        ((not (pair? expr)) expr)
        (else (cons (subst x y (car expr))
                    (subst x y (cdr expr))))))

(define (test-pair f p)
  (cond ((eq? p '()) (eval-expr f))
        (else (let ([current-pair (car p)]
                    [remaining-pairs (cdr p)])
                (test-pair (subst (cpair-name current-pair)
                                  (cpair-value current-pair)
                                  f)
                           remaining-pairs)))))

; Bruteforce approach. Better implementation would be to use backtrack with partial eval.
; I.e. bruteforce corresponds to full evaluation of all combinations, and backtrack to partial evaluation
; E.g. we can partially evaluate the first group of `and` while skipping the remaining, etc.
(define (find-sat c)
  (define (go f ps)
    (cond ((null? ps) '())
          ((test-pair f (car ps)) (car ps))
          (else (go f (cdr ps)))))
  (letrec ([formula (constraint-formula c)]
           [pairs (get-all-pairs c)])
    (go formula pairs)))


#|
==================
| 1 |   || 3 |   |
|   | 4 || 2 | 1 |
------------------
|   |   ||   | 2 |
|   |   || 4 |   |
==================

==================
| a | b || e | f |
| c | d || g | h |
------------------
| i | j || m | n |
| k | l || o | p |
==================
|#

(define var-a (variable 'a '(1)))
(define var-b (variable 'b '(1 2 3 4)))
(define var-c (variable 'c '(1 2 3 4)))
(define var-d (variable 'd '(4)))

(define var-e (variable 'e '(3)))
(define var-f (variable 'f '(1 2 3 4)))
(define var-g (variable 'g '(2)))
(define var-h (variable 'h '(1)))

(define var-i (variable 'i '(1 2 3 4)))
(define var-j (variable 'j '(1 2 3 4)))
(define var-k (variable 'k '(1 2 3 4)))
(define var-l (variable 'l '(1 2 3 4)))

(define var-m (variable 'm '(1 2 3 4)))
(define var-n (variable 'n '(2)))
(define var-o (variable 'o '(4)))
(define var-p (variable 'p '(1 2 3 4)))

; Modeling the Sudoku solution in terms of summations
(define formulas
  ; boxes sum
  '(and (= (+ (+ a b) (+ c d)) 10)
    (and (= (+ (+ e f) (+ g h)) 10)
    (and (= (+ (+ i j) (+ k l)) 10)
    (and (= (+ (+ m n) (+ o p)) 10)
    ; vertical
    (and (= (+ (+ a c) (+ i k)) 10)
    (and (= (+ (+ b d) (+ j l)) 10)
    (and (= (+ (+ e g) (+ m o)) 10)
    (and (= (+ (+ f h) (+ n p)) 10)
    ; horizontal
    (and (= (+ (+ a b) (+ e f)) 10)
    (and (= (+ (+ c d) (+ g h)) 10)
    (and (= (+ (+ i j) (+ m n)) 10)
    (and (= (+ (+ k l) (+ o p)) 10))))))))))))))

(define con-1
  (constraint
   (list var-a var-b var-c var-d var-e var-f var-g var-h
         var-i var-j var-k var-l var-m var-n var-o var-p)
   formulas))

(find-sat con-1)
#|
; After a while, calling `(find-sat con-1)` will print:
'(#s(cpair a 1)
  #s(cpair b 2)
  #s(cpair c 3)
  #s(cpair d 4)
  #s(cpair e 3)
  #s(cpair f 4)
  #s(cpair g 2)
  #s(cpair h 1)
  #s(cpair i 4)
  #s(cpair j 3)
  #s(cpair k 2)
  #s(cpair l 1)
  #s(cpair m 1)
  #s(cpair n 2)
  #s(cpair o 4)
  #s(cpair p 3))

Thus the solution is
==================
| 1 | 2 || 3 | 4 |
| 3 | 4 || 2 | 1 |
------------------
| 4 | 3 || 1 | 2 |
| 2 | 1 || 4 | 3 |
==================

|#