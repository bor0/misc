#lang 2d racket
(require 2d/cond)
 
(define (times-intersect? a1 b1 a2 b2)
  #2dcond
  ╔════════════╦════════════╦════════════╗
  ║            ║ (<= a1 b2) ║ (<= a2 b1) ║
  ╠════════════╬════════════╬════════════╣
  ║ (>= b1 a2) ║ #t         ║ #f         ║
  ╠════════════╬════════════╬════════════╣
  ║ (>= b2 a1) ║ #f         ║ #t         ║
  ╚════════════╩════════════╩════════════╝)

(and
 (eq? #t (times-intersect? 1 4 3 2))  ;row 1 col 1
 (eq? #f (times-intersect? 4 2 1 3))  ;row 1 col 2
 (eq? #f (times-intersect? 3 1 2 3))  ;row 2 col 1
 (eq? #t (times-intersect? 3 2 1 4))) ;row 2 col 2

#|
==========================> Test #1 (False)
|__________|
             |____|
==========================> Test #2 (True)
|__________|
         |____|
==========================> Test #3 (True)
         |____|
|__________|
==========================> Test #4 (False)
             |____|
|__________|
==========================> Test #5 (False)
             |__________|
|____|
==========================> Test #6 (True)
             |__________|
         |____|
==========================> Test #7 (True)
         |____|
             |__________|
==========================> Test #8 (False)
|____|
             |__________|
==========================> 
|#

(and
 (eq? #f (times-intersect? 1 12 14 19))
 (eq? #t (times-intersect? 1 12 10 15))
 (eq? #t (times-intersect? 10 15 1 12))
 (eq? #f (times-intersect? 14 19 1 12))
 
 (eq? #f (times-intersect? 14 25 1 6))
 (eq? #t (times-intersect? 14 25 10 15))
 (eq? #t (times-intersect? 10 15 14 25))
 (eq? #f (times-intersect? 1 6 14 25)))
