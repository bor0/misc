#lang racket
; TODO: Use skip-lists for efficiency
; TODO: Optimize list. (interval 0 1 0), (interval 1 5 0), (interval 5 7 1) -> (interval 0 5 0), (interval 5 7 1)
; Initial implementation done in 2 hours.

(define-struct interval (l u val) #:transparent)
(define (make-interval-map) '())

(define (interval-map-ref interval-map position default)
  (if (null? interval-map)
      default
      (let ([current-interval (car interval-map)])
        (if (and (<= (interval-l current-interval) position)
                 (< position (interval-u current-interval)))
            (interval-val current-interval)
            (interval-map-ref (cdr interval-map) position default)))))

; Insert (or replace) a value in an interval, by first erasing it to make room.
(define (interval-map-set interval-map interval-inst)
  (define (interval-map-process interval-map interval-inst)
    (cond ((empty? interval-map) (cons interval-inst interval-map))
          ((<= (interval-l interval-inst) (interval-l (car interval-map))) (cons interval-inst interval-map))
          (else (cons (car interval-map) (interval-map-process (cdr interval-map) interval-inst)))))

  (if (member interval-inst interval-map)
      interval-map
      (let ([interval-with-spaces (erase-intervals interval-map (interval-l interval-inst) (interval-u interval-inst))])
        (interval-map-process interval-with-spaces interval-inst))))

; Erases (and balances) intervals, making room for a new entry.
; Conditionals in this method are repeated on purpose, for easier understanding of cases.
(define (erase-intervals interval-map start end)
  (define (erase-intervals-iter interval-map start end res)
    (if (empty? interval-map)
        res
        (let ([current-interval (car interval-map)])
          (cond
            ;  [==========]
            ; <============>
            ; result: 
            ; <============>
            ((and (<= start (interval-l current-interval)) (>= end (interval-u current-interval)))
             (erase-intervals-iter (cdr interval-map) start end res))
            ; [===========]
            ; <========>
            ; result:
            ; [===========]
            ; <========>[=]
            ((and (= start (interval-l current-interval)) (< end (interval-u current-interval)))
             (erase-intervals-iter (cdr interval-map) start end (cons (interval end
                                                                                (interval-u current-interval)
                                                                                (interval-val current-interval)) res)))
            ; [===========]
            ; <============>
            ; result:
            ; [===========]
            ; <============>
            ((and (= start (interval-l current-interval)) (> end (interval-u current-interval)))
             (erase-intervals-iter (cdr interval-map) start end res))
            ; [===========]
            ;    <========>
            ; result
            ; [=]<========>
            ((and (> start (interval-l current-interval)) (= end (interval-u current-interval)))
             (erase-intervals-iter (cdr interval-map) start end (cons (interval (interval-l current-interval)
                                                                                start
                                                                                (interval-val current-interval)) res)))
            ; [============]
            ;    <======>
            ; result
            ; [=]<======>[=]
            ((and (> start (interval-l current-interval)) (< end (interval-u current-interval)))
             (erase-intervals-iter (cdr interval-map) start end
                                   (cons (interval end (interval-u current-interval) (interval-val current-interval))
                                         (cons (interval (interval-l current-interval) start (interval-val current-interval)) res))))
            ;     [===]
            ; <==>
            ; result: 
            ; <==>[===]
            ((and (< start (interval-l current-interval)) (< end (interval-u current-interval)) (< start (interval-u current-interval)) (< end (interval-l current-interval)))
             (erase-intervals-iter (cdr interval-map) start end (cons (car interval-map) res)))
            ; [===========]
            ;    <=========>
            ; result
            ; [=]<=========>
            ((and (> start (interval-l current-interval)) (< start (interval-u current-interval)) (> end (interval-u current-interval)))
             (erase-intervals-iter (cdr interval-map) start end (cons (interval (interval-l current-interval)
                                                                                start
                                                                                (interval-val current-interval)) res)))
            ;    [===========]
            ; <=========>
            ; result
            ; <=========>[===]
            ((and (< start (interval-l current-interval)) (< start (interval-u current-interval)) (> end (interval-l current-interval)))
             (erase-intervals-iter (cdr interval-map) start end (cons (interval end
                                                                                (interval-u current-interval)
                                                                                (interval-val current-interval)) res)))
            (else (erase-intervals-iter (cdr interval-map) start end (cons (car interval-map) res)))))))
    
  (if (<= end start)
      interval-map
      (reverse (erase-intervals-iter interval-map start end '()))))


#|
TESTS
|#

(define interval-inst (make-interval-map))
(set! interval-inst (interval-map-set interval-inst (interval 0 10 0)))

(define vector-inst (make-vector 10))

(define (test-vector-copy! v from to value)
  (cond ((<= to from) v)
        (else (begin
                (vector-set! v from value)
                (test-vector-copy! v (+ from 1) to value)))))

(define (true-for-all? pred list)
  (cond
    [(empty? list) #t]
    [(pred (first list)) (true-for-all? pred (rest list))]
    [else #f]))

(define (test)
  (let ([l (random 0 10)]
        [u (random 0 10)]
        [v (random 0 10)])
    (if (> u l)
        (begin
          (set! interval-inst (interval-map-set interval-inst (interval l u v)))
          (test-vector-copy! vector-inst l u v)
          (if (not (true-for-all? identity (for/list ([i (range 0 10)])
                                             (eq? (vector-ref vector-inst i)
                                                  (interval-map-ref interval-inst i #f)))))
              (error (string-append "Test fail: " (~a (list l u v))))
              (list l u v)))
        (test))))

(define (test-debug) (list interval-inst vector-inst (test)))

(for ([i (range 0 1000000)])
  (test))