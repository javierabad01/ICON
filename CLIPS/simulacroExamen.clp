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


; HEchos iniciales de la memoria


(deffacts hechos "ejercicio 1"
	(oav-u (objeto movil) (atributo antiguedad) (valor 14))
	(oav-u (objeto movil) (atributo sistema-operativo) (valor actual))
	(oav-m (objeto movil) (atributo fallos) (valor apaga-inesperadamente))
	(oav-u (objeto tablet) (atributo antiguedad) (valor 20))
	(oav-u (objeto tablet) (atributo sistema-operativo) (valor actual))
	(oav-m (objeto tablet) (atributo fallos) (valor error-arranque ficheros-corruptos))
	(oav-u (objeto portatil) (atributo antiguedad) (valor 30))
	(oav-u (objeto portatil) (atributo sistema-operativo) (valor no-actual))
	(oav-m (objeto portatil) (atributo fallos) (valor no-enciende))
)


(defrule tiene-garantia "funcion paras saber si esta en garantia"
	(declare (salience 10000))
	(oav-u (objeto ?x) (atributo antiguedad) (valor ?y & :(< ?y 24)))
	=>
	(assert (oav-u (objeto ?x) (atributo garantia) (valor con-garantia)))
)

(defrule tiene-garantia "funcion paras saber si esta en garantia"
	(declare (salience 10000))
	(oav-u (objeto ?x) (atributo antiguedad) (valor ?y & :(< ?y 24)))
	=>
	(assert (oav-u (objeto ?x) (atributo garantia) (valor con-garantia)))
)


(defrule so-actual "funcion paras saber si el dispositivo tiene sistema operativo actual"
	(declare (salience 9999))
	(oav-u (objeto ?x) (atributo garantia) (valor con-garantia))
	(oav-u (objeto ?x) (atributo sistema-operativo) (valor actual))
	=>
	(assert (oav-u (objeto ?x) (atributo revision) (valor cumple-condiciones)))
)

(defrule no-so-actual "funcion paras saber si el dispositivo tiene sistema operativo actual"
	(declare (salience 9999))

	(not(oav-u (objeto ?x) (atributo sistema-operativo) (valor actual)))
	=>
	(assert (oav-u (objeto ?x) (atributo revision) (valor no-cumple-condiciones)))
)
(defrule no-so-actual "funcion paras saber si el dispositivo tiene sistema operativo actual"
	(declare (salience 9999))
	(not(oav-u (objeto ?x) (atributo garantia) (valor con-garantia)))
	=>
	(assert (oav-u (objeto ?x) (atributo revision) (valor no-cumple-condiciones)))
)