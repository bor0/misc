; compare to 2020/cp.rkt

#|
==================
| 1 |   || 3 |   |
|   | 4 || 2 | 1 |
------------------
|   |   ||   | 2 |
|   |   || 4 |   |
==================

==================
| a | b || e | f |
| c | d || g | h |
------------------
| i | j || m | n |
| k | l || o | p |
==================
|#

(declare-const a (Int)) (assert (= 1 a))
(declare-const b (Int)) (assert (< 0 b))
(declare-const c (Int)) (assert (< 0 c))
(declare-const d (Int)) (assert (= 4 d))

(declare-const e (Int)) (assert (= 3 e))
(declare-const f (Int)) (assert (< 0 f))
(declare-const g (Int)) (assert (= 2 g))
(declare-const h (Int)) (assert (= 1 h))

(declare-const i (Int)) (assert (< 0 i))
(declare-const j (Int)) (assert (< 0 j))
(declare-const k (Int)) (assert (< 0 k))
(declare-const l (Int)) (assert (< 0 l))

(declare-const m (Int)) (assert (< 0 m))
(declare-const n (Int)) (assert (= 2 n))
(declare-const o (Int)) (assert (= 4 o))
(declare-const p (Int)) (assert (< 0 p))

; Modeling the Sudoku solution in terms of summations
(assert
  ; boxes sum
  (and (= (+ (+ a b) (+ c d)) 10)
  (and (= (+ (+ e f) (+ g h)) 10)
  (and (= (+ (+ i j) (+ k l)) 10)
  (and (= (+ (+ m n) (+ o p)) 10)
  ; vertical
  (and (= (+ (+ a c) (+ i k)) 10)
  (and (= (+ (+ b d) (+ j l)) 10)
  (and (= (+ (+ e g) (+ m o)) 10)
  (and (= (+ (+ f h) (+ n p)) 10)
  ; horizontal
  (and (= (+ (+ a b) (+ e f)) 10)
  (and (= (+ (+ c d) (+ g h)) 10)
  (and (= (+ (+ i j) (+ m n)) 10)
  (and (= (+ (+ k l) (+ o p)) 10))))))))))))))

(check-sat)
(get-model)

#|
==================
| 1 | 2 || 3 | 4 |
| 3 | 4 || 2 | 1 |
------------------
| 4 | 3 || 1 | 2 |
| 2 | 1 || 4 | 3 |
==================
|#
