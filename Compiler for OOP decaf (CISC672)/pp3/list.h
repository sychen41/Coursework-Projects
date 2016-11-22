/* File: list.h
 * ------------
 * Simple list class for storing a linear collection of elements. It
 * supports operations similar in name to the CS107 DArray -- nth, insert,
 * append, remove, etc.  This class is nothing more than a very thin
 * cover of a STL deque, with some added range-checking. Given not everyone
 * is familiar with the C++ templates, this class provides a more familiar
 * interface.
 *
 * It can handle elements of any type, the typename for a List includes the
 * element type in angle brackets, e.g.  to store elements of type double,
 * you would use the type name List<double>, to store elements of type
 * Decl *, it woud be List<Decl*> and so on.
 *
 * Here is some sample code illustrating the usage of a List of integers
 *
 *   int Sum(List<int> *list)
 *   {
 *       int sum = 0;
 *       for (int i = 0; i < list->NumElements(); i++) {
 *          int val = list->Nth(i);
 *          sum += val;
 *       }
 *       return sum;
 *    }
 */

#ifndef _H_list
#define _H_list

#include <deque>
#include "utility.h"  // for Assert()
#include "hashtable.h"
#include "errors.h"
#include <iostream>
#include "ast.h"
using namespace std;
class Decl;
class Type;
class Expr;
class Call;
class Stmt;
class Case;
class Identifier;
extern Hashtable<Decl*> *memTable;
extern Hashtable<Type*> *typesTable;
extern Hashtable<Expr*> *exprTable;
extern Hashtable<Stmt*> *stmtTable;
extern Hashtable<Case*> *caseTable;
template<class Element> class List {

 private:
  std::deque<Element> elems;

 public:
  // Create a new empty list
  List() {}
  
  // Returns count of elements currently in list
  int NumElements() const
  { return elems.size(); }
  
  // Returns element at index in list. Indexing is 0-based.
  // Raises an assert if index is out of range.
  Element Nth(int index) const
  { Assert(index >= 0 && index < NumElements());
    return elems[index]; }
  
  // Inserts element at index, shuffling over others
  // Raises assert if index out of range
  void InsertAt(const Element &elem, int index)
  { Assert(index >= 0 && index <= NumElements());
    elems.insert(elems.begin() + index, elem); }
  
  // Adds element to list end
  void Append(const Element &elem)
  { elems.push_back(elem); }
  
  // Removes element at index, shuffling down others
  // Raises assert if index out of range
  void RemoveAt(int index)
  { Assert(index >= 0 && index < NumElements());
    elems.erase(elems.begin() + index); }
  
  // These are some specific methods useful for lists of ast nodes
  // They will only work on lists of elements that respond to the
  // messages, but since C++ only instantiates the template if you use
  // you can still have Lists of ints, chars*, as long as you 
  // don't try to SetParentAll on that list.
  void SetParentAll(Node *p)
  { for (int i = 0; i < NumElements(); i++)
      Nth(i)->SetParent(p); }
  void PrintAll(int indentLevel, const char *label = NULL)
  { for (int i = 0; i < NumElements(); i++)
      Nth(i)->Print(indentLevel, label); }
  
  void BuildAll(int indentLevel, const char *label = NULL){ 
    
      for (int i = 0; i < NumElements(); i++){
	//table->Enter(Nth(i)->id->name, Nth(i), false);
	//Nth(i)->Build(indentLevel, label); 
      }
  }
  
  void BuildScope(Scope *scope){
    for (int i = 0; i < NumElements(); i++){
      //cout << i << " " << Nth(i)->id->name << " " << Nth(i) << "for table \n";
      scope->table->Enter(Nth(i)->id->name, Nth(i), false);
      //string s1(Nth(i)->GetPrintNameForNode());
      //if ((s1).compare("VarDecl") == 0) {
      //	  cout << "Type: " << Nth(i)->GetTypeName() << "\n";
      //}
      //cout << Nth(i)->GetPrintNameForNode() << "\n";
      //scope->table->Enter(Nth(i)->id->name, Nth(i)->GetType(), false);
      Nth(i)->Build();
    }
}

  void BuildScope2(Scope *scope){
    for (int i = 0; i < NumElements(); i++){
      //cout << i << " " << Nth(i)->id->name << " " << Nth(i) << "for table 2\n";
      scope->table2->Enter(Nth(i)->id->name, Nth(i), false);
      Nth(i)->Build();
    }
}

  void CheckScope(Scope *scope){
    for (int i = 0; i < NumElements(); i++){
      //cout << "CheckScope " << Nth(i)->id->name << "\n";
      Nth(i)->Check();
    }
}

   void StmtBuildAll(int indentLevel, const char *label = NULL){
	for (int i = 0; i < NumElements(); i++){
             stmtTable->Enter(Nth(i)->GetPrintNameForNode(), Nth(i), false);
	     //Nth(i)->Build(indentLevel, label); 
	}
}

   void CaseBuildAll(int indentLevel, const char *label = NULL){
	for (int i = 0; i < NumElements(); i++){
             caseTable->Enter(Nth(i)->GetPrintNameForNode(), Nth(i), false);
	     //Nth(i)->Build(indentLevel, label); 
	}
}

   void TypesBuildAll(int indentLevel, const char *label = NULL){
	for (int i = 0; i < NumElements(); i++){
             typesTable->Enter(Nth(i)->id->name, Nth(i), false);
	    // Nth(i)->Build(indentLevel, label); 
	}
}

   void ExprBuildAll(int indentLevel, const char *label = NULL){
	for (int i = 0; i < NumElements(); i++){
             exprTable->Enter(Nth(i)->GetPrintNameForNode(), Nth(i), false);
	     //Nth(i)->Build(indentLevel, label); 
	}
}
             
};

#endif

