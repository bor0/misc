#lang racket
; Hygienic vs non hygienic macros in Scheme
; Reference: https://stackoverflow.com/questions/10968212/while-loop-macro-in-drracket

; Hygienic macros are macros whose expansion is guaranteed not to cause the accidental capture of identifiers.
(require mzlib/defmacro)

; A macro for testing our macros. :D
(define-syntax-rule (run-macro-test m)
  (begin
    (printf "Macro testing '~a': " (symbol->string (quote m)))
    (define x 0)
    (m (< x 3)
       (begin (display x)
              (set! x (+ x 1))))
    (newline)))

; This macro, while unreadable, makes things much more explicit in terms of execution and substitution.
(define-macro my-while
  (lambda (condition body)
    (list 'local (list (list 'define (list 'while-loop)
                             (list 'if condition
                                   (list 'begin body (list 'while-loop))
                                   '(void))))
          '(while-loop))))

(run-macro-test my-while)

; This macro, while much more readable, may make things more implicit in terms of execution and substitution.
(define-macro my-while-readable
  (lambda (condition body)
    `(local ((define (while-loop)
               (if ,condition
                   (begin ,body (while-loop))
                   (void))))
       (while-loop))))

(run-macro-test my-while-readable)

#|
1. Using the above style of while loop encourages excessive use of imperative programming.
2. Using define-macro creates unhygienic macros, which is a nightmare in Scheme.

While I don't encourage writing an imperative-style loop macro, for your reference, here's a non-define-macro version of the same macro.

It uses syntax-rules, which creates hygienic macros, and is much, much easier to read than what you have.
|#
(define-syntax-rule (my-while-hygienic condition body)
  (let loop ()
    (when condition
      body
      (loop))))

(run-macro-test my-while-hygienic)