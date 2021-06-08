;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Production line ITm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain ITM)
	(:requirements :strips :typing :negative-preconditions :equality)
	(:types     industrialMachine component agent product rawMaterial - object
	            emsb sensor - component
	            dosaxeMachine CartonerMachine VerticalStoreMachine - industrialMachine
	            irSensor - sensor
	            presenceSensor - irSensor
	            levelSensor - irSensor
	            upstreamPresenceSensor downstreamPresenceSensor siloPresenceSensor - presenceSensor ;chaque presenceSensor, correspond à une position de poduit 
	            siloLevelSensor - levelSensor
	            physicalAgent logicalAgent - agent
	            operator robot - physicalAgent
	)
	(:constants )
	(:predicates	
                	(poweredOn ?x - industrialMachine)
                	(initialized ?x - industrialMachine)
                	(paused ?x - industrialMachine)
                	(stopped ?x - industrialMachine)
                	(running ?x - industrialMachine)
                	(firstRun ?x - industrialMachine)
                	(hasCriticalProblem ?x - industrialMachine)
                	(accumulationDetected ?x - industrialMachine)
                	(emptySiloDetected ?x - dosaxeMachine)
                	(pushed ?e - emsb)
                	(presenceDetected ?ps - presenceSensor)
                	(levelOk ?ls - levelSensor)
                	(HasComponent ?x - industrialMachine ?c - component)
                	(available ?a - agent)
                	(handUmpty ?pa - physicalAgent)
                	(carrying ?pa - physicalAgent ?r - rawMaterial)
                	(productAt ?p - product ?ps - presenceSensor)
                	(filledProduct ?p - product)
                	(inStock ?r - rawMaterial)
  	)


