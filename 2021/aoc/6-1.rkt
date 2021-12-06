#lang racket

(define (read-numbers)
  (begin
    (define numbers "")
    (for ([line (file->lines "input")])
      (set! numbers line))
    (map string->number (string-split numbers ","))))

(define (populate l)
  (foldr (lambda (elem acc) (if (eq? elem 0) (cons 6 (cons 8 acc)) (cons (- elem 1) acc))) '() l))

(define (go n l)
  (cond ((eq? n 0) l)
        (else (go (- n 1) (populate l)))))

(displayln (length (go 80 (read-numbers))))