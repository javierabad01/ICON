(deftemplate oav-u "Plantilla Hechos univaluados"
	(slot objeto (type SYMBOL))
	(slot atributo(type SYMBOL))
	(slot valor)
)
(deftemplate oav-m "Plantilla Hechos multivaluados"
	(slot objeto (type SYMBOL))
	(slot atributo(type SYMBOL))
	(multislot valor)
)

(defrule garantizar-univaluados
    (declare (salience 10000))
    ?x <- (oav-u (objeto ?o1) (atributo ?a1) (valor ?v1))
    ?y <- (oav-u (objeto ?o1) (atributo ?a1) (valor ?v2))
    (test (> (fact-index ?x) (fact-index ?y)))
=>
(retract ?y)) 



;
; Reglas para determinar el escenario
;
(defrule Solicitar-escenario "regla para solicitar por pantalla la seleccion de un numero"
	(declare (salience 1000))
=> 
	(printout T crlf crlf "Bienvenido al asistente para el diagnostico de dispositivos electronicos." crlf)
	(printout T "Dispone de tres dispositivos para diagnosticar." crlf "Responde 1 para el primer escenario-movil, 2 para el segundo-tablet y 3 para el tercero-portatil:")
	(assert (escenario =(read T))) 
	(printout T crlf)
)

(defrule Comprobar-escenario "regla para comprobar que el escenario introducido es correcto (1-3)"
	(declare (salience 1000))
	(escenario ?x) 
	(not (escenario 1))
	(not (escenario 2))
	(not (escenario 3))
=>
	(reset)
	(run)
)

(defrule Activar-escenario-1 "regla que tiene como precondicion escenario 1, es decir que se haya elegido el escenario 1"
	(declare (salience 1000))
	(escenario 1) 

=>
	(assert (oav-u (objeto movil) (atributo antiguedad) (valor 14)))
	(assert (oav-u (objeto movil) (atributo sistema-operativo) (valor actual)))
	(assert (oav-m (objeto movil) (atributo fallo-presente) (valor se-apaga-inesperadamente)))
)

(defrule Activar-escenario-2 "regla que tiene como precondicion escenario 2, es decir que se haya elegido el escenario 2"
	(declare (salience 1000))
	(escenario 2) 

=>
	(assert (oav-u (objeto tablet) (atributo antiguedad) (valor 20)))
	(assert (oav-u (objeto tablet) (atributo sistema-operativo) (valor actual)))
	(assert (oav-m (objeto tablet) (atributo fallo-presente) (valor error-arranque)))
	(assert (oav-m (objeto tablet) (atributo fallo-presente) (valor ficheros-corruptos)))
)

(defrule Activar-escenario-3 "regla que tiene como precondicion escenario 3, es decir que se haya elegido el escenario 3"
	(declare (salience 1000))
	(escenario 3) 

=>
	(assert (oav-u (objeto portatil) (atributo antiguedad) (valor 30)))
	(assert (oav-u (objeto portatil) (atributo sistema-operativo) (valor no-actual)))
	(assert (oav-m (objeto portatil) (atributo fallo-presente) (valor no-enciende)))
)

(defrule en-revision " regla que comprueba si se puede tener revision"
		(oav-u (objeto ?x) (atributo antiguedad) (valor ?v &:(<= ?v 24)))
		(oav-u  (objeto ?x) (atributo sistema-operativo) (valor actual))
=>
        (assert (oav-u (objeto ?x) (atributo estado) (valor en-revision)))

)  

(defrule rechazado "regla que comprueba que no puede tener revision"
		(oav-u (objeto ?x)(atributo sistema-operativo))
		(or (oav-u (objeto ?x) (atributo antiguedad) (valor ?v &:(> ?v 24)))
		    (oav-u  (objeto ?x) (atributo sistema-operativo) (valor no-actual)))
=>
        (assert (oav-u (objeto ?x) (atributo estado) (valor rechazado)))

)  


(defrule error-sistema-operativo  "regla que comprueba que el fallo sear por el so"
        (oav-u (objeto ?x) (atributo estado) (valor en-revision))
        (or (oav-m (objeto ?x) (atributo fallo-presente) (valor error-arranque))
	    (oav-m  (objeto ?x) (atributo fallo-presente) (valor ficheros-corruptos)))

=>
        (assert (oav-m (objeto ?x) (atributo diagnostico) (valor error-sistema-operativo)))
)  


(defrule falloalimentacion  "regla que comprueba que el fallo sea por problema de alimentacion"
        (oav-u (objeto ?x)(atributo estado)(valor en-revision))			
        (oav-m  (objeto ?x)(atributo fallo-presente)(valor fallo-bateria))
	(or (oav-m  (objeto ?x)(atributo fallo-presente)(valor se-apaga-inesperadamente))
            (oav-m  (objeto ?x)(atributo fallo-presente)(valor no-enciende)))
=>
        (assert (oav-m (objeto ?x)(atributo diagnostico)(valor fallo-alimentacion)))
)  


(defrule mal-uso "regla que comprueba que los fallos sean por mal uso"
       (oav-m (objeto ?x)(atributo diagnostico) (valor fallo-alimentacion))			
       (oav-m (objeto ?x)(atributo fallo-presente)(valor golpes))

=>
       (assert (oav-m (objeto ?x)(atributo diagnostico)(valor mal-uso)))
)  
     
(defrule informar
	(declare (salience -1000))
	(oav-m(objeto ?x)(atributo diagnostico)(valor ?v))
	=>
	(printout t "El dispositivo " ?x " presenta el fallo " ?v crlf)
)

(defrule informar2
	(declare (salience -1000))
	(oav-u (objeto ?x)(atributo sistema-operativo))
	(not (oav-m (objeto ?x)(atributo diagnostico)(valor ?valor)))
	(not (oav-u (objeto ?x)(atributo estado)(valor rechazado)))

	=>
	(printout t "El dispositivo " ?x " no puede ser diagnosticado."crlf)
)

(defrule informar3
	(declare (salience -1000))
	(oav-u (objeto ?x)(atributo estado)(valor rechazado))
	=>
	(printout t "El dispositivo " ?x " ha sido rechazado por no estar en garantia o no tener un sistema operativo actual."crlf)
)


