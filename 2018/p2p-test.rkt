#lang racket
(require racket/serialize)

(define (string-starts-with str1 str2)
  (let ([str1len (string-length str1)]
        [str2len (string-length str2)])
    (equal? str2 (substring str1 0 (min str2len str1len)))))

(serializable-struct peer-info (ip port) #:transparent)

(serializable-struct peer (ip port input-port output-port) #:transparent)

(struct peer-context-data (name port valid-peers [connected-peers #:mutable] [latest-hash #:mutable]) #:transparent)

(define (peer-to-peer-info p) (peer-info (peer-ip p) (peer-port p)))

(define (maybe-update-hash peer-context line)
  (let ([current-hash (string->number (string-replace line #rx"(latest-hash:|[\r\n]+)" ""))]
        [latest-hash (peer-context-data-latest-hash peer-context)])
    (when (and (number? current-hash) (> current-hash latest-hash))
      (displayln "hash updated")
      (set-peer-context-data-latest-hash! peer-context current-hash))))

#| Generic handlers for both client and server |#
; Handler
(define (handler peer-context in out)
  (flush-output out)
  (define line (read-line in))
  (when (string? line) ; it can be eof
    (cond [(string-starts-with line "get-valid-peers")
           (begin (displayln (serialize (peer-context-data-valid-peers peer-context)) out) (handler peer-context in out))]
          [(string-starts-with line "get-connected-peers")
           (begin (displayln (serialize (map peer-to-peer-info (peer-context-data-connected-peers peer-context))) out) (handler peer-context in out))]
          [(string-starts-with line "get-latest-hash")
           (begin (display "latest-hash:" out) (displayln (peer-context-data-latest-hash peer-context) out) (handler peer-context in out))]
          [(string-starts-with line "latest-hash:")
           (begin (maybe-update-hash peer-context line) (handler peer-context in out))]
          [(string-starts-with line "exit")
           (displayln "bye" out)]
          [else (handler peer-context in out)])))

; Helper to launch handler thread
(define (launch-handler-thread handler peer-context in out)
  (define-values (local-ip local-port remote-ip remote-port) (tcp-addresses in #t))
  (define current-peer (peer remote-ip remote-port in out))
  (thread
   (lambda ()
     ;TODO
     (hash-set! (peer-context-data-valid-peers peer-context) (peer-info remote-ip local-port) #t)
     (set-peer-context-data-connected-peers! peer-context (cons current-peer (peer-context-data-connected-peers peer-context)))
     (handler peer-context in out)
     (set-peer-context-data-connected-peers! peer-context (set-remove
                                                        (peer-context-data-connected-peers peer-context)
                                                        current-peer))
     (close-input-port in)
     (close-output-port out))))

; Ping all peers in attempt to sync hashes
(define (peers peer-context)
  (define (loop)
    (sleep 10)
    (for [(p (peer-context-data-connected-peers peer-context))]
      (let ([in (peer-input-port p)]
            [out (peer-output-port p)])
        (displayln "get-latest-hash" out)
        (flush-output out)))
    (loop))
  (define t (thread loop))
  (lambda ()
    (kill-thread t)))
#| Generic handlers for both client and server |#

#| Generic procedures for server |#
; Accept of a new connection
(define (accept-and-handle listener handler peer-context)
  (define-values (in out) (tcp-accept listener))
  (launch-handler-thread handler peer-context in out))

; Server listener
(define (serve peer-context)
  (define main-cust (make-custodian))
  (parameterize ([current-custodian main-cust])
    (define listener (tcp-listen (peer-context-data-port peer-context) 5 #t))
    (define (loop)
      (accept-and-handle listener handler peer-context)
      (loop))
    (thread loop))
  (lambda ()
    (custodian-shutdown-all main-cust)))
#| Generic procedures for server |#

#| Generic procedures for client |#
; Make sure we're connected with all known peers
(define (connections-loop peer-context)
  (define conns-cust (make-custodian))
  (parameterize ([current-custodian conns-cust])
    (define (loop)
      (letrec ([current-connected-ips (map (lambda (p) (peer-info (peer-ip p) (peer-port p))) (peer-context-data-connected-peers peer-context))]
               [all-valid-peers (hash-keys (peer-context-data-valid-peers peer-context))]
               [potential-peers (set-subtract all-valid-peers current-connected-ips)])
        (for ([peer potential-peers])
          (when #t ; (eq? #f (member ip (list "0" "0.0.0.0" "::1" "127.0.0.1")))
            ; TODO
            (thread (lambda ()
                      (with-handlers
                          ([exn:fail?
                            (lambda (x)
                              ;(displayln x)
                              ;(printf "Cannot connect to ~a:~a\n" (peer-info-ip peer) (peer-info-port peer))
                              #t
                              )])
                        (begin
                          ;(printf "Trying to connect to ~a:~a...\n" (peer-info-ip peer) (peer-info-port peer))
                          (define-values (in out) (tcp-connect (peer-info-ip peer) (peer-info-port peer)))
                          (launch-handler-thread handler peer-context in out)))))))
        (sleep 10)
        (loop)))
    (thread loop))
  (lambda ()
    (custodian-shutdown-all conns-cust)))
#| Generic procedures for client |#

(define (run-peer peer-context)
  (let ([stop-listener (serve peer-context)]
        [stop-peers-loop (peers peer-context)]
        [stop-connections-loop (connections-loop peer-context)])
    (lambda ()
      (begin
        (stop-connections-loop)
        (stop-peers-loop)
        (stop-listener)))))

(define peer-1-context (peer-context-data "Test peer" 9876 (make-hash) '() (current-milliseconds)))
(define peer-2-context (peer-context-data "Test peer" 9877 (make-hash (list (cons (peer-info "127.0.0.1" 9876) #t))) '() 1))

peer-1-context
peer-2-context
(define stop-peer-1 (run-peer peer-1-context))
(define stop-peer-2 (run-peer peer-2-context))