
+!changeConveyorSpeed(Name,Speed) :
    thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    writeProperty(PName,[Speed])[artifact_name(Name)];
  .

+!pressEmergencyStop(Name) :
    thing(Name,Thing)
    & stop_in_emergency_action(Thing,ActionName)
    <-
    .println("---> ",Thing," invoke operation ",ActionName);
    invokeAction(ActionName)[artifact_name(Name)];
.

+!pickItem(Name,To) :
    thing(Name,Thing)
    & move_from_to_action(Thing,ActionName)
    <-
    .println("---> ",Thing," invoke operation ",ActionName," to ", To);
    invokeAction(ActionName,To)[artifact_name(Name)];
    .println("---> ",Thing," operation ",ActionName," to ", To, " finished ");
  .

-!pickItem(Name,To) :
    thing(Name,Thing)
    & move_from_to_action(Thing,MActionName)
    & provider(Provider)
    <-
    ?clampStatus(Name,Value);
    .println("Error in picking Item at ",To, " clamp status is ",Value);
    if (Value) {
      .println("A cup is on the cup provider and I am waiting !!!!!!!!!!");
    }
    else {
      .send(Provider,achieve,order(25));
      .println("I have sent an order to the cup provider and I am waiting !!!!!!!!!!");
      }
    .wait(4000);
  .

/************************/

+?positionX(Name, Value) :
    thing(Name,Thing)
    & position_x_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current positionX ",Value," for ",PName);
  .

+?positionZ(Name, Value) :
    thing(Name,Thing)
    & position_z_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current positionZ ",Value, " for ", PName);
  .

+?capacity(Name,Value) :
    thing(Name,Thing)
    & capacity_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current capacity ",Value, " for ",PName);
  .

+?conveyorSpeed(Name,Value) :
    thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current speed ",Value," for ",PName);
  .

+?stackLightStatus(Name,Value) :
    thing(Name,Thing)
    & stack_light_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current stacklight status ",Value," for ",PName);
  .

+?clampStatus(Name,Value) :
    thing(Name,Thing)
    & clamp_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current clamp status ",Value," for ",PName);
.

/***************/

+!observeCapacity(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & capacity_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing capacity for ", PName);
  .

+!observeConveyorSpeed(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing conveyor speed for ",PName);
  .

+!observeStackLightStatus(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & stack_light_status_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing stack light status for ",PName);
  .

+!observeClampStatus(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & clamp_status_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing clamp status for ",PName);
  .

+!observePositionX(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & position_x_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing position x for ",PName);
.
+!observePositionZ(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & position_z_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing position z for ",PName);
  .

/**********************/

+conveyorSpeed(X) :
    true
    <-
    .println("conveyorSpeed is now ",X);
  .

+stackLightStatus(X)[artifact_name(_,Name)] :
    X == "green"
    & initialSpeed(S)
    <-
    .println("stackLightStatus is now ",X);
    !changeConveyorSpeed(Name,S);
  .

+stackLightStatus(X)[artifact_name(_,Name)] :
    X == "red"
    <-
    .println("stackLightStatus is now ",X);
    !pressEmergencyStop(Name);
  .

+clampStatus(X) :
    true
    <-
    .println("clampStatus is now ",X);
  .

+positionX(X) :
    true
    <-
    .println("positionX is now ",X);
  .

+positionZ(X) :
    true
    <-
    .println("positionZ is now ",X);
  .

+capacity(X) :
    true
    <-
    .println("capacity is now ",X);
  .
