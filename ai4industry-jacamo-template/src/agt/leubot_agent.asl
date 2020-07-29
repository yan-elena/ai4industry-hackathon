/* Initial beliefs and rules */

nb(0).  // number of iterations

// Selection by reasoning of the Thing for leubot1
thing(leubot1,Thing) :-
    thing(Thing)
    & rdf(Thing, "http://www.w3.org/1999/02/22-rdf-syntax-ns#type", "https://ci.mines-stetienne.fr/kg/ontology#PhantomX_3D")
    & rdf(Thing,"http://purl.org/dc/terms/title","leubot1-3d")
  .

// Selection by reasoning of the Thing for leubot2
thing(leubot2,Thing) :-
      thing(Thing)
      & rdf(Thing, "http://www.w3.org/1999/02/22-rdf-syntax-ns#type", "https://ci.mines-stetienne.fr/kg/ontology#PhantomX_3D")
      & rdf(Thing,"http://purl.org/dc/terms/title","leubot2-3d")
    .

location_conveyor([-0.5,0.5,0.2]). // relative position of conveyor
location_packaging([0.5,0.5,0.2]). // relative position of packaging workshop

/* Initial goals */

/* Plans */

+!start :
    name(Name)
    <-
    .print("Belief base is under initialization");
    !!run(Name);
  .

+!run(Name) :
    thing(Name, Thing)
    & api_key(Token)
    <-
    .print("Found suitable RobotArm : ", Thing) ;
    // To also execute the requests, remove the second init parameter (dryRun flag).
    // When dryRun is set to true, the requests are printed (but not executed).
    //makeArtifact(Name, "tools.ThingArtifact", [Thing, false], ArtId);
    //.println("PAY ATTENTION: I am in dryRun=True mode");
    makeArtifact(Name, "tools.ThingArtifact", [Thing, false], ArtId);
    focus(ArtId);

    ?has_origin_coordinates(Name,CX,CY,CZ);
    .println(Thing, " has origin coordinates ",CX," ",CY," ",CZ);

    !getDescription(Name);

    // Set API key is a call of the operation setAPIKey on the ThingArtifact
    setAPIKey(Token)[artifact_name(Name)];

    // goal of potting Items using the thing
    !potItems(Name);
  .

+!run(Name) :
    true
    <-
    .wait(100);
    !!run(Name);
  .

// Plans for achieving the goal potItems; Notice that it will be called 3 times
+!potItems(Name) :
    nb(X)
    & X<3
    & location_conveyor(Lc)
    & location_packaging(Lp)
    <-
    !carry(Name,Lc,Lp);
    -+nb(X+1);
    !!potItems(Name);
  .

+!potItems(Name) : true
  <-
  .wait(2000);
  !reset(Name);
.

// Plan for carrying a pot from one place to another one.
+!carry(Name,From,To) :
    true
    <-
    !move(Name,From);
    .wait(1000);
    !grasp(Name,From);
    .wait(1000);
    !move(Name,To);
    .wait(1000);
    !release(Name,To);
  .

{ include("inc/robot_arm_skills.asl") }
{ include("inc/owl-signature.asl") }
{ include("inc/common.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
