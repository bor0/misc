#lang racket
(define database (make-hash))

(define (accept-and-handle listener)
  (define cust (make-custodian))
  (parameterize ([current-custodian cust])
    (define-values (in out) (tcp-accept listener))
    (thread (lambda ()
              (handle in out)
              (close-input-port in)
              (close-output-port out)))))

(define (serve port-no)
  (define main-cust (make-custodian))
  (parameterize ([current-custodian main-cust])
    (define listener (tcp-listen port-no 5 #t))
    (define (loop)
      (accept-and-handle listener)
      (loop))
    (thread loop))
  (lambda ()
    (custodian-shutdown-all main-cust)))

(define (parse-string s)
  (match (string-replace s #rx"([\r\n]+)" "")
    [(regexp #rx"^get (.*)?" (list _ key)) (list 'get key)]
    [(regexp #rx"^set ([^ ]*)? (.*)?" (list _ key val)) (list 'set key val)]
    [(regexp #rx"^unset (.*)?" (list _ key)) (list 'unset key)]
    [_ '()]))

(define (eval-command expr)
  (match expr
    [(list 'get key)
     (hash-ref! database key "null")]
    [(list 'set key val)
     (begin
       (hash-set! database key val)
       key)]
    [(list 'unset key)
     (begin
       (hash-remove! database key)
       key)]
    [_ #f]))

(define (handle in out)
  (flush-output out)
  (define line (read-line in))
  (when (string? line)
    (let ([parsed-string (parse-string line)])
      (when (pair? parsed-string)
        (displayln (eval-command parsed-string) out)))
    (handle in out)))

(define stop (serve 8081))
