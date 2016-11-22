# DTproject_AI
This is a python program that creates a decision tree and outputs a .tgf file that can show the whole structure of the tree.

1.	The code is written in python 3.5. Here is the easiest way to run it:
  a.	Download the corresponding version via https://www.python.org/downloads/ 
  b.	Open the code in IDLE, at line 471, change the “folder_path” to your own path.
  c.  Click run from the menu.
  

2.	The program addresses two different data: mpg_cars.csv and wbdc-train.data
  a.	For mpg_cars.csv, since it’s not the conventional data format, we need to do the following steps: 
    i.	Manually change the extention from csv to txt
    ii.	Manually delete the first line which contains all attribute names.
    iii.	Create a new file called “car_att_names.txt” that contains one attribute name per line.
  b.	For wbdc data, also create a new file called “wdbc-att-names.txt” that contains one attribute name per line. You can find these names from wdbc.info. Note that we use abbreviations for attribute names. i.e., CT of Clump Thickness

3.	The output of the program including the following:
  a.	Whether a discretization method is applied to the data. (you can change the method by setting the value of variable “discretization_type” at line 505. “f” for fixed frequency, otherwise for fixed interval
  b.	Whether there is a nominal-value attribute that has been changed to integer-value attribute. For instance, in mpg_car data, the value of “maker” has been changed.
  c.	Number of instances in training data
  d.	Number of instances in testing data
  e.	Whether pre-prune is applied. (you can choose to turn on and off this feature by setting the value of variable “pre_prune_threshold” at line 485 and 532.)
  f.	Max depth of the decision tree
  g.	Total number of node of the decision tree
  h.	Tree graph, which is a .tgf file that can be open by a free software “yEd Graph Editor”. (Download link: https://www.yworks.com/downloads#yEd. Once installed, following the following step to see the tree:
    i.	Double click the tree_part2.tgf or tree_part3.tgf. 
    ii.	When asked whether to ignore Nodl/Edge labels, DON’T check the box and click “Ok”
    iii.	From the top menu, click Layout => Tree => Directed. In the new window “Treelike Layout”, click “Ok”. You should see a tree. Zoom in/out if needed.
  i.	Accuracy on training/testing data
  j.	Recall on training/testing data
  k.	The original output of the decision tree before converting to a .tgf file. (Only for part 2, the car data)

4.	For applying the program on your own data, make the following changes:
	a.	at line 473, set part3 = True
	b.	at line 477, 478, use your data's names
	c.	at line 490, set the class_index accordingly. For instance, if in you data, if the class is the first attribute, then set it to 0. if it's the last attribute, set it to -1. 
	d.	Node that this program only accepts data that are comma sepereted.
