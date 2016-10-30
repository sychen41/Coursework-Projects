The output of our project is different than the out files in terms of line numbers. This means that if an output file has and entry like this :

*** Error line 6.
  double b;
         ^
*** Declaration of 'b' here conflicts with declaration on line 4

Our error report will switch the line numbers. Thus our error report looks like this :

*** Error line 4.
  double b;
         ^
*** Declaration of 'b' here conflicts with declaration on line 6.

Also our implementation of the rules of interface is different than the respective out file in terms of the type of error it throws.
If the method signature of the interface function and the implemented class differ in signature the error thrown by us says that all methods in the interface have not been implemented.