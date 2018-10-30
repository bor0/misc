#lang racket
; Note how `and` and `or` can be defined in terms of `cond`:
(define (my-and x y) ; chained conds
  (cond (x (cond (y y)
                 (else #f)))
        (else #f)))

(define (my-or x y) ; separate cases
  (cond (x x)
        (else y)))

; Here are more generic `my-and` and `my-or` which accept a variable number of arguments, but the structure explained above is a bit implicit:
(define (my-and-2 . x)
  (cond ((null? x) #t)
        ((null? (cdr x)) (car x))
        (else (apply my-and-2 (cdr x)))))

(define (my-or-2 . x)
  (cond ((null? x) #f)
        ((car x) (car x))
        (else (apply my-or-2 (cdr x)))))

(for* ([i '(#t #f)]
       [j '(#t #f)])
  (printf "AND\t~a ~a: ~a\n" i j (my-and i j))
  (printf "OR\t~a ~a: ~a\n" i j (my-or i j)))

(for* ([i '(#t #f)]
       [j '(#t #f)]
       [k '(#t #f)])
  (printf "AND\t~a ~a ~a: ~a\n" i j k (my-and-2 i j k))
  (printf "OR\t~a ~a ~a: ~a\n" i j k (my-or-2 i j k)))

(for* ([i '(#t #f)]
       [j '(#t #f)])
  (printf "AND\t~a ~a: ~a\n" i j (my-and i j))
  (printf "OR\t~a ~a: ~a\n" i j (my-or i j)))

(for* ([i '(1 #t)]
       [j '(2 #f)])
  (printf "AND\t~a ~a: ~a\n" i j (my-and i j))
  (printf "OR\t~a ~a: ~a\n" i j (my-or i j))
  (printf "AND\t~a ~a: ~a\n" i j (my-and-2 i j))
  (printf "OR\t~a ~a: ~a\n" i j (my-or-2 i j)))
