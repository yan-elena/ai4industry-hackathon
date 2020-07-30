// plan for testing the status of the Thing by accessing the property affordances
+!testStatus(Name) :
    true
    <-
    ?conveyorSpeed(Name,Speed);
    .print("TEST Current conveyor speed: ", Speed) ;
    ?stackLightStatus(Name,Light);
    .print("TEST Current light: ", Light);
    ?positionX(Name,PX);
    .print("TEST Current position X: ", PX);
    ?tankLevel(Name,Tank);
    .print("TEST Current tank level: ", Tank);
    ?opticalSensorStatus(Name,OSS);
    .print("TEST Current optical sensor status: ", OSS);
    ?conveyorHeadStatus(Name,CHS);
    .print("TEST Current conveyor head status: ", CHS);
    ?magneticValveStatus(Name,MVS);
    .print("TEST Current magnetic valve status: ", MVS);
.

// Plan for calling the emergency stop action affordance
+!pressEmergencyStop(Name) :
    thing(Name,Thing)
    & stop_in_emergency_action(Thing,ActionName)
    <-
    .println("---> ",Thing," invoke operation ",ActionName);
    invokeAction(ActionName)[artifact_name(Name)];
  .

// Plan for requesting the value of the stackLightStatus property affordance
+?stackLightStatus(Name,Value) :
    thing(Name,Thing)
    & stack_light_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current stack light status ",Value," for ",PName);
  .

// Plan for requesting the value of the positionX property affordance
+?positionX(Name,Value) :
    thing(Name,Thing)
    & position_x_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current positionX ",Value," for ",PName);
.

// Plan for requesting the value of the tankLevel property affordance
+?tankLevel(Name,Value) :
    thing(Name,Thing)
    & tank_level_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current tank level ",Value," for ",PName);
  .

// Plan for requesting the value of the conveyorSpeed property affordance
+?conveyorSpeed(Name,Value) :
    thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current conveyor speed ",Value," for ",PName);
  .

// Plan for requesting the value of the opticalSensorStatus property affordance
+?opticalSensorStatus(Name,Value) :
    thing(Name,Thing)
    & optical_sensor_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current optical sensor status ",Value," for ",PName);
  .

// Plan for requesting the value of the conveyorHeadStatus property affordance
+?conveyorHeadStatus(Name,Value) :
    thing(Name,Thing)
    & conveyor_head_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current conveyor head status ",Value," for ",PName);
  .

// Plan for requesting the value of the magneticValveStatus property affordance
+?magneticValveStatus(Name,Value) :
    thing(Name,Thing)
    & magnetic_valve_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current magnetic valve status ",Value," for ",PName);
  .

/********************************/

// Plan for observing (pulling) the value of the tankLevel property affordance
+!observeTankLevel(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & tank_level_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing tank level for ",PName);
  .

// Plan for observing (pulling) the value of the positionX property affordance
+!observePositionX(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & position_x_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing position X for ",PName);
  .

// Plan for observing (pulling) the value of the conveyorSpeed property affordance
+!observeConveyorSpeed(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing conveyor speed for ",PName);
  .

// Plan for observing (pulling) the value of the conveyorHeadStatus property affordance
+!observeConveyorHeadStatus(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & conveyor_head_status_property(Thing,PName)
    <-
    //?property_full_name(Thing,PName,FullName);
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing conveyor head status for ",PName);
  .

// Plan for observing (pulling) the value of the opticalSensorStatus property affordance
+!observeOpticalSensorStatus(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & optical_sensor_status_property(Thing,PName)
    <-
    //?property_full_name(Thing,PName,FullName);
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing optical sensor status for ",PName);
  .

// Plan for observing (pulling) the value of the MagneticValveStatus property affordance
+!observeMagneticValveStatus(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & magnetic_valve_status_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing magnetic valve status for ",PName);
  .

/***************************************/

// Plan for writing a new value in the conveyorSpeed property
+!changeConveyorSpeed(Name,Value) :
    thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    writeProperty(PName,[Value])[artifact_name(Name)];
    .println(Name,"---> ",Thing," change conveyor speed to ",Value," for ",PName);
  .
