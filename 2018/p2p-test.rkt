#lang racket
(require racket/serialize)

; Peer info structure contains an ip and a port
(struct peer-info (ip port) #:prefab)

; Peer info IO structure additionally contains IO ports
(struct peer-info-io (pi input-port output-port) #:prefab)

; Peer context data contains all information needed for a single peer.
(struct peer-context-data (name ; Name of this peer
                           port ; Port number to use
                           [valid-peers #:mutable] ; List of valid peers (will be updated depending on info retrieved from connected peers)
                           [connected-peers #:mutable] ; List of connected peers (will be a (not necessarily strict) subset of valid-peers)
                           [latest-hash #:mutable]) ; Latest hash will be updated from data with other peers
  #:prefab)

; Handler for updating latest hash
(define (maybe-update-hash peer-context line)
  (let ([current-hash (string->number (string-replace line #rx"(latest-hash:|[\r\n]+)" ""))]
        [latest-hash (peer-context-data-latest-hash peer-context)])
    (when (and (number? current-hash) (> current-hash latest-hash))
      (printf "Hash updated to ~a for peer ~a\n" current-hash (peer-context-data-name peer-context))
      (set-peer-context-data-latest-hash! peer-context current-hash))))

; Handler for updating valid peers
(define (maybe-update-valid-peers peer-context line)
  (let ([valid-peers (list->set (deserialize (read (open-input-string (string-replace line #rx"(valid-peers:|[\r\n]+)" "")))))]
        [current-valid-peers (peer-context-data-valid-peers peer-context)])
    (set-peer-context-data-valid-peers! peer-context (set-union current-valid-peers valid-peers))))

#| Generic handlers for both client and server |#
; Handler
(define (handler peer-context in out)
  (flush-output out)
  (define line (read-line in))
  (when (string? line) ; it can be eof
    (cond [(string-prefix? line "get-valid-peers")
           (begin (display "valid-peers:" out) (displayln (serialize (set->list (peer-context-data-valid-peers peer-context))) out) (handler peer-context in out))]
          [(string-prefix? line "get-latest-hash")
           (begin (display "latest-hash:" out) (displayln (peer-context-data-latest-hash peer-context) out) (handler peer-context in out))]
          [(string-prefix? line "latest-hash:")
           (begin (maybe-update-hash peer-context line) (handler peer-context in out))]
          [(string-prefix? line "valid-peers:")
           (begin (maybe-update-valid-peers peer-context line) (handler peer-context in out))]
          [(string-prefix? line "exit")
           (displayln "bye" out)]
          [else (handler peer-context in out)])))

; Helper to launch handler thread
(define (launch-handler-thread handler peer-context in out cb)
  (define-values (local-ip remote-ip) (tcp-addresses in))
  (define current-peer (peer-info remote-ip (peer-context-data-port peer-context)))
  (define current-peer-io (peer-info-io current-peer in out))
  (thread
   (lambda ()
     (handler peer-context in out)
     (cb)
     (close-input-port in)
     (close-output-port out))))

; Ping all peers in attempt to sync hashes and update list of valid peers
(define (peers peer-context)
  (define (loop)
    (sleep 10)
    (for [(p (peer-context-data-connected-peers peer-context))]
      (let ([in (peer-info-io-input-port p)]
            [out (peer-info-io-output-port p)])
        (displayln "get-latest-hash" out)
        (displayln "get-valid-peers" out)
        (flush-output out)))
    (printf "Peer ~a reports ~a valid peers.\n" (peer-context-data-name peer-context) (set-count (peer-context-data-valid-peers peer-context)))
    (loop))
  (define t (thread loop))
  (lambda ()
    (kill-thread t)))
#| Generic handlers for both client and server |#

#| Generic procedures for server |#
; Accept of a new connection
(define (accept-and-handle listener handler peer-context)
  (define-values (in out) (tcp-accept listener))
  (launch-handler-thread handler peer-context in out void))

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
      (letrec ([current-connected-peers (list->set (map peer-info-io-pi (peer-context-data-connected-peers peer-context)))]
               [all-valid-peers (peer-context-data-valid-peers peer-context)]
               [potential-peers (set-subtract all-valid-peers current-connected-peers)])
        (for ([peer potential-peers])
          (thread (lambda ()
                    (with-handlers
                        ([exn:fail?
                          (lambda (x)
                            ;(printf "Cannot connect to ~a:~a\n" (peer-info-ip peer) (peer-info-port peer))
                            #t)])
                      (begin
                        ;(printf "Trying to connect to ~a:~a...\n" (peer-info-ip peer) (peer-info-port peer))
                        (define-values (in out) (tcp-connect (peer-info-ip peer) (peer-info-port peer)))
                        (printf "'~a' connected to ~a:~a!\n" (peer-context-data-name peer-context) (peer-info-ip peer) (peer-info-port peer))
                        (define current-peer-io (peer-info-io peer in out))
                        ; Add current peer to list of connected peers
                        (set-peer-context-data-connected-peers! peer-context (cons current-peer-io (peer-context-data-connected-peers peer-context)))
                        (launch-handler-thread handler
                                               peer-context
                                               in
                                               out
                                               (lambda ()
                                                 ; Remove peer from list of connected peers
                                                 (set-peer-context-data-connected-peers! peer-context
                                                                                         (set-remove
                                                                                          (peer-context-data-connected-peers peer-context)
                                                                                          current-peer-io)))))))))
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

(define peer-1-context (peer-context-data "Test peer 1" 9876 (set (peer-info "127.0.0.1" 9877)) '() (current-milliseconds)))
(define peer-2-context (peer-context-data "Test peer 2" 9877 (set (peer-info "127.0.0.1" 9876) (peer-info "127.0.0.1" 9878)) '() 1))
(define peer-3-context (peer-context-data "Test peer 3" 9878 (set (peer-info "127.0.0.1" 9877)) '() 1))

peer-1-context
peer-2-context
peer-3-context

(define stop-peer-1 (run-peer peer-1-context))
(define stop-peer-2 (run-peer peer-2-context))
(define stop-peer-3 (run-peer peer-3-context))

(define (stop-all-peers)
  (begin
    (stop-peer-1)
    (stop-peer-2)
    (stop-peer-3)))

(sleep 10000)
