location_conveyor([-0.5,0.5,0.2]). // relative position of conveyor
location_packaging([0.5,0.5,0.2]). // relative position of packaging workshop

has_origin_coordinates(Name,ValueX, ValueY, ValueZ) :-
      thing(Name,Thing)
      & base(Base)
      & builder(Thing, Base, "ontology#hasOriginCoordinates", Temp)
      & builder(Temp, Base, "ontology#coordX",ValueX)
      & builder(Temp, Base, "ontology#coordY",ValueY)
      & builder(Temp, Base, "ontology#coordZ",ValueZ)
  .

// Plan for invoking the action affordance reset
+!reset(Name) :
    thing(Name,Thing)
    <-
    ?reset_action(Thing,ActionName);
    .println("---> ",Thing," invoke operation ",ActionName);
    invokeAction(ActionName,[])[artifact_name(Name)];
    .println("---> ",Thing," operation invoked ",ActionName);
  .

// contingency plan in case the achievement of goal !reset fails
-!reset(Name) :
    thing(Name,Thing)
    <-
    .println("---> ",Thing," has no reset operation");
  .

// Plan for invoking the action affordance release
+!release(Name,At) :
    thing(Name,Thing)
    & release_action(Thing,ActionName)
    <-
    .println("---> ",Thing," invoke operation ",ActionName," at ", At);
    invokeAction(ActionName,[])[artifact_name(Name)];
    .println("---> ",Thing," operation invoked ",ActionName," at ", At);
  .

// Plan for invoking the action affordance grasp
+!grasp(Name,At) :
    thing(Name,Thing)
    & grasp_action(Thing,ActionName)
    <-
    .println("---> ",Thing," invoke operation ",ActionName," at ", At);
    invokeAction(ActionName)[artifact_name(Name)];
  .

// contingency plan in case the achievement of goal !grasp fails
-!grasp(Name,At) :
    thing(Name,Thing)
    <-
    .println("---> Grasp operation failed ");
    .wait(3000);
    !grasp(Name,At);
  .

// Plan for invoking the move affordance grasp
+!move(Name,To) :
    thing(Name,Thing)
    & move_action(Thing,ActionName)
    <-
    .println("---> ",Thing," invoke operation ",ActionName," to ", To);
    invokeAction(ActionName, ["x", "y", "z"], To)[artifact_name(Name)];
  .
