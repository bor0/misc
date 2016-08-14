#lang racket
(define-struct tree
  (value left right)
  #:transparent) ; allow printing of the struct

(define a-tree
  (make-tree 5
             (make-tree 3
                        (make-tree 2 null null)
                        (make-tree 4 null null))
             (make-tree 7
                        (make-tree 6 null null)
                        (make-tree 8 null null))))

(define (invert-tree tree)
  (cond ((null? tree) tree)
        (else (make-tree (tree-value tree)
                         (invert-tree (tree-right tree))
                         (invert-tree (tree-left tree))))))

(pretty-print a-tree)
(pretty-print (invert-tree a-tree))