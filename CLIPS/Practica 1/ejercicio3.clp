;(deffacts escenario1
;    (comportamientoMotor observacion noArranca)
;    (bateria indicador cero)
;)

;(deffacts escenario2
;    (comportamientoMotor observacion sePara)
;    (combustible indicador cero)
;)
(deffacts escenarioExtra
    (comportamientoMotor observacion noArranca)
    (fusible observacion roto)
)

(defrule R1 "estado intermedio potendia desconectada" 
(comportamientoMotor observacion noArranca)
=>
(assert (potencia estado desconectada)))

(defrule R2 "estado intermedio combuistible en motor falso"
(comportamientoMotor observacion noArranca)
(comportamientoMotor observacion sePara)
=>
(assert (combustible estado falso)))

(defrule R3 "estado intermedio combuistible en motor falso"
(comportamientoMotor observacion sePara)
=>
(assert (combustible estado falso)))



(defrule R4 "estado inicial"
(potencia estado desconectada)
(fusible observacion roto)
=>
(assert (fusible estado fundido)))

(defrule R5 "estado inicial5"
(potencia estado desconectada)
(bateria indicador cero)
=>
(assert (bateria estado baja)))
 
(defrule R6 "estado inicial1"
(combustible estado falso)
(combustible indicador cero)
=>
(assert (combustible deposito vacio)))



