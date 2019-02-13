#lang racket
(struct type (left operator right) #:transparent)

(define (type-check e t)
  (cond ((and (eq? t 'string) (string? e)) #t)
        ((and (eq? t 'expr) (pair? e)) #t)
        ((and (eq? t 'number) (number? e)) #t)
        ((and (type? t) (pair? e) (eq? (type-operator t) 'and))
         (and (type-check (car e) (type-left t))
              (type-check (cadr e) (type-right t))))
        ((and (type? t) (pair? e) (eq? (type-operator t) 'or))
         (or (type-check (car e) (type-left t))
             (type-check (car e) (type-right t))
             (type-check (cdr e) (type-left t))
             (type-check (cdr e) (type-right t))))
        ((and (type? t) (eq? (type-operator t) 'or))
         (or (type-check e (type-left t))
             (type-check e (type-right t))))
        (else #f)))

(define (tests)
  (define type-1 (type (type 'string 'or 'number) 'and 'string))
  (define type-2 (type (type 'string 'and 'number) 'and 'string))
  (define type-3 (type (type 'string 'and 'number) 'or (type 'number 'and 'string)))
  (define type-4 (type (type 'string 'and 'string) 'or (type 'number 'and 'number)))

  (and
   (eq? #t (type-check '("hi" "hi") type-1))
   (eq? #t (type-check '(1 "hi") type-1))

   (eq? #t (type-check '(("hi" 1) "hi") type-2))
   (eq? #f (type-check '(("hi" 1) 1) type-2))

   (eq? #t (type-check '(("hi" 1) ("hi" 1)) type-3))
   (eq? #t (type-check '(("hi" 1) (1 "hi")) type-3))
   (eq? #t (type-check '(("hi" 1)) type-3))

   (eq? #t (type-check '(("hi" "hi")) type-4))
   (eq? #t (type-check '((1 1)) type-4))
   (eq? #f (type-check '(("hi" 1)) type-4))
   (eq? #f (type-check '((1 "hi")) type-4))))