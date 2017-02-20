#lang racket
(define dict (make-hash))
(define (dict-set key value) (hash-set! dict key value))
(define (dict-get key) (hash-ref dict key #f))

(define (serve port-no)
  (define listener (tcp-listen port-no 5 #t))
  (define (loop)
    (accept-and-handle listener)
    (loop))
  (define t (thread loop))
  (lambda ()
    (kill-thread t)
    (tcp-close listener)))

(define (accept-and-handle listener)
  (define-values (in out) (tcp-accept listener))
  (thread
   (lambda ()
     (file-stream-buffer-mode out 'none)
     (handle in out)
     (close-input-port in)
     (close-output-port out))))

(define (handle in out)
  (define line (read-line in))

  (if (not (eof-object? line))
      (let
          [(the-get (regexp-match #rx"^GET (.+)\r" line))
           (the-set (regexp-match #rx"^SET (.+?) (.+)\r" line))]
        
        (when the-get
          (display (dict-get (list-ref the-get 1)) out)
          (display "\r\n" out))
        
        (when the-set
          (begin
            (dict-set (list-ref the-set 1) (list-ref the-set 2))
            (display "OK\r\n" out)))
        
        (handle in out)) '()))

(serve 1234)