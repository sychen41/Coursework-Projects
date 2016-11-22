# Compiler for OOP decaf (Fall 2014)
(Course: CISC672 Compiler Construction )

This is a compiler built for the OOP language decaf. It contains the following conponents:

- Scanner: define and extract lexical units (tokens) by using Regex and Flex.
- Parser: produce a parse tree by using Bison
- Semantic Analyzer: check any violation of semantic rules and output an annotated parse tree
- MIPS assembly code generator: generates code to be executed on the SPIM simulator


-------------------------------------------------------------------------------------------------------------------------
# Gene Expression Inference (Spring 2016)
(Course: CISC889 Advanced Topics In Artificial Intelligence

Project 1
 
- Used depth-first search to randomize a validated configuration for the input amino acid sequence and computed its corresponding energy.
 
- Implemented the Metropolis algorithm to simulate the ensemble of configuration obeying Boltzmann distribution.
 
- Implemented a genetic algorithm with simulated annealing to find the lowest energy configuration.
 
Project 2
 
- Reconstructed gene regulatory network from gene expression data(training data) by implementing Bayesian Network
 
- Implemented the learning algorithm based on Maximum Likelihood by generating conditional probability table (CPT) for each BN.
 
- Made inference about the expression level of a gene given the expression levels of other genes. Achieved prediction accuracy of .75.

-------------------------------------------------------------------------------------------------------------------------
This is a web application done in April 2014 for CISC474 (Advanced Web Tech)

Use PHP and the Slim framework to build out the application. 

The application can do the following:

1. Validate the user login off of the provided database

2. Using the Session (or the built-in cookie from Slim), persist that user login and provide them a way to log out.

3. After a user has logged in, show them a list of all 'Projects' you have.

4. Allow the user to 'review' the project with a number rating and leave a paragraph of feedback.

5. From the list of projects, show the user which ones they have already reviewed and what they said.

6. Show what other users have said and their review. Add an 'average' review to the top of the project.

7. Change password system to encrypt passwords (md5)

8 Show a list (similar to the user list) of all of their documents and allow sorting / paging.

9. Allow the user to click a document to review and edit the document.
Add another panel for administrators to view all documents that need to be 'approved'.

10. Allow administrator to view any document and mark them as approved.

11. Allow user to see documents that have been approved in their list.

-------------------------------------------------------------------------------------------------------------------------
# -CISC853-SNMPv2c-agent
(Course: Computer Network Management (2015S)) Project 1&amp; 2

- Implemented management agents (servers) and clients

- Implemented the ASN.1 data types and use them in the application, according to the SNMP message structure from RFC 1901 and the PDU structure from RFC 3416. 

- Implemented and extended MIB variables,  completed the functionality of UDEL-PING-MIB

