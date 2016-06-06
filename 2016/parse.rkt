#lang racket
(define args (vector->list (current-command-line-arguments)))

(define (readfile f)
  (begin
    (define in (open-input-file f))

    (define (parseline l)
      (define ll (string-split l ","))
      (if (not (= 3 (length ll)))
          (error "Cannot parse file")
          (list (string->symbol (first ll))
                (string->number (second ll))
                (string->number (third ll)))))
    
    (define (readl in)
      (begin
        (define l (read-line in))
        (if (string? l)
            (cons (parseline l) (readl in))
            '())))
    
    (define ret (readl in))

    (close-input-port in)

    ret))

(define (result) (readfile (car args)))
(define (calculated-result) (map (lambda (x) (list (first x) (* (second x) (third x)))) (result)))
(define total (foldl + 0 (map second (calculated-result))))

(begin
  (if (< (length args) 1)
      (begin
        (display "Specify file to parse")
        (newline))
      (begin
        (display total)
        (newline))))
