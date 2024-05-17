#lang racket

;; Función para encontrar transiciones a partir de un estado dado
(define (encontrarTransiciones inicial transiciones)
    (cond
        ((null? transiciones) '()) ; Caso base: no hay más transiciones
        ((equal? (caar transiciones) inicial) ; Si la transición actual comienza desde el estado inicial
         (cons (car transiciones) (encontrarTransiciones inicial (cdr transiciones)))) ; Agregar la transición al resultado y continuar buscando
        (else (encontrarTransiciones inicial (cdr transiciones))))) ; Continuar buscando transiciones

;; Función para encontrar transiciones con símbolos de una lista dada
(define (encontrarSimbolos transiciones simbolos)
    (cond
        ((null? transiciones) '()) ; Caso base: no hay más transiciones
        ((encontrarSimbolo (cadar transiciones) simbolos) ; Si el símbolo de la transición actual está en la lista de símbolos
         (cons (car transiciones) (encontrarSimbolos (cdr transiciones) simbolos))) ; Agregar la transición al resultado y continuar buscando
        (else (encontrarSimbolos (cdr transiciones) simbolos)))) ; Continuar buscando transiciones

;; Función auxiliar para encontrar un símbolo en una lista de símbolos
(define (encontrarSimbolo simbolo simbolos)
    (cond
        ((null? simbolos) #f) ; Caso base: no hay más símbolos
        ((equal? simbolo (car simbolos)) #t) ; Si el símbolo actual coincide con el símbolo buscado
        (else (encontrarSimbolo simbolo (cdr simbolos))))) ; Continuar buscando símbolos

;; Función para buscar transiciones alcanzables desde un estado inicial con símbolos de una lista dada
(define (buscarTransiciones inicial transiciones simbolos)
    (encontrarSimbolos (encontrarTransiciones inicial transiciones) simbolos)) ; Encontrar transiciones que comienzan desde el estado inicial y tienen símbolos de la lista

;; Función para moverse al siguiente estado basado en una transición, lista de entrada, estados finales, transiciones y símbolos
(define (mover transicion listaEntrada finales transiciones simbolos)
    (cond
        ((and (encontrarEstadoFinal (caddr transicion) finales) (null? listaEntrada)) #t) ; Si la transición actual lleva a un estado final y no hay más símbolos de entrada
        ((not (equal? (buscarTransiciones (caddr transicion) transiciones simbolos) '())) ; Si hay transiciones alcanzables desde el siguiente estado
         (buscarTransiciones (caddr transicion) transiciones simbolos)) ; Moverse al siguiente estado
        (else #f))) ; No se puede mover al siguiente estado

;; Función auxiliar para encontrar un estado final en una lista de estados finales
(define (encontrarEstadoFinal estado finales)
    (cond
        ((null? finales) #f) ; Caso base: no hay más estados finales
        ((equal? estado (car finales)) #t) ; Si el estado actual coincide con el estado final buscado
        (else (encontrarEstadoFinal estado (cdr finales))))) ; Continuar buscando estados finales

;; Función para verificar si la lista de entrada es aceptada por el autómata
(define (verificar listaEntrada transicionesAlcanzables finales transiciones simbolos)
    (cond
        ((or (null? transicionesAlcanzables) (null? listaEntrada)) #f) ; Caso base: no hay más transiciones alcanzables o símbolos de entrada
        ((equal? transicionesAlcanzables #t) #t) ; Caso base: se alcanzó un estado de aceptación
        ((equal? transicionesAlcanzables #f) #f) ; Caso base: no se puede alcanzar un estado de aceptación
        ((equal? (cadar transicionesAlcanzables) (car listaEntrada)) ; Si el símbolo de la transición alcanzable actual coincide con el símbolo de entrada actual
         (mover (car transicionesAlcanzables) (cdr listaEntrada) finales transiciones simbolos)) ; Moverse al siguiente estado
        (else (verificar listaEntrada (cdr transicionesAlcanzables) finales transiciones simbolos)))) ; Continuar verificando con las transiciones alcanzables restantes

;; Función para obtener el resultado de verificar múltiples listas de entrada contra el autómata
(define (resultadoEntrada listaEntrada transicionesAlcanzables finales transiciones simbolos)
    (cond
        ((null? listaEntrada) #f) ; Caso base: no hay más listas de entrada
        (else
         (let ((resultado (verificar listaEntrada transicionesAlcanzables finales transiciones simbolos))) ; Verificar la lista de entrada actual
             (cond
                 ((equal? resultado #f) #f) ; Caso base: la lista de entrada no es aceptada
                 ((equal? resultado #t) #t) ; Caso base: la lista de entrada es aceptada
                 (else (resultadoEntrada (cdr listaEntrada) (verificar listaEntrada transicionesAlcanzables finales transiciones simbolos) finales transiciones simbolos))))))) ; Continuar verificando con las listas de entrada restantes

;; Función para validar las listas de entrada contra el autómata
(define (validate descripcionAutomata listaEntrada)
    (let ((estados (car descripcionAutomata))
                (simbolos (cadr descripcionAutomata))
                (transiciones (caddr descripcionAutomata))
                (inicial (cadddr descripcionAutomata))
                (finales (car (cddddr descripcionAutomata))))
        (cond
            ((null? listaEntrada) '()) ; Caso base: no hay más listas de entrada
            (else
             (let ((transicionesAlcanzables (buscarTransiciones inicial transiciones simbolos))) ; Encontrar transiciones alcanzables desde el estado inicial
                 (append (list (resultadoEntrada (car listaEntrada) transicionesAlcanzables finales transiciones simbolos)) ; Verificar la lista de entrada actual
                                 (validate descripcionAutomata (cdr listaEntrada)))))))) ; Continuar validando con las listas de entrada restantes

;; Pruebas

(validate '((A B C D E F G H I)
            (a b)
            ((A a B) (A b C) (B a D) (B b E) (C a B) (C b C) (D a F) (D b G) (E a H) (E b I) (F a F) (F b G) (G a H) (G b I) (H a F) (H b G) (I a H) (I b I))
            A
            (D E F G H I))
          '((a b a b a b a a) (b b b) (a a a a a a a b b b b b b b)))
; '(#t #f #t)

(validate
   '((A B C D E F)
  (0 1)
  ((A 0 B) (A 1 C)
   (B 0 D) 
   (C 0 D)
   (D 0 E) (D 1 F)
   (E 0 E) (E 1 F)
   (F 0 E) (F 1 F))
   A
  (D E F))
'((1 0 1 1 1 1 1 1 1 1 1) (1 0 0 0 0 0 0) (1 1 1 1 1 1 1) (1 1 1 1 1 1 1 0)))
; '(#t #t #f #f)



(validate 
    '((A B C D E F G H I)
      (0 1)
      ((A 0 B) (A 1 C) (B 0 D) (B 1 E) (C 0 B) (C 1 C) (D 0 F) (D 1 E) (E 0 G) (E 1 C) (F 0 H) (F 1 E) (G 0 I) (G 1 E) (H 0 H) (H 1 E) (I 0 F) (I 1 E))
      A
      (H I))
    '((0 1 1 1 0 0 1 0 1) (0 1 1 1 0 0 1 0 1) (0 1 1 1 1 1 1 1 0) (1 1 1 1 1 1 1 0 1 0 0)))
; '(#f #f #f #t)



(validate
   '((A B C D E F G)
  ({ })
  ((A w B) 
   (B w C) (B 7 D)
   (C w E) (C 7 D)
   (D w F) (D 7 D)
   (E w E) (E 7 G)
   (F w F) (F 7 G)
   (G w F) (G 7 D))
   A
   (G))
'((7 w 7 w 7 w) (w w 7 7 7 7 w 7) (w w 7) (w 7 w w w)))
; '(#f #t #f #f)