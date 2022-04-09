#lang racket
#|
if_stmt := "if " test
test    := name cmp name
cmp     := "==" | "!=" | ">" | "<"
name    := alpha name | alpha
alpha   := "a" | "b" | "c"
|#
(define grammar
  (make-hash
   (list
    (cons 'if_stmt '((if test)))
    (cons 'test '((name cmp name)))
    (cons 'cmp '((==) (!=) (>) (<)))
    (cons 'name '((alpha name) (alpha)))
    (cons 'alpha '((a) (b) (c))))))

; given an expression and a rule name, check if any of the rules within that particular rule match
(define (rule-match grammar expr rule partial)
  (let ([rule-exprs (hash-ref grammar rule)])
    (iterate-rules grammar expr rule-exprs partial)))

; given an expression and a list of rule expressions, check them all one by one
(define (iterate-rules grammar expr rule-exprs partial)
  (if (eq? rule-exprs '())
      #f
      (let ([res (rule-expr-match grammar expr (car rule-exprs) partial)])
        (if res res (iterate-rules grammar expr (cdr rule-exprs) partial)))))

; given an expression and a rule expression, check if it matches
(define (rule-expr-match grammar expr rule-expr partial)
  (cond
    ((and (null? rule-expr) (or (null? expr) partial)) expr)
    ((or (false? expr) (null? expr)) #f)
    ((null? rule-expr) #f)
    ((and (not (hash-has-key? grammar (car rule-expr))) ; literal value, not rule
          (eq? (car expr) (car rule-expr))) (rule-expr-match grammar (cdr expr) (cdr rule-expr) partial))
    ((hash-has-key? grammar (car rule-expr)) ; we need to apply a rule
     (let ([partial-match (rule-match grammar expr (car rule-expr) #t)])
       (rule-expr-match grammar partial-match (cdr rule-expr) partial)))
    (else #f)))

; given a grammar and an expression, check if any of the rules match the expr
(define (grammar-match grammar expr)
  (let ([calc-all-rules
         (foldl (lambda (rule acc) (or (rule-match grammar expr rule #f) acc))
                #f
                (hash-keys grammar))])
    (if (null? calc-all-rules) #t #f)))

(equal? #t (grammar-match grammar '(if a == a)))
(equal? #f (grammar-match grammar '(if a)))
(equal? #t (grammar-match grammar '(a)))
(equal? #t (grammar-match grammar '(a a)))
(equal? #f (grammar-match grammar '(a q)))
(equal? #t (grammar-match grammar '(if a != a)))
(equal? #f (grammar-match grammar '(if q != a)))
(equal? #f (grammar-match grammar '(if a != q)))
(equal? #t (grammar-match grammar '(a > b)))
(equal? #f (grammar-match grammar '(x > y)))
(equal? #t (grammar-match grammar '(==)))