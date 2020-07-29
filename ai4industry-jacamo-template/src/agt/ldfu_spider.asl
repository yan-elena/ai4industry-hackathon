/* Initial beliefs and rules */

// reasoning rule to get the name of a moveFromToAction
move_action(ActionName) :-
    thing(Thing)
    & has_action_affordance(Thing, MoveAction)
    & move_from_to_action(MoveAction)
    & name(MoveAction, ActionName)
  .

/* Initial goals */

/* Plans */

+!start :
    base(Base) // get the base where to consider the index.ttl
    <-
    // starts crawling
    .concat(Base,"index.ttl",EntryPoint);
    crawl(EntryPoint) ;
    // executes tests
    !count ;
    !query;
  .

// plan for counting the number of rdf beliefs
+!count :
    true
    <-
    .count(rdf(_, _, _), Count) ;
    .print("found ", Count, " triples.");
  .

+!query :
    move_action(Name)
    <-
    .print("found move action: ", Name);
 .

{ include("inc/owl-signature.asl") }
{ include("inc/common.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
