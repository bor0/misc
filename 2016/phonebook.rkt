#lang racket
(require (planet dmac/spin))

(define dict (make-hash))
(define (dict-set-xx key value) (if (hash-has-key? dict key) (begin (hash-set! dict key value) value) #f))
(define (dict-set-nx key value) (if (hash-has-key? dict key) #f (begin (hash-set! dict key value) value)))
(define (dict-get key) (hash-ref dict key #f))
(define (dict-remove key) (if (hash-has-key? dict key) (hash-remove! dict key) #f))

(define (square n) (* n n))

(get "/"
     (lambda () "Hello!"))

(get "/square/:number"
     (lambda (req)
       (let ((number (string->number (params req 'number))))
         (if (eq? number #f) "Error" (number->string (square number))))))

(get "/:name"
     (lambda (req)
       (let ((retval (dict-get (params req 'name))))
         (if (eq? retval #f) "Error" retval))))

(put "/:name/:phone"
     (lambda (req)
       (let ((retval (dict-set-xx (params req 'name) (params req 'phone))))
         (if (eq? retval #f) "Error" retval))))

(post "/"
      (lambda (req)
        (let ((retval (dict-set-nx (params req 'name) (params req 'phone))))
          (if (eq? retval #f) "Error" retval))))

(delete "/:name"
        (lambda (req)
          (let ((retval (dict-remove (params req 'name))))
            (if (eq? retval #f) "Error" "OK"))))

(run)