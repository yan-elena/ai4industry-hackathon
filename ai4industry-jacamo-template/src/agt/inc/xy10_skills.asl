
+?opticalSensorPackage(Name,Value) :
    thing(Name,Thing)
    & optical_sensor_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current optical sensor status ",Value," for ",PName);
.

+?stackLightStatus(Name,Value) :
    thing(Name,Thing)
    & stack_light_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current stack light status ",Value," for ",PName);
.

+?conveyorSpeed(Name,Value) :
    thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current conveyor speed ",Value," for ",PName);
.


+?conveyorHeadStatus(Name,Value) :
    thing(Name,Thing)
    & conveyor_head_status_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current conveyor head status ",Value," for ",PName);
.


+?opticalSensorContainer1(Name,Value): thing(Name,Thing) &
    optical_sensor_container_1(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current optical sensor container 1 ",Value," for ",PName);
.


+?packageBuffer(Name,Value) :
    thing(Name,Thing)
    & package_buffer_property(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current package buffer ",Value," for ",PName);
.

+?opticalSensorContainer2(Name,Value):
    thing(Name,Thing)
    & optical_sensor_container_2(Thing,PName)
    <-
    readProperty(PName,Value)[artifact_name(Name)];
    .println(Name,"---> ",Thing," current optical sensor container 2 ",Value," for ",PName);
  .

/***************/

+!observeOpticalSensorPackage(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & optical_sensor_status_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing optical sensor package for ",PName);
  .

+!observeStackLightStatus(Name):
    timer(Timer)
    & thing(Name,Thing)
    & stack_light_status_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing stack light status for ",PName);
  .

+!observeConveyorHeadStatus(Name):
    timer(Timer)
    & thing(Name,Thing)
    & conveyor_head_status_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing conveyor head status for ",PName);
.

+!observeConveyorSpeed(Name):
    timer(Timer)
    & thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing conveyor speed for ",PName);
.

+!observePackageBuffer(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & package_buffer_property(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing package buffer for ",PName);
.

+!observeOpticalSensorContainer2(Name) :
    timer(Timer)
    & thing(Name,Thing)
    & optical_sensor_container_2(Thing,PName)
    <-
    observeProperty(PName,PName,Timer)[artifact_name(Name)];
    .println(Name,"---> ",Thing," observing optical sensor container 2 for ",PName);
  .

  +!observeOpticalSensorContainer1(Name) :
      timer(Timer)
      & thing(Name,Thing)
      & optical_sensor_container_1(Thing,PName)
      <-
      observeProperty(PName,PName,Timer)[artifact_name(Name)];
      .println(Name,"---> ",Thing," observing optical sensor container 1 for ",PName);
    .

/*******************/

+!pressEmergencyStop(Name) :
    thing(Name,Thing)
    & stop_in_emergency_action(Thing,ActionName)
    <-
    invokeAction(ActionName)[artifact_name(Name)];
  .

+!changeConveyorSpeed(Name,Value) :
    thing(Name,Thing)
    & conveyor_speed_property(Thing,PName)
    <-
    writeProperty(PName,[Value])[artifact_name(Name)];
    .println(Name,"---> ",Thing," change conveyor speed to ",Value," for ",PName);
.


/*******************/

+opticalSensorContainer2(X) :
    true
    <-
    .println(" optical sensor container2 is now ", X);
  .

+stackLightStatus(X) :
    true
    <-
    .println("stack light status is now ", X);
  .

+packageBuffer(X) :
    true
    <-
    .println("package buffer is now ", X);
  .

+conveyorHeadStatus(X) :
    true
    <-
    .println(" conveyor head status is now ", X);
  .

+conveyorSpeed(X) :
    true
    <-
    .println("conveyor speed is now ", X);
  .

+opticalSensorContainer1(X) :
    true
    <-
    .println("optical sensor container1 is now ", X);
  .

+opticalSensorPackage(X) :
    true
    <-
    .println("optical sensor package is now ", X);
  .
