/* 
ld_spider using the Linked Data artifact to crawl a KG 

@author Olivier Boissier (Mines Saint-Etienne), Victor Charpenay (Mines Saint-Etienne)
*/

/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

+!start :
    true
    <-
    // start crawling
    !crawl ;
    // ensure some KG statements were crawled
    !countRDF ;
  .

+!crawl :
    entryPoint(EntryPoint) // get the base where to consider the index.ttl
    <-
    .print("Crawling starting from ", EntryPoint) ;
    .print("[TODO]") ; 
  .

// plan for counting the number of rdf beliefs
+!countRDF :
    true
    <-
    .count(rdf(_, _, _), Count) ;
    .print("found ", Count, " triples.");
  .

{ include("inc/common.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
