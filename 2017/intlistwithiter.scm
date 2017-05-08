; right assoc
; (cons x (cons 3 '()))
; (cons x (cons 2 (cons 3 '())))
; (cons 1 (cons 2 (cons 3 '())))
;
; vs
;
; left assoc
; (cons 3 x)
; (cons 3 (cons 2 x))
; (cons 3 (cons 2 (cons 1 '())))

(define (list->number l)
  (if (eq? l '())
    0
    (+ 
       (* 10 (list->number (cdr l)))
       (car l))))

(define (list->number-iter l acc)
  (if (eq? l '())
    acc
    (list->number-iter
      (cdr l)
      (+ (* 10 acc) (car l)))))

(define (number->list l)
  (if (= l 0)
    '()
    (cons
       (remainder l 10)
       (number->list (quotient l 10)))))

(define (number->list-iter l acc)
  (if (= l 0)
    acc
    (number->list-iter
      (quotient l 10)
      (cons (remainder l 10) acc))))

(display (list->number '(1 2 3)))
(newline)
(display (list->number-iter '(1 2 3) 0))
(newline)

(display (number->list 123))
(newline)
(display (number->list-iter 123 '()))
(newline)
