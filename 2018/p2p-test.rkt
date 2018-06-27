#lang racket
(require racket/serialize)

(define (string-starts-with str1 str2)
  (let ([str1len (string-length str1)]
        [str2len (string-length str2)])
    (equal? str2 (substring str1 0 (min str2len str1len)))))

(define valid-peers (make-hash))
(define connected-peers '())

;(hash-set! valid-peers "192.168.1.123" #t)

(define latest-hash (current-milliseconds))

(struct peer (ip input-port output-port) #:transparent)

(define (maybe-update-hash line)
  (let ([current-hash (string->number (string-replace line #rx"(latest-hash:|[\r\n]+)" ""))])
    (when (and (number? current-hash) (> current-hash latest-hash))
      (displayln "hash updated")
      (set! latest-hash current-hash))))

#| Generic handlers for both client and server |#
; Handler
(define (handler in out)
  (flush-output out)
  (define line (read-line in))
  (when (string? line) ; it can be eof
    (cond [(string-starts-with line "get-valid-peers")
           (begin (displayln (serialize valid-peers) out) (handler in out))]
          [(string-starts-with line "get-connected-peers")
           (begin (displayln (serialize connected-peers) out) (handler in out))]
          [(string-starts-with line "get-latest-hash")
           (begin (display "latest-hash:" out) (displayln latest-hash out) (handler in out))]
          [(string-starts-with line "latest-hash:")
           (begin (maybe-update-hash line) (handler in out))]
          [(string-starts-with line "exit")
           (displayln "bye" out)]
          [else (handler in out)])))

; Helper to launch handler thread
(define (launch-handler-thread handler in out)
  (define-values (local-ip remote-ip) (tcp-addresses in))
  (define current-peer (peer remote-ip in out))
  (thread
   (lambda ()
     (hash-set! valid-peers remote-ip #t)
     (set! connected-peers (cons current-peer connected-peers))
     (handler in out)
     (set! connected-peers (set-remove connected-peers current-peer))
     (close-input-port in)
     (close-output-port out))))

; Ping all peers in attempt to sync hashes
(define (peers)
  (define (loop)
    (sleep 10)
    (for [(p connected-peers)]
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
(define (accept-and-handle listener handler)
  (define-values (in out) (tcp-accept listener))
  (launch-handler-thread handler in out))

; Server listener
(define (serve port-no)
  (define main-cust (make-custodian))
  (parameterize ([current-custodian main-cust])
    (define listener (tcp-listen port-no 5 #t))
    (define (loop)
      (accept-and-handle listener handler)
      (loop))
    (thread loop))
  (lambda ()
    (custodian-shutdown-all main-cust)))
#| Generic procedures for server |#

#| Generic procedures for client |#
; Make sure we're connected with all known peers
(define (connections-loop port-no)
  (define conns-cust (make-custodian))
  (parameterize ([current-custodian conns-cust])
    (define (loop)
      (letrec ([current-connected-ips (map (lambda (p) (peer-ip p)) connected-peers)]
               [all-valid-ips (hash-keys valid-peers)]
               [potential-ips (set-subtract all-valid-ips current-connected-ips)])
        (for ([ip potential-ips])
          (when (eq? #f (member ip (list "0" "0.0.0.0" "::1" "127.0.0.1")))
            (thread (lambda ()
                      (printf "Trying to connect to ~a...\n" ip)
                      (define-values (in out) (tcp-connect ip port-no))
                      (launch-handler-thread handler in out)))))
        (sleep 10)
        (loop)))
    (thread loop))
  (lambda ()
    (custodian-shutdown-all conns-cust)))
#| Generic procedures for client |#

(define stop-listener (serve 9876))
(define stop-peers-loop (peers))
(define stop-connections-loop (connections-loop 9876))

(define (stop-all)
  (begin
    (stop-listener)
    (stop-peers-loop)
    (stop-connections-loop)))
