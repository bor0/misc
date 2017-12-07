#lang typed/racket

; We can do propositional logic, but not more than that. The actual power lies in dependent types
; Dependent types (product types) means the types can depend on values of another type, equivalent to forall
; Non-dependent types (sum types) are equivalent to exists

(define-type P 'p)
(define-type Q 'q)

(define proof_p 'p)
(define proof_q 'q)

; P /\ Q -> P
(: th1 : (Pair 'p 'q) -> 'p)
(define (th1 pq) (car pq))
(displayln "Theorem 1")
(th1 (cons proof_p proof_q))

; P /\ Q -> Q
(: th2 : (Pair 'p 'q) -> 'q)
(define (th2 pq) (cdr pq))
(displayln "Theorem 2")
(th2 (cons proof_p proof_q))

; P /\ Q -> Q /\ P
(: th3 : (Pair 'p 'q) -> (Pair 'q 'p))
(define (th3 pq) (cons (cdr pq) (car pq)))
(displayln "Theorem 3")
(th3 (cons proof_p proof_q))

; (P \/ Q) /\ Q -> Q
(: th4 : (Pair (U 'p 'q) 'q) -> 'q)
(define (th4 p_or_q_AND_q)
  (let ((p_or_q (car p_or_q_AND_q))
        (q (cdr p_or_q_AND_q))) q))

(displayln "Theorem 4")
(th4 (cons proof_p proof_q))
(th4 (cons proof_q proof_q))

; P -> P \/ Q
(: th5 : 'p -> (U 'p 'q))
(define (th5 p) p)
(displayln "Theorem 5")
(th5 proof_p)
