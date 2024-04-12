#lang racket

;; args-swap procedure => procedure
(define (args-swap f)
    (lambda (x y) (f y x)))

;; there-exists-one? pred list => bool
(define (there-exists-one? p lst)
    (= 1 (count p lst)))

;; linear-search list x eq-funct => symbol
(define (linear-search lst x eq-fun)
    (define (search-helper i)
        (cond 
            ((eq-fun (list-ref lst i) x) i)
        (else #f)))
    (let ((indices (range (length lst))))
        (ormap search-helper indices)))

;; Tests

((args-swap list) 1 2)
((args-swap /) 8 2)
((args-swap cons) '(1 2 3) '(4 5 6))
((args-swap map) '(-1 1 2 5 10) /)

(there-exists-one? positive? '())
(there-exists-one? positive? '(-1 -10 4 -5 -2 -1))
(there-exists-one? negative? '(-1))
(there-exists-one? symbol? '(4 8 15 16 23 42))
(there-exists-one? symbol? '(4 8 15 sixteen 23 42))

(linear-search '() 5 =)
(linear-search '(48 77 30 31 5 20 91 92 69 97 28 32 17 18 96) 5 =)
(linear-search '("red" "blue" "green" "black" "white") "black" string=?)
(linear-search '(a b c d e f g h) 'h equal?)