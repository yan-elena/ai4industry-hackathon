/*
Alice is an agent. Its "cognitive" state is composed of
- beliefs (atomic statements, as in Prolog) and
- goals (atomic statements prefixed with '!' or '?').

The following line initializes the agent's state with a belief that gives what credentials it should use to interact with the
simulated manufacturing line.

TODO: replace N with your group number (to obtain e.g. "simu1", "simu2", etc).
*/
credentials("simuN", "simuN") .

/*
Some beliefs may be derived from others, given logical rules expressed in a
Prolog-like syntax.

The rules below are mostly there for convenience, to inspect representations
of JSON objects in the language. It is boilerplate code, you do not need to
look at it in details.
*/
thing(T)
    :-
    json(TD) & .list(TD) &
    .member(kv(id, T), TD) .

hasProperty(T, P)
    :-
    json(TD) & .list(TD) &
    .member(kv(id, T), TD) &
    .member(kv(properties, Ps), TD) &
    .member(kv(P, _), Ps) .

hasForm(T, PAE, F)
    :-
    json(TD) & .list(TD) &
    .member(kv(id, T), TD) &
    (
        .member(kv(properties, PAEs),  TD) |
        .member(kv(actions, PAEs),  TD) |
        .member(kv(events, PAEs),  TD)
    ) &
    .member(kv(PAE, Def), PAEs) &
    .member(kv(forms, Fs), Def) &
    .member(F, Fs) .

hasTargetURI(F, URI) :- .member(kv(href, URI), F) .

/*
Below are Alice's plans. Whenever Alice has a goal, she will execute one of the
plans she knows shall achieve this goal. Plans are the core of the agent's
program, they dictate the overall behavior of the agent.

A plan has the following structure:

triggering_event : guard_condition <- action ; action ; ... action .

- tringgering events are the addition/deletion of beliefs and goals to the
agent's state, e.g. the addition of goal !getTD(<URI of a TD document>);
- the guard condition is a logical formula over beliefs;
- an action is a statement that has side effects in the agent's environment
(here, the environment is the Web).

Given the following plans, Alice can retrieve a TD document, list the
properties it contains, read and write those properties, and invoke actions.
That is, it can do what most WoT consumers should be able to do.
*/
+!getTD(TD)
    <-
    !prepareForm(F) ;
    get(TD, F) ;
    ?thing(T) ;
    .print("Found Thing with URI ", T) .

+!listProperties(T) <- for (hasProperty(T, P)) { .print(P) } .

+!readProperty(T, P) : hasForm(T, P, F) & hasTargetURI(F, URI)
    <-
    !prepareForm(Fp) ;
    get(URI, Fp) ;
    ?(json(Val)[source(URI)]) ;
    .print(P, " = ", Val) .

+!writeProperty(T, P, Val) : hasForm(T, P, F) & hasTargetURI(F, URI)
    <-
    !prepareForm(Fp) ;
    put(URI, [json(Val)], Fp) .

+!invokeAction(T, A, In) : hasForm(T, A, F) & hasTargetURI(F, URI)
    <-
    !prepareForm(Fp) ;
    post(URI, [json(In)], Fp) .

+!prepareForm(F) : credentials(User, Pw)
    <-
    h.basic_auth_credentials(User, Pw, H) ;
    F = [kv("urn:hypermedea:http:authorization", H)] .

/*
Exercises:

1. Edit the plan below to read the TD of the VL10 workshop and print its
properties to the console.

2. Re-write the plan so that Alice sets the conveyor speed of the VL10 workshop
to 0.5 (m/s) and then picks an item at position (0,0).

That will be all for now. More details about the Jason language will be given
in the MAS lecture.
*/
+!start
    <-
    .print("I'm not doing anything. Add some actions to this plan!") .

!start . // entry point of the agent's reasoning cycle

{ include("$jacamoJar/templates/common-cartago.asl") }