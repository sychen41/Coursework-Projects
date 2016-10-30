/* File: ast.cc
 * ------------
 */

#include "ast.h"
#include "ast_type.h"
#include "ast_decl.h"
#include <string.h> // strdup
#include <stdio.h>  // printf
#include "hashtable.h"
#include "errors.h"
#include <iostream>
using namespace std;
class Scope;

Node::Node(yyltype loc) {
    location = new yyltype(loc);
    parent = NULL;
    //Scope *scope = new Scope(this);
}

Node::Node() {
    location = NULL;
    parent = NULL;
    //Scope *scope = new Scope(this);
}

/* The Print method is used to print the parse tree nodes.
 * If this node has a location (most nodes do, but some do not), it
 * will first print the line number to help you match the parse tree 
 * back to the source text. It then indents the proper number of levels 
 * and prints the "print name" of the node. It then will invoke the
 * virtual function PrintChildren which is expected to print the
 * internals of the node (itself & children) as appropriate.
 */

void Node::Build(){
    BuildChildren();
}

void Node::Check(){
    Check1();
}
	 
Identifier::Identifier(yyltype loc, const char *n) : Node(loc) {
    name = strdup(n);
} 


void Identifier::BuildChildren() {

}

Scope::Scope(Node *me){
	table = new Hashtable<Node*>;
	table2 = new Hashtable<Decl*>;
	Node *backPointer = me;
}
