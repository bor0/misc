#lang racket
(require compatibility/defmacro)
(require macro-debugger/expand)

(defmacro duplicate (list)
  (let ((result (gensym)))
    `(let ((,result ,list))
       (set! ,result (append ,result ,result))
    ,result)))

(define-syntax duplicatee
  (syntax-rules ()
    ((_ list)
     (let ((result list)) (set! result (append result result)) result))))

(define-syntax duplicateee
  (syntax-rules ()
    ((_ a)
     (append a a))))

(syntax->datum
 (expand-only #'(duplicate (1 2 3))
                (list #'duplicate)))

(syntax->datum
 (expand-only #'(duplicatee (1 2 3))
                (list #'duplicatee)))

(syntax->datum
 (expand-only #'(duplicateee (1 2 3))
                (list #'duplicateee)))