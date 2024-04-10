#lang racket

(define duplicate
    (lambda (lst)
        (cond
            ((null? lst) '())
        (else (cons (car lst) (cons (car lst) (duplicate (cdr lst))))))))

(define positives
    (lambda (lst)
        (cond
            ((null? lst) '())
            ((>= (car lst) 0)
            (cons (car lst) (positives (cdr lst))))
        (else (positives (cdr lst))))))

(define list-of-symbols?
    (lambda (lst)
        (cond
            ((null? lst) #t)
            ((symbol? (car lst)) (list-of-symbols? (cdr lst)))
        (else #f))))

(define swapper
    (lambda (a b lst)
        (cond
            ((null? lst) '())
            ((equal? (car lst) a) (cons b (swapper a b (cdr lst))))
            ((equal? (car lst) b) (cons a (swapper a b (cdr lst))))
        (else (cons (car lst) (swapper a b (cdr lst)))))))

(define dot-product
    (lambda (a b)
        (cond
            ((null? a) 0)
            ((null? b) 0)
        (else (+ (* (car a) (car b)) (dot-product (cdr a) (cdr b)))))))

;; Tests

(duplicate '())
(duplicate '(1 2 3 4 5))
(duplicate '(a b c d e f g h))

(positives '())
(positives '(12 -4 3 -1 -10 -13 6 -5))
(positives '(-4 -1 -10 -13 -5))

(list-of-symbols? '())
(list-of-symbols? '(a b c d e))
(list-of-symbols? '(a b c d 42 e))

(swapper 1 2 '())
(swapper 1 2 '(4 4 5 2 4 8 2 5 6 4 5 1 9 5 9 9 1 2 2 4))
(swapper 1 2 '(4 3 4 9 9 3 3 3 9 9 7 9 3 7 8 7 8 4 5 6))
(swapper 'purr 'kitty '(soft kitty warm kitty little ball of fur happy kitty sleepy kitty purr purr purr))

(dot-product '() '())
(dot-product '(1 2 3) '(4 5 6))
(dot-product '(1.3 3.4 5.7 9.5 10.4) '(-4.5 3.0 1.5 0.9 0.0))
