#lang racket

;; factorial: number => number
(define factorial
  (lambda (n)
    (if (= n 0)
        1
        (* n (factorial (- n 1))))))

;; pow: number number => number
(define pow
  (lambda (a b)
    (if (= b 0)
        1
        (* a (pow a (- b 1))))))

;; fib: number => number
(define fib
  (lambda (n)
    (if (<= n 2)
        1
        (+ (fib (- n 1)) (fib (- n 2))))))