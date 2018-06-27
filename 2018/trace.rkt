#lang racket
(require racket/trace)

(define (f x) (if (zero? x) 0 (add1 (f (sub1 x)))))
(trace f)
(f 10)
(untrace f)