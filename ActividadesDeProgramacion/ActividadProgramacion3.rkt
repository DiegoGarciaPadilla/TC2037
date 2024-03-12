 racket

;; sign number => number
(define sing
  (lambda (number)
    (cond
      [(> number 0) 1]
      [(= number 0) 0]
      [(< number 0) -1])))

;; bmi number number => string
(define bmi
  (lambda (weight height)
    (
      cond
      [(>= (/ weight (* height height)) 40) 'obese3]
      [(>= (/ weight (* height height)) 30) 'obese2]
      [(>= (/ weight (* height height)) 25) 'obese1]
      [(>= (/ weight (* height height)) 20) 'normal]
      [(<  (/ weight (* height height)) 20) 'underweight]
    )))