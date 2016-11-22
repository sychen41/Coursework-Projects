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
# Web App in PHP (Spring 2014)
(Course: CISC474 Advanced Web Tech)

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
# SNMPv2c Agent (Spring 2015)
(Course: CISC853 Computer Network Management)

- Implemented management agents (servers) and clients

- Implemented the ASN.1 data types and use them in the application, according to the SNMP message structure from RFC 1901 and the PDU structure from RFC 3416. 

- Implemented and extended MIB variables,  completed the functionality of UDEL-PING-MIB

-------------------------------------------------------------------------------------------------------------------------
# CISC-681-Decision-Tree-Construction-and-Prediction (Spring 2016)
(Course: CISC681 Artificial intelligence)

we build the decision tree using the most informative attribute

(the one that has the most information gain) in the start. We do this process recursively at each

level in the tree with respect to the number of attributes and their instances. To do this, we need

some relative parts to complete the calculations. We need to know the number of the attributes,

of the classes, of the instances … etc. Also, all these relative parts are needed to start building the

tree. To make building the tree easy to understand, we divided the entire work to small pieces so

every one can trace a specific work.

In more details, here what we did in term of the code structure of the decision tree. There

will be a function to:

 Load the instances in a required format

 Identify the attributes, attributes name and their instances

 Identify the values of each instance

 Calculate the Entropy of each attributes, after specifying the target attribute.

 Calculate the information gain

 Identify the portion of each value in each attribute

 Deal with discretization

 Calculate the accuracy

 Calculate the recall

 Build the decision tree

 Generate a tgf file (see more details later in this document)

-------------------------------------------------------------------------------------------------------------------------
# -CISC-374-Phaser-and-HTML5
(Course: Game Development(2014F)) This is for html5+phaser study purpose 
https://www.eecis.udel.edu/~pollock/374s15/syllabus
