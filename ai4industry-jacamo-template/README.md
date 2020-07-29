# AI4Industry: JaCaMo starter project

This project is a template to start your own [JaCaMo](https://github.com/jacamo-lang/jacamo) project using Gradle.

## Prerequisites

- JDK 8+

## Getting started

Clone your project

## Start to hack

1. Create one or several branches for your group
2. Push and track your branches
3. In the project repository, run `./gradlew`

## Mocking your HTTP requests

When developing your application, it might be useful to mock your HTTP requests. One simple solution is to use [MockServer](https://www.mock-server.com/):

1. Add your expected HTTP responses in `mockserver/mockserver.json`. You can find the format of an expectation in the [MockServer OpenAPI specification](https://app.swaggerhub.com/apis/jamesdbloom/mock-server-openapi/5.10.x#/Expectation).

2. Run MockServer with [Docker](https://www.docker.com/). To use the expectation initialization file created in the previous step, you will have to use a bind mount and to set an environment variable like so:

```
docker run -v "$(pwd)"/mockserver/mockserver.json:/tmp/mockserver/mockserver.json \
-e MOCKSERVER_INITIALIZATION_JSON_PATH=/tmp/mockserver/mockserver.json \
-d --rm --name mockserver -p 1080:1080 mockserver/mockserver
```

The above command will run the Docker container in the background and will print the container ID. To stop the container: `docker stop CONTAINER_ID`

## Content and structure of the project folder

The project folder contains:

1. A `LinkedDataFuSpider` artifact in `src/env`, artifact offering the possibility to agents to `crawl` the Knowledge Graph from a starting point. Any agent focusing on this artifact will get the result of the crawl as beliefs.
In the template project this artifact is only used by the agent `ldfu_spider.asl` in `src/agt` and observed by all agents.

2. A `ThingArtifact` artifact in `src/env`, kind-of Thing Description browser artifact offering the possibility to agents to invoke thing action affordance (`invokeAction`), thing read/write property affordances (`readProperty`/`writeProperty`) on the thing for which an instance of this artifact is created. One more operation `observeProperty` makes possible for an agent to regularly update beliefs corresponding to readable property affordances.

3.The agent `ldfu_spider` that crawls the knowledge graph using an instance of `LinkedDataFuSpider` artifact. A `template_agent` is also provided as a starting point for writing your code.

4. The agent `leubot_agent.asl` (in `src/agt`) to be used to control the robot arm. The agents `cup_provider.asl` and `dairy_product_provider.asl` that are the basis for the control of the cup/packages and dairy product providers.

5. A set of predefined Jason plans (in `src/agt/inc`) that can be included in the agents.

6. The `ai4industry_jacamo.jcm` which is the file to be used and configured to launch the multi-agent system (It is used by gradle for the execution). Each time you create a new agent, you need to add it in this file as well as definition of initial beliefs.

7. A simple script `init-simu` to reset the different simulated workshops (the argument of this script is the number of your group)

8. The linked-data program `get.n3` that crawl the knowledge graph

## Using ThingArtifacts

You are provided with an implementation of a CArtAgO artifact that can retrieve, interpret, and use a W3C WoT TD to interact with the described Thing. A Jason agent can create a `ThingArtifact` as follows:

```
makeArtifact("forkliftRobot", "tools.ThingArtifact", [Url, true], ArtId);
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

