#lang racket
(define (how-many-positives lst)
  (cond [(null? lst) 0]                                          
        [(> (car lst) 0) (+ 1 (how-many-positives (cdr lst)))]   
        [else (how-many-positives (cdr lst))]))                              

(define (count a lst)
  (cond [(null? lst) 0]
        [(= (car lst) a) (+ 1 (count a (cdr lst)))]
        [else (count a (cdr lst))]))

(how-many-positives '(-1 2 -3 4 -5)) ; 2
(how-many-positives '()) ; 0
(how-many-positives '(-1 -2 3 -4 -5)) ; 1

(count 5 '()) ; 0
(count 5 '(1 9 7 5 4 2)) ; 1
(count 5 '(1 5 2 3 5)) ; 2