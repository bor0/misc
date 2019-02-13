#lang racket

(define (calculate amt coins)
  (cond ((null? coins) coins)
        ((<= (car coins) amt) (cons (car coins) (calculate (- amt (car coins)) coins)))
        (else (calculate amt (cdr coins)))))

(displayln (calculate 15 '(4 1))) ; ==> '(4 4 4 1 1 1)
(displayln (calculate 17 '(5 7))) ; ==> '(5 5 7), not '(5 5 5)

(define (can-change? amt coins)
  (cond ((zero? amt) #t)
        ((or (negative? amt) (null? coins)) #f)
        (else (let ([option1 (can-change? (- amt (car coins)) coins)]
                    [option2 (can-change? amt (cdr coins))])
                (or option1 option2)))))

(can-change? 17 '(5 7))
(can-change? 17 '(7))

(define (calculate-2 amt coins) '()) ; todo

(displayln (calculate-2 15 '(4 1))) ; ==> '(4 4 4 1 1 1)
(displayln (calculate-2 17 '(5 7))) ; ==> '(5 5 7)