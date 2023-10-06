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


; Hechos inicales de la memoria

(deffacts hechos "ejercicio 1" 
	(oav-u (objeto movil) (atributo antiguedad ) (valor 14 ) )
	(oav-u (objeto movil) (atributo sistema-operativo ) (valor actual ) )
	(oav-m (objeto movil) (atributo fallos-presentes) (valor se-apaga-inesperadamente ) )
	(oav-u (objeto tablet) (atributo antiguedad ) (valor 20 ) )
	(oav-u (objeto tablet) (atributo sistema-operativo ) (valor actual ) )
	(oav-m (objeto tablet) (atributo fallos-presentes) (valor error-en-el-arranque ) )
	(oav-m (objeto tablet) (atributo fallos-presentes) (valor ficheros-corruptos ) )
	(oav-u (objeto portatil) (atributo antiguedad ) (valor 30 ))
	(oav-u (objeto portatil) (atributo sistema-operativo ) (valor no-actual))
	(oav-m (objeto portatil) (atributo fallos-presentes) (valor no-enciende))
)

(defrule escenario-pantalla 
	(declare (salience 10000))
=>
	(printout t "Escenario: ")
	(bind ?respuesta (read))
	(assert (escenario1 ?respuesta))
)





(defrule en-garantia "Funcion que permite saber si un dispositivo esta en garantia"
	(declare (salience 9999 ) )
	(oav-u 	(objeto ?x ) (atributo antiguedad ) (valor ?a & :(< ?a 24) ) )
	=> 
	(assert (oav-u (objeto ?x ) (atributo garantia) (valor en-garantia )))
)

(defrule no-en-garantia "Funcion que permite saber si un dispositivo esta no esta en garantia"
	(declare (salience 9999 ) )
	(oav-u 	(objeto ?x ) (atributo antiguedad ) (valor ?a & :(> ?a 23) ) )
	=> 
	(assert (oav-u (objeto ?x ) (atributo  garantia) (valor no-en-garantia ) ) )
)

(defrule aplica-servicio "Funcion que permite saber si un dispositivo puede tener servicio tecnico"
	(declare (salience 9000 ) )
	(oav-u 	(objeto ?x ) (atributo garantia ) (valor en-garantia ) )
	(oav-u 	(objeto ?x ) (atributo sistema-operativo) (valor actual) )
	=> 
	(assert (oav-u (objeto ?x ) (atributo  servicio) (valor aplica-servicio ) ) )
)

(defrule no-aplica-servicio-por-garantia "Funcion que permite saber e informar de que un dispositivo no esta en periodo de garantia"
	(declare (salience 8000 ) )
	(oav-u 	(objeto ?x ) (atributo garantia ) (valor no-en-garantia ) )
	=> 
	(printout t "El dispositivo: " ?x " no posee garantia vigente, por lo tanto no puede obtener servicio " crlf)
)

(defrule problema-sistema-operativo-arranque "Funcion que permite saber que un dispositivo posee un problema en el sistema operativo"
	(declare (salience 7000 ))
	(oav-u (objeto ?x ) (atributo  servicio ) (valor aplica-servicio ))
	(or (oav-m (objeto ?x ) (atributo  fallos-presentes) (valor error-en-el-arranque ) )
	    (oav-m (objeto ?x ) (atributo  fallos-presentes) (valor ficheros-corruptos ) ) )
	=> 
	(assert (oav-m (objeto ?x ) (atributo  problema ) (valor sistema-operativo ) ) )
)



(defrule problema-sistema-alimentacion "Funcion que permite saber que un dispositivo posee un problema en el sistema de alimentacion"
	(declare (salience 7000 ))
	(oav-u (objeto ?x ) (atributo  servicio ) (valor aplica-servicio ))
	(oav-m (objeto ?x ) (atributo  fallos-presentes) (valor no-enciende ) )
	(oav-m (objeto ?x ) (atributo  fallos-presentes) (valor fallo-bateria ) )
	=>
	(assert(oav-m (objeto ?x ) (atributo  problema ) (valor sistema-alimentacion ) ) )
)


(defrule problema-mal-uso "Funcion que permite saber que un dispositivo ha sido mal usado por el propietario"
	(declare (salience 6000 ))
	(oav-u (objeto ?x ) (atributo  servicio ) (valor aplica-servicio ))
	(oav-m (objeto ?x ) (atributo  problema) (valor sistema-alimentacion ) )
	(oav-m (objeto ?x ) (atributo  fallos-presentes) (valor presenta-golpes ) )
	=>
	(assert (oav-m (objeto ?x ) (atributo  problema ) (valor mal-uso ) ) 
	)
)

(defrule imposible-diagnosticar "Funcion que permite informar que un dispositivo ha pasado a revisión pero no se ha podido dignosticar ningún problema"
	(declare (salience 5000 ) )
	(oav-u (objeto ?x ) (atributo  servicio ) (valor aplica-servicio ))
	(not (oav-m (objeto ?x ) (atributo  problema) (valor ?y)))
	
	=>
	(printout t "El dispositivo: " ?x " ha pasado a revision, pero no se ha podido diagnosticar ningún fallo para el. " crlf)
)

