(define (problem packaging_line_ITm) 
(:domain ITM)
(:objects
	            dx10 - dosaxeMachine
	            yx10 - CartonerMachine 
	            vx10 - VerticalStoreMachine
	            i00_arret - emsb
	            i06_iraval - downstreamPresenceSensor 
	            i03_irpot - siloPresenceSensor 
	            i05_irprod - siloLevelSensor
	            agent_01 - logicalAgent
	            operateur_A - operator
	            RAM_01 - robot
	            billes_Plastique - rawMaterial
	            pot_01 pot_02 pot_03 pot_04 pot_05 pot_06 - product
	)
(:init
    ;(running dx10) (running yx10) (running vx10)
    (HasComponent dx10 i06_iraval) (HasComponent dx10 i03_irpot) (HasComponent dx10 i05_irprod) (HasComponent dx10 i06_iraval) (HasComponent dx10 i00_arret)
    ;(presenceDetected i03_irpot)
    ;(presenceDetected i05_irprod)
    ;(presenceDetected i06_iraval)
    ;(accumulationDetected dx10)
    ;(levelOk i05_irprod)
    (available operateur_A) (handUmpty operateur_A)
    (available RAM_01) (handUmpty RAM_01)

    
)

(:goal (and
      (paused dx10) (paused yx10) (paused vx10)
	)
)
)
