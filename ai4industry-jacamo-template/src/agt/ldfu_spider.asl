/* 
ldfu_spider using the ldfu artifact to crawl a KG 

@author Olivier Boissier (Mines Saint-Etienne), Victor Charpenay (Mines Saint-Etienne)
*/

/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

+!start :
    entryPoint(EntryPoint) // get the base where to consider the index.ttl
    <-
    // starts crawling
    crawl(EntryPoint) ;
    .print("...... Finished crawling");
    // executes tests
    !countRDF ;
  .

// plan for counting the number of rdf beliefs
+!countRDF :
    true
    <-
    .count(rdf(_, _, _), Count) ;
    .print("found ", Count, " triples.");
  .

{ include("inc/owl-signature.asl") }
{ include("inc/common.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
