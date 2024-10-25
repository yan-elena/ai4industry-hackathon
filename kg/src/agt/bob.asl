/*
All rules below are again for convenience, to translate RDF statements into
shorter beliefs.

It is common to translate RDFS classes to unary predicates (such as 'thing') 
and RDFS properties to binary predicates (such as 'hasPropertyAffordance'). By
doing so, we may introduce name conflicts though. For instance,
- https://www.w3.org/2019/wot/td#Thing and
- http://www.w3.org/2002/07/owl#Thing
are quite different from each other. The latter is more general than the former.
That is why everything is a URI, in RDF.
*/
credentials("simu2", "simu2").
type(Individual, Class)
    :-
    rdf(
        Individual,
        "http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
        Class
    ) .

system(Individual) :- type(Individual, "http://www.w3.org/ns/ssn/System") .
thing(Individual) :- type(Individual, "https://www.w3.org/2019/wot/td#Thing") .

automated_storage_and_retrieval_system(Individual)
    :-
    type(
        Individual,
        "http://www.productontology.org/id/Automated_storage_and_retrieval_system"
    ) .

type(Individual, automated_storage_and_retrieval_system)
    :-
    automated_storage_and_retrieval_system(Individual) .

conveyorSpeed(Individual)
    :-
    type(
        Individual,
        "https://ci.mines-stetienne.fr/kg/ontology#ConveyorSpeed"
    ) .

type(Individual, conveyorSpeed) :- conveyorSpeed(Individual) .

moveFromToAction(Individual)
    :-
    type(
        Individual,
        "https://ci.mines-stetienne.fr/kg/ontology#MoveFromToAction"
    ) .

type(Individual, moveFromToAction) :- moveFromToAction(Individual) .

hasSubSystem(Individual1, Individual2)
    :-
    rdf(Individual1, "http://www.w3.org/ns/ssn/hasSubSystem", Individual2) .

hasPropertyAffordance(Individual1, Individual2)
    :-
    rdf(
        Individual1,
        "https://www.w3.org/2019/wot/td#hasPropertyAffordance",
        Individual2
    ) .

hasActionAffordance(Individual1, Individual2)
    :-
    rdf(
        Individual1,
        "https://www.w3.org/2019/wot/td#hasActionAffordance",
        Individual2
    ) .

name(Individual1, Individual2)
    :-
    rdf(Individual1, "https://www.w3.org/2019/wot/td#name", Individual2) .
    
hasForm(Individual1, Individual2)
    :-
    rdf(Individual1, "https://www.w3.org/2019/wot/td#hasForm", Individual2) .

hasTarget(Individual1, Individual2)
    :-
    rdf(
        Individual1,
        "https://www.w3.org/2019/wot/hypermedia#hasTarget",
        Individual2
    ) .

/*
The agent crawls (a subset of) the Web by dereferencing the given URI and
by following only certain links. Here, it only follows links between systems (as Web resources) and their subsystems. In other words, it is only interested in resources likely to contain a description of the manufacturing line.

The other plans of Bob are similar to Alice's: they handle reading and writing
properties, and invoking actions. There is a significant difference between
the two, though: Bob does not consider the actual names of Things or
property/action affordances. Instead, it only considers classes, so as to 
behave identically if two Things have the same interface.
*/
+!crawl(URI)
    <-
    get(URI) ;
    +crawled(URI) ;
    for (system(S) & hasSubSystem(S, SS)) {
        h.target(SS, TargetURI) ;
        if (not crawled(TargetURI) & not .intend(crawl(TargetURI))) {
            !crawl(TargetURI)
        }
    } .

-!crawl(URI)
    <-
    .print("Couldn't crawl ", URI, ". Giving up.") ;
    +crawled(URI) .

+!listThings <- .print("Things:") ; for (thing(T)) { .print("* ", T) } .

+!listPropertyAffordances(TType)
    <-
    .print("Property affordances:") ; 
    for (type(T, TType) & hasPropertyAffordance(T, Af) & name(Af, P)) {
        .print("* ", P)
    } .

+!readProperty(TType, PType)
    : type(T, TType)
    & hasPropertyAffordance(T, Af)
    & type(Af, PType)
    & name(Af, P)
    & hasForm(Af, F)
    & hasTarget(F, URI)
    <-
    !prepareForm(Fp) ;
    get(URI, Fp) ;
    ?(json(Val)[source(URI)]) ;
    .print(P, " = ", Val) .

+!writeProperty(TType, PType, Val)
    : type(T, TType)
    & hasPropertyAffordance(T, Af)
    & type(Af, PType)
    & hasForm(Af, F)
    & hasTarget(F, URI)
    <-
    !prepareForm(Fp) ;
    put(URI, [json(Val)], Fp) .

+!invokeAction(TType, AType, In)
    : type(T, TType)
    & hasActionAffordance(T, Af)
    & type(Af, AType)
    & hasForm(Af, F)
    & hasTarget(F, URI)
    <-
    !prepareForm(Fp) ;
    post(URI, [json(In)], Fp) .

+!prepareForm(F) : credentials(User, Pw)
    <-
    h.basic_auth_credentials(User, Pw, H) ;
    F = [kv("urn:hypermedea:http:authorization", H)] .

/*
Exercises:

1. Add instructions to the plan below to crawl the IT'm Factory KG, starting
from its entry point. Then, while the program is running, open the Jason server
at http://127.0.1.1:3272/ and select bob. What do you see? How are RDF triples
represented in Jason? Read the documentation of Hypermedea to fully understand 
the mapping between RDF triples and Jason logical formulas:
https://hypermedea.github.io/javadoc/latest/org/hypermedea/ct/rdf/package-summary.html

2. The plan for crawling resources (starting with +!crawl(URI) <- ...) calls an
operation provided by Hypermedea: h.target. On the Semantic Web, it is
important to distinguish between information resources (an HTML page, a Turtle
document, an image, etc.) and non-information or "semantic" resources (a 
person, an event, a factory workshop, etc.). It is common to identify semantic 
URIs with hash URIs, i.e. URIs with a fragment. However, HTTP requests must 
always target URIs without fragments. In which case is it useful to know the 
target URI of a request when crawling resources? Find an example in the IT'm 
Factory KG.

3. Reproduce the behavior of Alice (get the TD of the VL10 workshop, set its
conveyor speed to 0.5 m/s and pick an item) with Bob's plans. Remember to use
classes instead of actual names to identify Things and affordances.

Now that your agent has dynamically discovered WoT affordances, it can select the ones relevant to reach its goals and act on the factory workshops in an adaptive fashion. It is the purpose of autonomous agents in a multi-agent
system, the next part of the summer school.
*/
+!start
    <-
    //STEP1
    !crawl("https://ci.mines-stetienne.fr/kg/itmfactory/");

    //STEP2
    !crawl("https://ai5.academy.metaphacts.cloud/resource/?uri=https%3A%2F%2Fci.mines-stetienne.fr%2Fsimu%2FpackagingWorkshop%2Fproperties%2FconveyorSpeed");

    //STEP3
    !crawl("https://ci.mines-stetienne.fr/kg/itmfactory/vl10#this");
    !listThings;

    !listPropertyAffordances(TType);

    .print("Read conveyor speed");
    !readProperty(TType, conveyorSpeed);

    .print("Set the conveyor speed to 0.5...");
    !writeProperty(TType, conveyorSpeed, 0.5);

    .print("Invoke action...");
    !invokeAction(TType, moveFromToAction, [0,0]);
    .

!start . // entry point of the agent's reasoning cycle

{ include("$jacamoJar/templates/common-cartago.asl") }