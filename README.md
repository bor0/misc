Misc playground
===============
In this repository you will find a lot of stuff which I've been practicing throughout the years. I have a bunch of other stuff on my other computers, so as soon as I sort them I will be posting them here.

# Technical books

In addition to the practices, here are my favorite technical readings that shaped my knowledge in a way:

| Name                                                 | Amazon URL                           | Online URL                                                                |
| ---------------------------------------------------- | ------------------------------------ | ------------------------------------------------------------------------- |
| 1. Gentle Introduction to Dependent Types with Idris | https://www.amazon.com/dp/1723139416 | https://leanpub.com/gidti                                                 |
| 2. How To Prove It/Proofs and Concepts               | https://www.amazon.com/dp/0521675995 | http://people.uleth.ca/~dave.morris/books/proofs+concepts.html            |
| 3. Learn You a Haskell for Great Good!               | https://www.amazon.com/dp/1593272839 | http://learnyouahaskell.com/chapters                                      |
| 4. The Little Schemer                                | https://www.amazon.com/dp/0262560992 | |
| 5. The C Programming Language                        | https://www.amazon.com/dp/0131103628 | |
| 6. The Pragmatic Programmer                          | https://www.amazon.com/dp/020161622X | Tips summarized https://blog.codinghorror.com/a-pragmatic-quick-reference |
| 7. SICP                                              | https://www.amazon.com/dp/0262510871 | https://mitpress.mit.edu/sicp/full-text/book/book.html                    |
| 8. JavaScript Patterns                               | https://www.amazon.com/dp/0596806752 | |
| 9. Competetive Programmer's Handbook                 | https://www.amazon.com/dp/3319725467 | https://cses.fi/book.html                                                 |
| 10. Software Foundations Vol. 1: Logic               |                                      | https://softwarefoundations.cis.upenn.edu/lf-current/toc.html             |
| 11. Metamath                                         | https://www.amazon.com/dp/1411637240 | http://us.metamath.org/downloads/metamath.pdf                             |
| 12. Types and Programming Languages                  | https://www.amazon.com/dp/0262162091 | |

## Notes

1. This is an introductory textbook. It covers mathematical logic and proofs, type theory, and finally dependent types using the programming language Idris. Afterwards, it uses dependent types to prove correctness of programs, for example, using induction to prove the correctness of `length`.
2. Introduces the reader to mathematical logic, proofs, and some set theory.
3. Even if you don't program in Haskell after reading this, it introduces you to a lot of good concepts (which some can be applied to other programming languages as well). Pattern matching, Algebraic data types, Monads/Monoids, Map/Reduce and their implementation, Currying, etc.
4. This book really helped me grasp recursion, and Scheme.
5. This is a classic. I believe any programmer should at least be aware of the things C offers, like manual memory management, working with stacks, etc. This is found to be useful even when programming in higher level languages. For example, whenever you create an anonymous function in JS, given its scope change we can see it as the stack frame change.
6. Introduces the reader to common programming patterns, such as DRY, keeping up to date with tools, etc.
7. **Work in progress**. Covering some general concepts about programming, such as: abstraction, recursion, DSLs, streams, etc.
8. Assumes at least some JavaScript experience. Introduces the reader to some useful JavaScript patterns. Also, JavaScript is used a lot these days, so it's preferable we keep up to date :)
9. **Work in progress**. Algorithms and complexitiy.
10. **Work in progress**. Logical foundations, covering functional programming, logic, theorem proving and Coq.
11. An interesting metalanguage for working with formal systems, and formalizing mathematical proofs. Specifications of the language is only 4 pages.
12. **Work in progress**. Theory and implementation of types in programming languages.

# Tutorials/papers

| Name                    | URL                                                                        |
| ----------------------- | -------------------------------------------------------------------------- |
| 1. Win32asm tutorial    | http://www.madwizard.org/download/tutors/win32asmtutorial.zip              |
| 2. DBMS Lecture Notes   | http://www.cs.sfu.ca/CourseCentral/354/zaiane/material/notes/contents.html |
| 3. Lambda calculus      | https://en.wikipedia.org/wiki/Lambda__calculus                             |
| 4. Prolog               | https://staff.science.uva.nl/u.endriss/teaching/prolog/prolog.pdf          |
| 5. Idris tutorial       | http://docs.idris-lang.org/en/latest/tutorial/                             |
| 6. McCarthy's LISP      | http://www-formal.stanford.edu/jmc/recursive.pdf                           |
| 7. Hoare logic          | https://www.cs.cmu.edu/~crary/819-f09/Hoare69.pdf                          |
| 8. LambdaPi tutorial    | https://www.andres-loeh.de/LambdaPi/LambdaPi.pdf                           |
| 9. Int. Type Theory     | https://archive-pml.github.io/martin-lof/pdfs/Bibliopolis-Book-retypeset-1984.pdf |

## Notes

1. I read this tutorial a long time ago. It helped me understand 32-bit assembly in Windows.
2. The theory behind DB systems. Relational algebra, etc.
3. An interesting way to declare integers (and other objects) in terms of f(x), f(f(x)), etc.
4. Prolog was fun for me because it's a different non-mainstream paradigm and also introduces some interesting concepts.
5. Idris is an interesting functional programming language with dependent types that is combined with IO support.
6. Recursive Functions of Symbolic Expressions and Their Computation by Machine describes the LISP programming system.
7. An Axiomatic Basis for Computer Programming introduces Hoare logic.
8. A tutorial for implementing dependently typed lambda calculus in Haskell.
9. Intuitionistic type theory.

# Misc. reading

| Name                                   | URL                                                                                         |
| -------------------------------------- | ------------------------------------------------------------------------------------------- |
| 1. A Mathematician's Lament            | https://www.maa.org/external_archive/devlin/LockhartsLament.pdf                             |
| 2. The Laws of Simplicity              | https://www.amazon.com/dp/0262134721                                                        |
| 3. Redesigning Leadership              | https://www.amazon.com/dp/0262015889                                                        |
| 4. How to think like Sherlock Holmes   | https://www.amazon.com/dp/014312434X                                                        |
| 5. Propositions as Types               | http://homepages.inf.ed.ac.uk/wadler/papers/propositions-as-types/propositions-as-types.pdf |
| 6. The Alchemist                       | https://www.amazon.com/dp/0061122416                                                        |

## Notes

1. Criticizes the present mathematical education.
2. General interesting rules about design, technology, business, and life.
3. Interesting observations on how leaders should lead.
4. A mix of story telling and psychological observations.
5. Historical overview of how the concept Props as Types was developed (e.g. `forall n, n + 0 = 0 : Prop`.)
6. Life.

Boro Sitnikovski
