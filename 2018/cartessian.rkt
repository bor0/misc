#lang racket

(define (cartessian a b)
  (define n-a a)
  (define (cartessian-helper a b c)
    (cond ((and (zero? a) (not (zero? b))) (cartessian-helper n-a (- b 1) c))
          ((zero? b) c)
          (else (cartessian-helper (- a 1) b (cons (cons b a) c)))))
  (cartessian-helper a b '()))

(define (cartessian-map a b)
  (foldl append '() (map (lambda (a)
                           (map (lambda (b) (cons a b))
                                (range 1 (+ b 1))))
                         (reverse (range 1 (+ a 1))))))

(cartessian 3 3)
(cartessian-map 3 3)
