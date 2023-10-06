;Definimos las plantillas

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

;Garantizar semántica univaluada
(defrule garantizar-univaluados
	(declare (salience 10000))
	?f1 <- (oav-u (objeto ?o1) (atributo ?a1) (valor ?v1))
	?f2 <- (oav-u (objeto ?o1) (atributo ?a1) (valor ?v2))
	(test (neq ?f1 ?f2))
=>
	(retract ?f2)
)

;Datos iniciales del paciente Maria
(deffacts datos-maria
	(oav-u (objeto maria)
	(atributo sexo)
	(valor mujer))
	(oav-u (objeto maria)
	(atributo edad)
	(valor 10))
	(oav-m (objeto maria)
	(atributo sintomas)
	(valor fiebre))
	(oav-m (objeto maria)
	(atributo evidencia)
	(valor rumor-diastolico))
	(oav-u (objeto maria)
	(atributo presion-sistolica)
	(valor 130))
	(oav-u (objeto maria)
	(atributo presion-diastolica)
	(valor 60))
)

;Datos iniciales del paciente Pedro
(deffacts datos-pedro
	(oav-u (objeto pedro)
	(atributo sexo)
	(valor hombre))
	(oav-u (objeto pedro)
	(atributo edad)
	(valor 80))
	(oav-m (objeto pedro)
	(atributo sintomas)
	(valor dolor-pecho))
	(oav-m (objeto pedro)
	(atributo evidencia)
	(valor rumor-sistólico dilatacion-corazon))
	(oav-u (objeto pedro)
	(atributo presion-sistolica)
	(valor 150))
	(oav-u (objeto pedro)
	(atributo presion-diastolica)
	(valor 95))
)

;Descripcion enfermedades <13>
(deffacts enfermedades
	(oav-m (objeto aneurisma)
	(atributo afecta)
	(valor vasos-sanguineos))
	(oav-m (objeto arteriosclerosis)
	(atributo afecta)
	(valor vasos-sanguineos))
	(oav-m (objeto estenosis-arterial)
	(atributo afecta)
	(valor vasos-sanguineos))
	(oav-m (objeto regurgitacion-aortica)
	(atributo afecta)
	(valor corazon))
)



;Reglas de clasificación
	(defrule enfermedad-cardiovascular-1
	(oav-m (objeto ?x)
	(atributo afecta)
	(valor vasos-sanguineos))
	=>
	(assert (oav-m (objeto ?x)
	(atributo tipo)
	(valor cardio-vascular))))
	(defrule enfermedad-cardiovascular-2
	(oav-m (objeto ?x)
	(atributo afecta)
	(valor corazon))
	=>
	(assert (oav-m (objeto ?x)
	(atributo tipo)
	(valor cardio-vascular))))





;Dolor abdominal que conlleva una aneurisma de la arteria abdominal <15>
(defrule dolor-abdominal-aneurisma
	(oav-m (objeto ?x)
	(atributo evidencia)
	(valor $? rumor-abdominal $?))
	(oav-m (objeto ?x)
	(atributo evidencia)
	(valor $? masa-pulsante $?))
	=>
	(assert(oav-m (objeto ?x)
	(atributo diagnostico)
	(valor dolor-abdominal-aneurisma)))
)

;Regurgitacion aortica <16>
(defrule regurgitacion-aortica
	(oav-u (objeto ?x)
	(atributo presion-sistolica)
	(valor ?max & :(> ?max 130)))
	(oav-u (objeto ?x)
	(atributo presion-pulso)
	(valor ?min & :(> ?min 50)))
	(or (oav-m (objeto ?x) (atributo evidencia) (valor $? rumor-sistolico $?))
	(oav-m (objeto ?x) (atributo evidencia) (valor $? dilatacion-corazon $?)))
	=>
	(assert (oav-m (objeto ?x)
	(atributo diagnostico)
	(valor regurgitacion-aortica)))
)

;Sacar el valor de la presion del pulso
(defrule presion-pulso
	(oav-u (objeto ?x)
	(atributo presion-sistolica)
	(valor ?y))
	(oav-u (objeto ?x)
	(atributo presion-diastolica)
	(valor ?z))
	=>
	(bind ?resultado (- ?y ?z))
	(assert (oav-u (objeto ?x) 
	(atributo presion-pulso)
	(valor ?resultado)))
)
;Enfermedad estenosis de la arteria en la pierna producida por calambres
(defrule estenosis-arteria-pierna
	(oav-m (objeto ?x)
	(atributo sintomas)
	(valor $? calambres-pierna $?))
	=>
	(assert(oav-m(objeto ?x)
	(atributo diagnostico)
	(valor estenosis-arteria-pierna)))
)

;Enfermedad arterioscleroris producida por la estenosis
(defrule arteriosclerosis
	(oav-m (objeto ?x)
	(atributo sintomas)
	(valor estenosis-arteria-pierna))
	(oav-m (objeto ?x)
	(atributo estado)
	(valor riesgo))
	=>
	(assert(oav-m(objeto ?x)
	(atributo diagnostico)
	(valor arteriosclerosis)))
)
	
;Riesgo de obesidad
(defrule riesgo-1
	(oav-u (objeto ?x)
	(atributo peso)
	(valor obeso))
	=>
	(assert (oav-u (objeto ?x)
	(atributo estado)
	(valor riesgo)))
)

;Riesgo por fumador
(defrule riesgo-2
	(oav-u (objeto ?x)
	(atributo fuma)
	(valor ?tiempo & :(> ?tiempo 10)))
	=>
	(assert (oav-u (objeto ?x)
	(atributo estado)
	(valor riesgo)))
)

;Riesgo por edad
(defrule riesgo-3
	(oav-u (objeto ?x)
	(atributo edad)
	(valor ?y & :(> ?y 55)))
	=>
	(assert (oav-u (objeto ?x)
	(atributo estado)
	(valor riesgo)))
)	
	





;Información lanzada al usuario
(defrule informar
	(declare (salience -1000))
	(oav-m(objeto ?x)
	(atributo diagnostico) 
	(valor $? ?d $?))
	(oav-m(objeto ?d)
	(atributo tipo) 
	(valor $? ?ti $?))
	(oav-m(objeto ?d)
	(atributo afecta)
	(valor $? ?a $?))
	=>
	(printout t "El paciente " ?x " sufre " ?d ", es una enfermedad "
	?ti " que afecta a " ?a crlf)
)

(defrule imprime_no_enfermo "Imprime por salida estandar que no padecemos  ninguna enfermedad"
	(declare (salience -10000))	
	(oav-u (objeto ?x)
	(atributo presion-pulso)
	(valor ?y))
	(not (oav-m (objeto ?x)
	(atributo diagnostico)
	(valor ?d))) 
	=>
	(printout t "El paciente " ?x " no padece ninguna enfermedad." crlf)
)