;;; Operators
;;;;;;;;;;;;;;;;;

    (:action powerOn
	     :parameters (?x - industrialMachine ?a - physicalAgent)
	     :precondition (and (not(poweredOn ?x)) (not(initialized ?x)) (not(running ?x)) (available ?a))
	     :effect (and
	     			(poweredOn ?x) (firstRun ?x)
	     		)
	)
	(:action powerOff
	     :parameters (?x - industrialMachine ?a - physicalAgent)
	     :precondition (and (poweredOn ?x) (available ?a))
	     :effect (and
	     			(not(poweredOn ?x))
	     		)
	)
	(:action intialize
	     :parameters (?x - industrialMachine ?a - agent)
	     :precondition (and (not(initialized ?x)) (poweredOn ?x) (not(running ?x)) (available ?a))
	     :effect (and
	     			(initialized ?x)
	     		)
	)
	(:action re-intialize    ;Todo : Check different parameters for each type of machine (eg silo level for dosaxe)
	     :parameters (?x - industrialMachine ?a - agent)
	     :precondition (and (not(initialized ?x)) (poweredOn ?x) (available ?a) (stopped ?x))
	     :effect (and
	     			(initialized ?x)
	     		)
	)
	
	(:action initialRun
	     :parameters (?x - industrialMachine ?a - agent)
	     :precondition (and (firstRun ?x) (initialized ?x) (poweredOn ?x) (not(running ?x)) (available ?a) (not(hasCriticalProblem ?x))(not(accumulationDetected ?x))
	                        )
	     :effect (and
	     			(running ?x) (not(paused ?x)) (not(firstRun ?x))
	     		)
	)
	
	(:action runManually
	     :parameters (?x - industrialMachine ?a - agent)
	     :precondition (and (not(firstRun ?x)) (initialized ?x) (poweredOn ?x) (not(running ?x)) (available ?a) (not(hasCriticalProblem ?x))(not(accumulationDetected ?x))
	                        )
	     :effect (and
	     			(running ?x) (not(paused ?x))
	     		)
	)
	
	(:action runAutomatically
	     :parameters (?x - industrialMachine)
	     :precondition (and (not(firstRun ?x)) (initialized ?x) (poweredOn ?x) (not(running ?x)) (not(hasCriticalProblem ?x))(not(accumulationDetected ?x))
	                        )
	     :effect (and
	     			(running ?x) (not(paused ?x))
	     		)
	)
	
	(:action pauseManually
	     :parameters (?x - industrialMachine ?a - agent)
	     :precondition (and (running ?x) (available ?a))
	     :effect (and
	     			(not(running ?x)) (paused ?x)
	     		)
	)
    (:action pauseAccumulation
	     :parameters (?x - dosaxeMachine ?dps - downstreamPresenceSensor ?sps - siloPresenceSensor)
	     :precondition (and (running ?x) (HasComponent ?x ?dps) (HasComponent ?x ?sps) (presenceDetected ?dps) (presenceDetected ?sps))
	     :effect (and
	     			(accumulationDetected ?x) (not(running ?x)) (paused ?x)
	     		)
	)
	(:action pauseEmptySilo
	     :parameters (?x - dosaxeMachine ?sls - siloLevelSensor ?sps - siloPresenceSensor)
	     :precondition (and (running ?x) (HasComponent ?x ?sls) (HasComponent ?x ?sps)  (presenceDetected ?sps) (not(levelOk ?sls)))
	     :effect (and
	     			(emptySiloDetected ?x) (not(running ?x)) (paused ?x)
	     		)
	)
	(:action takeRawMaterial
	     :parameters (?pa - physicalAgent ?r - rawMaterial)
	     :precondition (and (available ?pa) (handUmpty ?pa) (inStock ?r))
	     :effect (and
	     			(not(available ?pa)) (not(handUmpty ?pa)) (carrying ?pa ?r)
	     		)
	)
	(:action reloadSilo
	     :parameters (?x - dosaxeMachine ?sls - siloLevelSensor ?pa - physicalAgent ?r - rawMaterial)
	     :precondition (and (emptySiloDetected ?x) (HasComponent ?x ?sls) (not(levelOk ?sls)) (carrying ?pa ?r))
	     :effect (and
	     			(not(carrying ?pa ?r)) (available ?pa) (levelOk ?sls) (not(emptySiloDetected ?x)) (running ?x)
	     		)
	)
	(:action pushEmsb
	     :parameters (?e - emsb ?x - industrialMachine ?a - agent)
	     :precondition (and (not(pushed ?e)) (not(stopped ?x)) (HasComponent ?x ?e) (available ?a) (hasCriticalProblem ?x))
	     :effect (and
	     			(pushed ?e) (stopped ?x) (not(running ?x)) (not(initialized ?x))
	     		)
	) 
	(:action freeEmsb
	     :parameters (?e - emsb ?x - industrialMachine ?a - agent)
	     :precondition (and (pushed ?e) (stopped ?x) (HasComponent ?x ?e) (not(running ?x)) (available ?a))
	     :effect (and
	     			(not(pushed ?e)) (not(hasCriticalProblem ?x))
	     		)
	) 
	(:action fillProduct
	        :parameters (?p - product ?x - industrialMachine ?sls - siloLevelSensor ?sps - siloPresenceSensor)
	     :precondition (and (running ?x) (HasComponent ?x ?sls) (HasComponent ?x ?sps) (levelOk ?sls)  (presenceDetected ?sps) (productAt ?p ?sps))
	     :effect (and
	     			(filledProduct ?p)
	     		)
	)
	(:action moveProduct
	     :parameters (?p - product ?x - industrialMachine ?ps1 - presenceSensor ?ps2 - presenceSensor)
	     :precondition (and (running ?x) (HasComponent ?x ?ps1) (HasComponent ?x ?ps2) (productAt ?p ?ps1) (not(presenceDetected ?ps2)))
	     :effect (and
	     			(not(productAt ?p ?ps1)) (productAt ?p ?ps2) (presenceDetected ?ps2)
	     		)
	) 
	
	(:action nop
	     :parameters ()
	     :precondition (and )
	     :effect (and )
	)                  


;;; Methods
;;;;;;;;;;;;;;;;;

)