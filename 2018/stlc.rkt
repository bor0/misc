#lang racket

;; Type Inference for Simply Typed Lambda Calculus
;; Guannan Wei <guannanwei@outlook.com>
(define (counter)
  (let ([n 0])
    (lambda ()
      (set! n (add1 n))
      n)))

(define fresh-n counter)

(require rackunit)
(require racket/set)

;; Environment & Type Environment

(define (make-lookup error-hint isa? name-of val-of)
  (λ (name vals)
    (cond [(empty? vals) (error error-hint "free variable")]
          [else (if (and (isa? (first vals))
                         (equal? name (name-of (first vals))))
                    (val-of (first vals))
                    ((make-lookup error-hint isa? name-of val-of) name (rest vals)))])))


;; Expressions

(struct NumE (n) #:transparent)
(struct BoolE (b) #:transparent)
(struct IdE (id) #:transparent)
(struct PlusE (l r) #:transparent)
(struct MultE (l r) #:transparent)
(struct LamE (arg body) #:transparent)
(struct AppE (fun arg) #:transparent)

;; Types

(struct BoolT () #:transparent)
(struct NumT () #:transparent)
(struct VarT (name) #:transparent)
(struct ArrowT (arg result) #:transparent)

;; Values

(struct NumV (n) #:transparent)
(struct ClosureV (arg body env) #:transparent)

;; Environment & Type Environment

(struct Binding (name val) #:transparent)
(define lookup (make-lookup 'lookup Binding? Binding-name Binding-val))
(define ext-env cons)

(struct TypeBinding (name type) #:transparent)
(define type-lookup (make-lookup 'type-lookup TypeBinding? TypeBinding-name TypeBinding-type))
(define ext-tenv cons)

;; Parsers

(define (parse s)
  (match s
    [(? number? x) (NumE x)]
    [(? symbol? x) (IdE x)]
    [`(+ ,l ,r) (PlusE (parse l) (parse r))]
    [`(* ,l ,r) (MultE (parse l) (parse r))]
    [`(let ([,var ,val]) ,body)
     (AppE (LamE var (parse body)) (parse val))]
    [`(λ (,var) ,body) (LamE var (parse body))]
    [`(lambda (,var) ,body) (LamE var (parse body))]
    [`(,fun ,arg) (AppE (parse fun) (parse arg))]
    [else (error 'parse "invalid expression")]))

;; Type Inference
(struct Eq (fst snd) #:transparent)

; Substitute a = b in a type (single equation)
(define (type-subst in src dst)
  (match in
    [(NumT) in]
    [(BoolT) in]
    [(VarT x) (if (equal? src in) dst in)]
    [(ArrowT t1 t2) (ArrowT (type-subst t1 src dst)
                            (type-subst t2 src dst))]))

; Substitute a to b for every equation a = b
(define (unify/subst eqs src dst)
  (cond [(empty? eqs) eqs]
        [else (define eq (first eqs))
              (define eqfst (Eq-fst eq))
              (define eqsnd (Eq-snd eq))
              (cons (Eq (type-subst eqfst src dst)
                        (type-subst eqsnd src dst))
                    (unify/subst (rest eqs) src dst))]))

; Check if the type occurs within in
(define (occurs? t in)
  (match in
    [(NumT) #f]
    [(ArrowT at rt) (or (occurs? t at) (occurs? t rt))]
    [(VarT x) (equal? t in)]))

(define not-occurs? (compose not occurs?))

(define (unify-error t1 t2)
  (error 'type-error "can not unify: ~a and ~a" t1 t2))

(define (unify/helper substs result)
  (match substs
    ['() result]
    [(list (Eq fst snd) rest ...)
     (match* (fst snd)
       [((VarT x) t)
        (if (not-occurs? fst snd)
            (unify/helper (unify/subst rest fst snd) (cons (Eq fst snd) result))
            (unify-error fst snd))]
       [(t (VarT x))
        (if (not-occurs? snd fst)
            (unify/helper (unify/subst rest snd fst) (cons (Eq snd fst) result))
            (unify-error snd fst))]
       [((ArrowT t1 t2) (ArrowT t3 t4))
        (unify/helper `(,(Eq t1 t3) ,(Eq t2 t4) ,@rest) result)]
       [(x x) (unify/helper rest result)]
       [(_ _)  (unify-error fst snd)])]))

(define (unify substs) (unify/helper (set->list substs) (list)))

(define (type-infer exp tenv const)
  (match exp
    [(NumE n) (values (NumT) const)]
    [(BoolE b) (values (BoolT) const)]
    [(PlusE l r)
     (define-values (lty lconst) (type-infer l tenv (set)))
     (define-values (rty rconst) (type-infer r tenv (set)))
     (values (NumT)
             (set-add (set-add (set-union lconst rconst) (Eq lty (NumT))) (Eq rty (NumT))))]
    [(MultE l r)
     (define-values (lty lconst) (type-infer l tenv (set)))
     (define-values (rty rconst) (type-infer r tenv (set)))
     (values (NumT)
             (set-add (set-add (set-union lconst rconst) (Eq lty (NumT))) (Eq rty (NumT))))]
    [(IdE x)
     (values (type-lookup x tenv) const)]
    [(LamE arg body)
     (define new-tvar (VarT (fresh-n)))
     (define-values (bty bconst)
       (type-infer body (ext-tenv (TypeBinding arg new-tvar) tenv) const))
     (values (ArrowT new-tvar bty) bconst)]
    [(AppE fun arg)
     (define-values (funty funconst) (type-infer fun tenv (set)))
     (define-values (argty argconst) (type-infer arg tenv (set)))
     (define new-tvar (VarT (fresh-n)))
     (values new-tvar (set-add (set-union funconst argconst) (Eq funty (ArrowT argty new-tvar))))]))

(define (reify substs ty)
  (define (lookup/default x sts)
    (match sts
      ['() x]
      [(list (Eq fst snd) rest ...)
       (if (equal? fst x)
           (lookup/default snd substs)
           (lookup/default x rest))]))
  (match ty
    [(NumT) (NumT)]
    [(BoolT) (BoolT)]
    [(VarT x)
     (define ans (lookup/default ty substs))
     (if (ArrowT? ans) (reify substs ans) ans)]
    [(ArrowT t1 t2)
     (ArrowT (reify substs t1) (reify substs t2))]))

(define (typecheck exp tenv)
  (set! fresh-n (counter))
  (define-values (ty constraints) (type-infer exp tenv (set)))
  (reify (unify constraints) ty))

;;;

(define mt-tenv empty)

(check-equal? (typecheck (parse '{λ {x} {λ {y} {+ x y}}}) mt-tenv)
              (ArrowT (NumT) (ArrowT (NumT) (NumT))))

(set! mt-tenv empty)

(check-equal? (typecheck (parse '{λ {f} {λ {u} {u {f u}}}}) mt-tenv)
              (ArrowT (ArrowT (ArrowT (VarT 3) (VarT 4)) (VarT 3))
                      (ArrowT (ArrowT (VarT 3) (VarT 4)) (VarT 4))))

(set! mt-tenv empty)

;(typecheck (parse '{{λ {x} {x x}} {λ {x} {x x}}}) mt-tenv)
