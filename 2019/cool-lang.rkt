#lang racket

(define (eval expr)
  (match expr
    [(list 'if 'T t2 t3) t2]
    [(list 'if 'F t2 t3) t3]
    [(list 'if t1 t2 t3) (list 'if (eval t1) t2 t3)]
    [(list 'succ t1) (cons 'succ (eval t1))]
    [(list 'pred 'O) 'O]
    [(list 'pred (list 'succ k)) k]
    [(list 'pred t1) (cons 'pred (eval t1))]
    [(list 'is-zero 'O) 'T]
    [(list 'is-zero (list 'succ t)) 'F]
    [(list 'is-zero t1) (cons 'is-zero (eval t1))]
    [_ error "No rule applies"]))

(define (type-of expr)
  (match expr
    ['T 'TBool]
    ['F 'TBool]
    ['O 'TNat]
    [(list 'if t1 t2 t3)
     (let ([t1t (type-of t1)]
           [t2t (type-of t2)]
           [t3t (type-of t3)])
       (if (eq? t2t t3t) t2t #f))]
    [(list 'succ t1)
     (let ([t1t (type-of t1)])
       (if (eq? t1t 'TNat) t1t #f))]
    [(list 'pred t1)
     (let ([t1t (type-of t1)])
       (if (eq? t1t 'TNat) t1t #f))]
    [(list 'is-zero t1)
     (let ([t1t (type-of t1)])
       (if (eq? t1t 'TNat) 'TBool #f))]))
