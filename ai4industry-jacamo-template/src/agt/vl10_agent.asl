/* 
Agent controlling the storage rack.

It acts on a Thing described by:
https://ci.mines-stetienne.fr/kg/itmfactory/vl10
It has:
- the following action affordances:
-- pressEmergencyStop
-- pickItem
- the following property affordances:
-- positionX
-- capacity
-- positionZ
-- conveyorSpeed
-- clampStatus
-- stackLightStatus

@author Olivier Boissier (Mines Saint-Etienne), Victor Charpenay (Mines Saint-Etienne)
*/

/*
An agent's state is roughly composed of beliefs (logical statements, as in Prolog) and goals (syntactically represented as atomic statements prefixed with '!'). The following line initializes the agent's state with a belief that gives what credentials it should use to interact with the VL10 workshop.

TODO: replace N with your group number (to obtain e.g. "simu1", "simu2", etc).
*/
credentials("simuN", "simuN") .

/*
Entry point of vl10_agent's program.

An agent program (in the Jason/AgentSpeak language) is mostly composed of a set of plans. A plan has the following structure:

triggering_event : guard_condition <- action ; action ; ... action .

The following plan has the guard condition that the agent knows (or, rather, believes) some credentials. Its triggering event is the addition of !start to the list of goals of the agents (remember that goals start with '!'). Once the event occurs, the plan states that the agent will achieve goal !start if it executes two actions in sequence: setAuthCredentials() and !run.
*/
+!start :
    credentials(Username, Password)
    <-
    /*
    setAuthCredentials is a boilerplate action so that the WoT TD library used by Hypermedea remembers the given credentials for subsequent operations. 
    */
    setAuthCredentials(Username, Password);
    /*
    This pseudo-action generates an event of the form +!run, triggering the plan defined below.
    */
    !run;
  .

+!run :
    /*
    This plan has no guard condition.
    */
    true
    <-
    /*
    readProperty() is one of the WoT operations. For the VL10 workshop, this operation sends a GET request to the simulation server for the "conveyorSpeed" property and maps Val to the server's response payload (a real number). As in Prolog, Val is a variable in Jason because it starts with a capital letter.
    */
    readProperty("conveyorSpeed", Val);
    /*
    .print() is an "internal" action. All agents have some internal actions built in, as opposed to external actions that depend on the environment in which an agent is situated. See here for a list of internal actions:
    
    https://jason.sourceforge.net/api/jason/stdlib/package-summary.html
    */
    .print("Conveyor speed: ", Val);
    /*
    The agent should print "Conveyor speed: 0.0".
    If you have an authentication error, see above (l. 26).
    */
  .

/*
Exercises:

1. Read all properties of the VL10 workshop.

2. A Jason plan can include control statements (if/while/for). Add a while (true) loop to constantly monitor the workshop's properties. Add a pause between each iteration with the .wait() internal action.

3. Use writeProperty() to set conveyor speed to some value >0 and invokeAction() to pick items on the storage rack, repeatedly (at location [0, 0], [0, 1], ... [1, 0], [1, 1], ...). Once no item is in storage, the agent should wait until it is refilled. Examples of how to use WoT operations are provided in the template's README.

Now you've got a first controller agent!
*/

{ include("inc/vl10_skills.asl") }
{ include("inc/common.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
