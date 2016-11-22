# -CISC-681-Decision-Tree-Construction-and-Prediction
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
