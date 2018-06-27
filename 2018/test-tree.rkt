#lang typed/racket
; Polymorphic recursive data type
(define-type (BinaryTree a) (U Null (node a)))

(struct (a) node ([val : a]
                  [left : (BinaryTree a)]
                  [right : (BinaryTree a)]) #:transparent)

(define test-tree
  (node 1
        (node 0 '() '())
        (node 2 '() '())))

(: tree-sum (-> (BinaryTree Number) Number))
(define (tree-sum t)
  (cond [(null? t) 0]
        [else (+ (node-val t)
                 (tree-sum (node-left t))
                 (tree-sum (node-right t)))]))

(tree-sum test-tree)
