# AI4Industry JaCaMo template

This project is a template to start your own multi-agent system for the ai4industry hackathon.

## Getting started

Clone the project and follow [the configuration steps](https://gitlab.emse.fr/ai4industry/hackathon/-/wikis/hackathon-configuration#user-content-autonomous-agents) given in the wiki page "Hackathon configuration". Configuration includes downloading [Hypermedea](https://github.com/Hypermedea/hypermedea).

## The Hypermedea Framework

Hypermedea is an extension of JaCaMo that includes three types of artifacts:

1. A `LinkedDataFuSpider` artifact, offering the possibility to agents to `crawl` the Knowledge Graph from a starting point. Any agent focusing on this artifact will get the result of the crawl as beliefs.
In the template project, this artifact is only used by the agent `ldfu_spider.asl` in `src/agt` and observed by all agents.

2. A `ThingArtifact`, kind of Thing Description browser artifact offering the possibility to agents to invoke a Thing's actions (`invokeAction`) and read/write its properties (`readProperty`/`writeProperty`). One more operation `observeProperty` makes possible for an agent to regularly update beliefs corresponding to readable property affordances.

3. A `PlannerArtifact`, that can be used for planning with affordances offered by a (collection of) Thing(s). The artifact is a wrapper for a [PDDL planner](https://planning.wiki/).

## Content and structure of the project folder

The project folder contains:

3.The agent `ldfu_spider` that crawls the knowledge graph using an instance of `LinkedDataFuSpider` artifact. A `template_agent` is also provided as a starting point for writing your code.

4. The agent `leubot_agent.asl` (in `src/agt`) to be used to control the robot arm. The agents `cup_provider.asl` and `dairy_product_provider.asl` that are the basis for the control of the cup/packages and dairy product providers.

5. A set of predefined Jason plans (in `src/agt/inc`) that can be included in the agents.

6. The `ai4industry_jacamo.jcm` which is the file to be used and configured to launch the multi-agent system (It is used by gradle for the execution). Each time you create a new agent, you need to add it in this file as well as definition of initial beliefs.

7. A simple script `reset-simu` to reset the different simulated workshops (the argument of this script is the number of your group)

8. The linked-data program `get.n3` that crawl the knowledge graph

## Using ThingArtifacts

You are provided with an implementation of a CArtAgO artifact that can retrieve, interpret, and use a W3C WoT TD to interact with the described Thing. A Jason agent can create a `ThingArtifact` as follows:

```
makeArtifact("forkliftRobot", "org.hypermedea.ThingArtifact", [Url, true], ArtId);
```

The `ThingArtifact` takes two initialization parameters:
- a URL that dereferences to a W3C WoT TD
- an optional `dryRun` flag: when set to `true`, all HTTP requests composed by the artifact are printed to the JaCaMo console (default value is `false`).

The `ThingArtifact` can use an [APIKeySecurityScheme](https://www.w3.org/TR/wot-thing-description/#apikeysecurityscheme) for authenticating HTTP requests. The API token can be set via the `setAPIKey` operation:

```
setAPIKey(Token)[artifact_name("forkliftRobot")];
```

The `ThingArtifact` provides agents with 3 additional CArtAgO operations: `readProperty`, `writeProperty`, and `invokeAction`, which correspond to operation types defined by the W3C WoT TD recommendation.

The general invocation style of `writeProperty` and `invokeAction` is as follows (see also the Javadoc comments):

```
writeProperty|invokeAction ( <semantic type of affordance>, [ <optional: list of semantic types for object properties> ], [ <list of Jason terms, can be arbitrarily nested> ] )
```

Example for writing a TD property of a `BooleanSchema` type:

```
writeProperty("http://example.org/Status", [true])[artifact_name("forkliftRobot")];
```

Example for invoking a TD action with an `ArraySchema` payload:

```
invokeAction("http://example.org/MoveTo", [30, 60, 70])[artifact_name("forkliftRobot")];
```

Example for invoking a TD action with an `ObjectSchema` payload:

```
invokeAction("http://example.org/CarryFromTo",
    ["http://example.org/SourcePosition", "http://example.org/TargetPosition"],
    [[30, 50, 70], [30, 60, 70]]
  )[artifact_name("forkliftRobot")];
```

A TD property can be read in a similar manner, where `PositionValue` is a CArtAgO operation feedback parameter:

```
readProperty("http://example.org/Position", PositionValue)[artifact_name("forkliftRobot")];
```

You can find more details about CArtAgO and the Jason to/from CArtAgO data binding [here](http://cartago.sourceforge.net/?page_id=47). You can find additional examples for using the `ThingArtifact` in a Jason program in `src/agt/wot_agent.asl`.

