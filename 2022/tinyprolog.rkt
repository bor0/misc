#lang racket
(require racket/hash)

(define (is-variable sym) (string-prefix? (symbol->string sym) "?"))
(define (unify-single expr1 expr2) (unify-single-iter expr1 expr2 (hash)))
(define (unify-single-iter expr1 expr2 acc)
  (cond 
    ((or (null? expr1) (null? expr2)) acc) ; return if either list is empty
    ((not (eq? (length expr1) (length expr2))) #f) ; return if not equal length
    ((and (list? (car expr1)) (list? (car expr2))) ; list within list
     (unify-single-iter (cdr expr1)
                        (cdr expr2)
                        (hash-union acc (unify-single-iter (car expr1) (car expr2) acc)))) ; TODO: can same key conflict occur?
    ((equal? (car expr1) (car expr2)) (unify-single-iter (cdr expr1) (cdr expr2) acc)) ; same element keep iterating
    ((and (is-variable (car expr2))
          (or (not (hash-has-key? acc (car expr2))) (eq? (hash-ref acc (car expr2)) (car expr1)))) ; either var not in hash, or if in hash, same value
     (unify-single-iter (cdr expr1) (cdr expr2) (hash-set acc (car expr2) (car expr1)))) ; perform variable replacement
    (else #f)))

(define (unify ctx expr)
  (if (null? ctx) null
      (let ([unify-res (unify-single (car ctx) expr)])
        (if unify-res
            (cons unify-res (unify (cdr ctx) expr))
            (unify (cdr ctx) expr)))))

(define ctx '((boro sitnikovski programer)
              (dijana sitnikovska ekonomist)
              (zaklina sitnikovska dete)
              (hristijan sitnikovski dete)))

(unify-single '(x y z) '(x y z)) ; {}
(unify-single '(x y z) '(x ?y z)) ; {?y:y}
(unify-single '(w (x y) z) '(w ?xy y)) ; #f
(unify-single '(w (x y) z) '(w ?xy z)) ; {?xy:(x y)}
(unify-single '(w (x y) z) '(w (?x y) z)) ; {?x:x}
(unify-single '(w x y z) '(w ?x ?x z)) ; #f
(unify-single '(w x x z) '(w ?x ?x z)) ; {?x:x}

(unify ctx '(?x ?y programer)) ; boro
(unify ctx '(?x ?y dete)) ; zaki, kiko
(unify ctx '(?x ?y ekonomist)) ; diksi
(unify ctx '(?x sitnikovski ?y)) ; boro kiko
(unify ctx '(?x sitnikovska ?y)) ; zaki diksi

