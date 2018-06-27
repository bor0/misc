#lang racket
(define (is-not-divisible-by<=i i m)
  (cond
    [(= i 1) true]
    [else (cond
            [(= (remainder m i) 0) false]
            [else (is-not-divisible-by<=i (sub1 i) m)])]))

(define (prime? n)
  (is-not-divisible-by<=i (sub1 n) n))

; Find the first prime that's >= num
(define (find-next-prime num)
  (define (iter x)
    (let ([newnum (+ x (* num (expt 2 (ceiling (log x 2)))))])
      (if (prime? newnum) newnum (iter (+ x 1)))))
  (inexact->exact (iter 5)))

; Get nth letter from an encoded number
(define (get-nth-letter num n)
  (if (< (integer-length num) (* 5 n))
      #f
      (bitwise-bit-field num (- (integer-length num) (+ 1 (* 5 n))) (- (integer-length num) (+ 1 (* 5 (- n 1)))))))

#|
a 00000
b 00001
c 00010
d 00011
e 00100
f 00101
g 00110
h 00111
i 01000
j 01001
k 01010
l 01011
m 01100
n 01101
o 01110
p 01111
q 10000
r 10001
s 10010
t 10011
u 10100
v 10101
w 10110
x 10111
y 11000
z 11001
|#

(define (decode num)
  (define (decode-iter n)
    (let [(nth-letter (get-nth-letter num n))]
      (if nth-letter (cons nth-letter (decode-iter (+ n 1))) '())))
  (decode-iter 1))

(define (encode list)
  (define (encode-iter list ac)
    (if (eq? list '()) ac (encode-iter (cdr list) (+ (car list) (arithmetic-shift ac 5)))))
  (find-next-prime (encode-iter list 1)))

; "boro" per encoding table above
(define boro '(1 14 17 14))
; encoded boro
(define encoded-boro (encode boro))

(displayln boro)
(displayln encoded-boro) ; our actual prime number
(displayln (decode encoded-boro))