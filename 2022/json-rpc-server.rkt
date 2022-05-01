#lang racket
(require racket/exn)
(require json)

(define list '())

(define (append a b) (string-append a b))
(define (pop-list)
  (if (not (null? list))
      (let ([result (hash 'element (car list) 'remaining (cdr list))])
        (set! list (cdr list))
        result)
      #t))
(define (push-list value) (set! list (cons value list)) list)

(define *function-table*
  (hash "add" (lambda (a b) (+ a b))
        "append" append
        "push-list" push-list
        "pop-list" pop-list
        ))

#|
$ echo '{"method": "add", "params": [42], "id":1}' | nc localhost 1234
{"error":"...json-rpc-server.rkt:12:14: arity mismatch;\n the expected number of arguments does not match the given number\n  expected: 2\n  given: 1\n","id":1,"result":false}
$ echo '{"method": "add", "params": [42,], "id":2}' | nc localhost 1234
{"error":"string::33: string->jsexpr: bad input starting #\"], \\\"id\\\":2}\"\n","id":false,"result":false}
$ echo '{"method": "add", "params": [42,23], "id":3}' | nc localhost 1234
{"error":false,"id":3,"result":65}
$ echo '{"method": "append", "params": ["a","b"], "id": 4}' | nc localhost 1234
{"error":false,"id":4,"result":"ab"}
$ echo '{"method": "push-list", "params": [2], "id": 5}' | nc localhost 1234
{"error":false,"id":5,"result":[2]}
$ echo '{"method": "push-list", "params": [1], "id": 6}' | nc localhost 1234
{"error":false,"id":5,"result":[1,2]}
$ echo '{"method": "pop-list", "params": [], "id": 7}' | nc localhost 1234
{"error":false,"id":7,"result":{"element":1,"remaining":[2]}}
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; build a JSON response for error
(define (json-response-error id error) (jsexpr->string (hash 'result #f 'error error 'id id)))

; build a JSON response for success
(define (json-response id result) (jsexpr->string (hash 'result result 'error #f 'id id)))

; main handler with parsing, evaluating, error handling etc.
; an alternative, functional, handler would add two layers of error handling:
; one without id (when parsing fails) and one with id. this way we can avoid using `set!`
(define (handle in out)
  (let ([id #f]) ; set id to false, as an error might occur during parsing stage
    (parameterize ([error-print-context-length 0]) ; suppress stack trace
      ; add main exception handler
      (with-handlers
          ([exn:fail? (lambda (e) (displayln (json-response-error id (exn->string e)) out))])
        (let ([data (string->jsexpr (read-line in))])
          (set! id (hash-ref data 'id)) ; at this point we have the actual id
          (when data
            (displayln (json-response id (parse-and-evaluate data)) out)))))))

; given a json object, parse its arguments and evaluate data
(define (parse-and-evaluate data)
  (letrec
      ([raw-procedure (hash-ref data 'method)]
       [procedure (hash-ref *function-table* raw-procedure)]
       [params (hash-ref data 'params)])
    (apply procedure params)))

;the remainder of this source file are functions pasted from the Racket documentation
(define (accept-and-handle listener)
  (define cust (make-custodian))
  (parameterize ([current-custodian cust])
    (define-values (in out) (tcp-accept listener))
    (thread (lambda ()
              (handle in out)
              (close-input-port in)
              (close-output-port out))))
  (thread (lambda ()
            (sleep 10)
            (custodian-shutdown-all cust))))

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

(displayln "Listening on port 1234")
(serve 1234)
(letrec ([loop (lambda () (sleep 1) (loop))]) (loop))
