// Code for the Dairy Product Provider
// It has the following action affordances:
// - order
// has no property affordances
// has the following event affordances:
// - delivered

/* Initial beliefs and rules */

thing(dairyProductProvider,Thing) :-
    thing(Thing)
    // TODO include signature from the Product Ontology
    & rdf(Thing,"http://purl.org/dc/terms/title","dairy-product-provider")
    & has_action_affordance(Thing, OrderDairy)
    & name(OrderDairy,"order")
    & has_event_affordance(Thing,Delivered)
    & name(Delivered,"delivered")
  .

/* Initial goals */

/* Plans */

+!start :
    name(Name)
    <-
    .println("Belief base is under initialization");
    !!run(Name);
  .

+!run(Name) : thing(Name,Thing) <-
    .print("Found suitable dairy product provider: ", Thing) ;
    // To also execute the requests, remove the second init parameter (dryRun flag).
    // When dryRun is set to true, the requests are printed (but not executed).
    makeArtifact(Name, "org.hypermedea.ThingArtifact", [Thing], ArtId);
    focus(ArtId);

    !getDescription(Name);
.

+!run(Name) :
    true
    <-
    .wait(100);
    !!run(Name);
  .

+!order(Value)[source(Sender)] :
    true
    <-
    !order(dairyProductProvider,Value);
    .println("order has been processed, sending message to ",Sender);
    .send(Sender,tell,done(order));
  .

+!order(Name,Value) :
    thing(Name,Thing)
    & order_action(Thing,ActionName)
    <-
    .println("---> ",Thing," invoke operation ",ActionName," for ",Value);
    invokeAction(ActionName,[Value])[artifact_name(Name)];
  .

{ include("inc/owl-signature.asl") }
{ include("inc/common.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
