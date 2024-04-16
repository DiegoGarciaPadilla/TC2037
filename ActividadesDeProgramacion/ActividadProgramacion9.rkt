#lang racket

;; sumatoria list -> number

(define sumatoria_aux
    (lambda (lst ac)
        (cond
            [(empty? lst) ac]
            [else (sumatoria_aux (cdr lst) (+ ac (car lst)))]
        )
    )
)

(define sumatoria
    (lambda (lst)
        (sumatoria_aux lst 0)
    )
)

;; incrementa list -> list

(define incrementa_aux
    (lambda (lst ac)
        (cond
            [(empty? lst) ac]
            [else (incrementa_aux 
                (cdr lst) 
                (append ac (list (+ (car lst) 1)))
            )]
        )
    )
)

(define incrementa
    (lambda (lst)
        (incrementa_aux lst '())
    )
)

;; Tests

(sumatoria '(1 2 3 4 5))
(incrementa '(1 2 3 4 5))