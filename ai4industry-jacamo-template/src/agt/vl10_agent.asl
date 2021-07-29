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
    // To initialize the ThingArtifact in a dryRun mode (requests are printed but not executed)
    // makeArtifact(Name, "org.hypermedea.ThingArtifact", [Thing, false], ArtId);
    // .println("PAY ATTENTION: I am in dryRun=True mode");
    // When no parameter, dryRun is false by default.
    makeArtifact(Name, "org.hypermedea.ThingArtifact", [Thing], ArtId);
    focus(ArtId);
     // set credentials to access the Thing (DX10 workshop of the IT'm factory)
    ?credentials(SimuName,SimuPasswd);
    setAuthCredentials(SimuName, SimuPasswd)[artifact_id(ArtId)] ;

    ?locationOfOutputProduct(Name,COX,COY,COZ);
    !getDescription(Name);
    !testStatus(Name);

    // Not necessary to get all of them regularly. 
     //Choose and comment, otherwise there is a risk of
     //consuming all the computing resources
    !observeStackLightStatus(Name);
    !observeCapacity(Name);  
    !observePositionX(Name); 
    !observePositionZ(Name); 
    !observeClampStatus(Name);
    !observeConveyorSpeed(Name); 
    !conveyItems(Name);
    !testStatus(Name);
  .

+!run(Name) :
    true
    <-
    .wait(100);
    !!run(Name).

// Conveying Items from the storage Rack to the conveyor
// Fake plan. Adapt.
+!conveyItems(Name) :
    thing(Name,Thing)
    <-
     !pickItem(Name,[0,2]);
    .println("is conveying.");
    .wait(1000);
  .


// reactive plan triggered when the provider has sent the product
+done(order)[source(Sender)] :
    true
    <-
    .print("received the acknowledgment from ",Sender);
  .

// TO BE COMPLETED ....

{ include("inc/vl10_skills.asl") }
{ include("inc/owl-signature.asl") }
{ include("inc/common.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
