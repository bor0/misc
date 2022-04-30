#lang racket
(require json)

(define list '())

(define (append a b) (string-append a b))
(define (get-list) list)
(define (add-list value) (set! list (cons value list)) #t)

(define *function-table*
  (hash "add" (lambda (a b) (+ a b))
        "append" append
        "get-list" get-list
        "add-list" add-list
        ))

#|
$ echo '{"method": "add", "params": [42], "id":1}' | nc localhost 1234
{"error":"error occurred","id":1,"result":false}
$ echo '{"method": "add", "params": [42,], "id":2}' | nc localhost 1234
{"error":"can't parse json","id":false,"result":false}
$ echo '{"method": "add", "params": [42,23], "id":3}' | nc localhost 1234
{"error":false,"id":3,"result":65}
$ echo '{"method": "append", "params": ["a","b"], "id": 4}' | nc localhost 1234
{"error":false,"id":4,"result":"ab"}
$ echo '{"method": "get-list", "params": [], "id": 5}' | nc localhost 1234
{"error":false,"id":5,"result":[]}
$ echo '{"method": "add-list", "params": [2], "id": 6}' | nc localhost 1234
{"error":false,"id":6,"result":true}
$ echo '{"method": "add-list", "params": [1], "id": 7}' | nc localhost 1234
{"error":false,"id":7,"result":true}
$ echo '{"method": "get-list", "params": [], "id": 8}' | nc localhost 1234
{"error":false,"id":8,"result":[1,2]}
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; build a JSON response for error
(define (json-response-error error [id #f]) (jsexpr->string (hash 'result #f 'error error 'id id)))

; build a JSON response for success
(define (json-response id result) (jsexpr->string (hash 'result result 'error #f 'id id)))

; main handler with parsing, evaluating, error handling etc.
(define (handle in out)
  ; these handlers handle the case where a JSON parse error occurs, in which case we have no id
  (with-handlers ([exn:fail:read? (lambda (x) (displayln x) (displayln (json-response-error "can't parse json") out))]
                  [exn:fail? (lambda (x) (displayln x) (displayln (json-response-error "error occurred") out))])
    (define req (string->jsexpr (read-line in)))
    (define id (hash-ref req 'id))
    ; these handlers will return an error that contain the id since we're able to parse everything up until this point
    (with-handlers ([exn:fail? (lambda (x) (displayln x) (displayln (json-response-error "error occurred" id) out))])
      (when req
        (letrec ([raw-procedure (hash-ref req 'method)]
                 [procedure (hash-ref *function-table* raw-procedure)]
                 [params (hash-ref req 'params)]
                 [result (apply procedure params)])
          (displayln (json-response id result) out))))))

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