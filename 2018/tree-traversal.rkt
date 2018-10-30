#lang racket
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right) (list entry left right))

(define tr (make-tree 1
                      (make-tree 2
                                 (make-tree 4 '() '())
                                 (make-tree 5 '() '()))
                      (make-tree 3 '() '())))

(define (bfs t)
  (define (bfs-helper t)
    (cond ((and (pair? t) (pair? (left-branch t)) (pair? (right-branch t)))
           (append (list (entry (left-branch t)) (entry (right-branch t)))
                   (bfs-helper (left-branch t))
                   (bfs-helper (right-branch t))))
          ((and (pair? t) (pair? (left-branch t))
                (cons (entry (left-branch t))
                      (bfs-helper (left-branch t)))))
          ((and (pair? t) (pair? (right-branch t))
                (cons (entry (right-branch t))
                      (bfs-helper (right-branch t)))))
          (else '())))
  ((if (pair? t)
       (lambda (x) (cons (entry t) x))
       identity)
   (bfs-helper t)))

(define (dfs-preorder t)
  (cond ((null? t) '())
        (else (append (list (entry t)) (dfs-preorder (left-branch t)) (dfs-preorder (right-branch t))))))

(define (dfs-inorder t)
  (cond ((null? t) '())
        (else (append (dfs-inorder (left-branch t)) (list (entry t)) (dfs-inorder (right-branch t))))))

(define (dfs-postorder t)
  (cond ((null? t) '())
        (else (append (dfs-postorder (left-branch t)) (dfs-postorder (right-branch t)) (list (entry t))))))

(bfs tr)
(dfs-preorder tr)
(dfs-inorder tr)
(dfs-postorder tr)
