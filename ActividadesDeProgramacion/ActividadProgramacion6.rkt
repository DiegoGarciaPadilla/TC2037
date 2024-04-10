#lang racket

;; list => list
(define (enlist lst)
    (cond
      ((null? lst) '())
      (else (cons (list(car lst)) (enlist(cdr lst))))))


;: list => list
(define (invert-pairs lst)
  (cond
    ((null? lst) '())
    (else (cons (list(cadar lst) (caar lst)) (invert-pairs (cdr lst))))))
    

;; list => list
(define (deep-reverse lst)
  (cond
    ((null? lst) '())
    ((not (list? lst)) lst)
    (else (append (deep-reverse (cdr lst)) (list (deep-reverse (car lst)))))))

;; list => list
(define (pack lst)
  (define (pack-helper lst current-group packed-list)
    (cond
      ((null? lst)
       (if (not (null? current-group))
           (append packed-list (list current-group))
           packed-list))
      ((null? current-group)
       (pack-helper (cdr lst) (list (car lst)) packed-list))
      ((equal? (car lst) (car current-group))
       (pack-helper (cdr lst) (cons (car lst) current-group) packed-list))
      (else
       (pack-helper (cdr lst) (list (car lst)) (append packed-list (list current-group))))))

  (pack-helper lst '() '()))

;; list => list
(define (encode lst)
  (define (pack lst)
    (define (pack-helper lst current-group packed-list)
      (cond
        ((null? lst)
         (if (not (null? current-group))
             (append packed-list (list current-group))
             packed-list))
        ((null? current-group)
         (pack-helper (cdr lst) (list (car lst)) packed-list))
        ((equal? (car lst) (car current-group))
         (pack-helper (cdr lst) (cons (car lst) current-group) packed-list))
        (else
         (pack-helper (cdr lst) (list (car lst)) (append packed-list (list current-group))))))
    (pack-helper lst '() '()))

  (define (transform-group group)
    (list (length group) (car group)))

  (map transform-group (pack lst)))


;; Test

(enlist '())
(enlist '(a b c))
(enlist '((1 2 3) 4 (5) 7 8))

(invert-pairs '())
(invert-pairs '((a 1)(a 2)(b 1)(b 2)))
(invert-pairs '((January 1)(February 2)(March 3)))

(deep-reverse '())
(deep-reverse '(a (b c d) 3))
(deep-reverse '((1 2) 3 (4 (5 6))))
(deep-reverse '(a (b (c (d (e (f (g (h i j)))))))))

(pack '())
(pack '(a a a a b c c a a d e e e e))
(pack '(1 2 3 4 5))
(pack '(9 9 9 9 9 9 9 9 9))

(encode '())
(encode '(a a a a b c c a a d e e e e))
(encode '(1 2 3 4 5))
(encode '(9 9 9 9 9 9 9 9 9))