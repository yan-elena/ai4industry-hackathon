/*
vl10_agent controlling the Storage rack
It acts on a thing described by: https://ci.mines-stetienne.fr/kg/itmfactory/vl10
It has:
- the following action affordances:
-- pressEmergencyStop
-- pickItem
- the following property affordances
-- positionX
-- capacity
-- positionZ
-- conveyorSpeed
-- clampStatus
-- stackLightStatus

@author Olivier Boissier (Mines Saint-Etienne)
*/

/* Initial beliefs and rules */
position(0,0). // X,Z cell in the storageRack

thing(storageRack,Thing) :-
    thing(Thing)
    & platform(Thing)
    & rdf(Thing, "http://www.w3.org/1999/02/22-rdf-syntax-ns#type", "http://www.productontology.org/id/Automated_storage_and_retrieval_system")
    & has_action_affordance(Thing, PressEmergencyStop)
    & stop_in_emergency_action(PressEmergencyStop)
    & has_action_affordance(Thing, PickItem)
    & move_from_to_action(PickItem)
    & has_property_affordance(Thing, PositionX)
    & x_coordinate(PositionX)
    & has_property_affordance(Thing, PositionZ)
    & z_coordinate(PositionZ)
    & has_property_affordance(Thing, Capacity)
    & maximum_count(Capacity)
    & has_property_affordance(Thing, ConveyorSpeed)
    & conveyor_speed(ConveyorSpeed)
    & has_property_affordance(Thing,ClampStatus)
    & boolean_schema(ClampStatus)
    & name(ClampStatus,"clampStatus")
    & has_property_affordance(Thing,StackLightStatus)
    & name(StackLightStatus,"stackLightStatus")
  .

/* Initial goals */

/* Plans */

+!start :
    name(Name) <-
    .println("Belief base is under initialization");
    !!run(Name);
  .

+!run(Name) : thing(Name,Thing) <-
    .print("Found suitable storage rack: ", Thing) ;
     // set credentials to access the Thing (DX10 workshop of the IT'm factory)

    ?locationOfOutputProduct(Name,COX,COY,COZ);
    !getDescription(Name);
    !testStatus(Name);

    !observeStackLightStatus(Name);

    ?conveyorSpeed(Name,IS);
    if (IS == 0) {
      !changeConveyorSpeed(Name,IS+0.5);
    }
    !conveyItems(Name);
  .

+!run(Name) :
    true
    <-
    .wait(100);
    !!run(Name).

// Fake plan. Adapt.
+!conveyItems(Name) :
    thing(Name,Thing)
    & position(X,Z)
    & X < 5
    & Z < 5
    <-
    .println("is conveying.");

    !pickItem(Name, [X,Z]);

    !update_position(X, Z);
    ?position(X1, Z1);
    .print("--> Updates position: ", X1, Z1);

    .wait(100);
    !!run(Name)
  .


+!update_position(X, Z) : X<4
  <- -+position(X+1, Z).

+!update_position(X, Z) : X==4
  <- -+position(0, Z + 1).

+!update_position(X, Z) : true
  <- .print("Finish").

// TO BE COMPLETED ....

+done(order)[source(Sender)] :
    true
    <-
    .print("received the acknowledgment from ",Sender);
  .

// Handling emergency cases
// reinitialize the conveyor speed to the initial value when light is green
// press emergency stop when light is red
// both plans supersede the corresponding plans provided in the included file
+propertyValue("stackLightStatus", "green")[artifact_name(_,Name)] :
    thing(Name,Thing)
    & initialSpeed(S)
    <-
    .println("********** stackLightStatus is now green. Reinitialization of the speed.");
    !changeConveyorSpeed(Name,S);
  .

+propertyValue("stackLightStatus", "red")[artifact_name(_,Name)] :
    thing(Name,Thing)
    <-
    .println("********** stackLightStatus is now red. Pressing emergency stop.");
    !pressEmergencyStop(Name);
  .

{ include("inc/vl10_skills.asl") }
{ include("inc/owl-signature.asl") }
{ include("inc/common.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
