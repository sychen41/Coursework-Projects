/* File: ast_decl.cc
 * -----------------
 * Implementation of Decl node classes.
 */
#include "ast_decl.h"
#include "ast_type.h"
#include "ast_stmt.h"
#include "hashtable.h"
#include "ast_expr.h"
#include <string>
#include <iostream>
using namespace std;       
         
Decl::Decl(Identifier *n) : Node(*n->GetLocation()) {
    Assert(n != NULL);
    (id=n)->SetParent(this);
}

VarDecl::VarDecl(Identifier *n, Type *t) : Decl(n) {
    Assert(n != NULL && t != NULL);
    (type=t)->SetParent(this);
}
  
void VarDecl::BuildChildren() { 
   type->Build();
   id->Build();
}

ClassDecl::ClassDecl(Identifier *n, NamedType *ex, List<NamedType*> *imp, List<Decl*> *m) : Decl(n) {
    // extends can be NULL, impl & mem may be empty lists but cannot be NULL
    Assert(n != NULL && imp != NULL && m != NULL);     
    extends = ex;
    if (extends) extends->SetParent(this);
    (implements=imp)->SetParentAll(this);
    (members=m)->SetParentAll(this);
    dino = new Scope(this);
}

void ClassDecl::BuildChildren() {
    id->Build();
    if (extends) extends->Build();
    implements->BuildScope(this->dino);
    members->BuildScope2(this->dino);
}

void ClassDecl::Check1(){
	if(this->extends != NULL){
	Iterator<Node*> rex = this->GetParent()->dino->table->GetIterator();
	Decl *declaration1;
	int flag1 = 0;
	while( (declaration1 = dynamic_cast<Decl *>(rex.GetNextValue())) != NULL){
		string str1 (declaration1->id->name);	 
		string str2 (this->extends->id->name);
		if(str1.compare(str2) == 0) flag1++;
	}
	if(flag1 == 0) {ReportError::IdentifierNotDeclared(this->extends->id, LookingForClass);}
	}
	if(this->extends != NULL){
		Iterator<Decl*> iter = this->dino->table2->GetIterator();
		Decl* decl;
		int count = 1;
		while((decl = iter.GetNextValue()) != NULL){
			Decl* decl2;
			Iterator<Decl*> iter2 = this->GetParent()->dino->table->Lookup(this->extends->id->name)->dino->table2->GetIterator();
			while((decl2 = iter2.GetNextValue()) != NULL){
                                //cout << "while: " << decl2->id->name << "\n" ;
				string s1(decl->id->name);  string s2 (decl2->id->name);			
				string s3(decl->GetPrintNameForNode());
				//cout << "NameForNode: " << s3 << "\n";
				if((s1).compare(s2) == 0 && (s3).compare("VarDecl") == 0) ReportError::DeclConflict(decl, decl2);
			}
			count++;	
		}
	}
	
	Iterator<Node*> iter = this->dino->table->GetIterator();
	Iterator<Decl*> iter2 = this->dino->table2->GetIterator();
	Iterator<Node*> iter4 = this->dino->table->GetIterator();
	NamedType *nameT;
	Decl *declaration2;
	Decl *declaration3;
	int flag2 = 0;
	while((nameT = dynamic_cast<NamedType *>(iter.GetNextValue())) != NULL){
		//cout << "nameT: " << nameT->id->name << "\n";
		Iterator<Node*> iterator1 = this->GetParent()->dino->table->GetIterator();
		Decl *declaration1;
		while( (declaration1 = dynamic_cast<Decl *>(iterator1.GetNextValue())) != NULL){
			string str1 (declaration1->id->name);	 
			string str2 (nameT->id->name);
			if(str1.compare(str2) == 0) flag2++;
		}
		if(flag2 == 0) {ReportError::IdentifierNotDeclared(nameT->id, LookingForInterface);}
	}
	if(flag2 == 0) {;}		
	else{
		while((nameT = dynamic_cast<NamedType *>(iter4.GetNextValue())) != NULL){
			int count = 0; 								
			while((declaration2 = iter2.GetNextValue()) != NULL){
				Iterator<Decl*> iter3 = this->GetParent()->dino->table->Lookup(nameT->id->name)->dino->table2->GetIterator();
				while((declaration3 = iter3.GetNextValue()) != NULL){
					string s1 (declaration2->id->name);  
					string s2 (declaration3->id->name);
					if(s1.compare(s2) == 0) count++;
					if(this->extends != NULL){					
						Iterator<Decl*> iterator2 = this->GetParent()->dino->table->Lookup(this->extends->id->name)->dino->table2->GetIterator();  Decl *victor;
						while((victor = iterator2.GetNextValue()) != NULL){
							string me (victor->id->name);
							if(me.compare(s2) == 0) count++;													
						}
					}
					if(count == 0) ReportError::InterfaceNotImplemented(this, dynamic_cast<Decl *>(this->GetParent()->dino->table->Lookup(nameT->id->name)));
					}
				}
			}
		}
	//cout << "start\n";
	Iterator<Decl*> iter5 = this->dino->table2->GetIterator();
	Decl* decl;
	int count = 1;
	while((decl = dynamic_cast<Decl *>(iter5.GetNextValue())) != NULL){
		//cout << decl->id->name << "\n";
		Decl* decl2;
		Iterator<Decl*> iter6 = this->dino->table2->GetIterator();
		for(int a = 0; a < count; a++){decl2 = dynamic_cast<Decl *>(iter6.GetNextValue());}
		while((decl2 = dynamic_cast<Decl *>(iter6.GetNextValue())) != NULL){
			string s1(decl->id->name);  
			string s2 (decl2->id->name);			
			if((s1).compare(s2) == 0) ReportError::DeclConflict(decl, decl2);
		}
	count++;	
	}
	//cout << "end\n";

}

InterfaceDecl::InterfaceDecl(Identifier *n, List<Decl*> *m) : Decl(n) {
    Assert(n != NULL && m != NULL);
    (members=m)->SetParentAll(this);
    dino = new Scope(this);
}

void InterfaceDecl::BuildChildren() {
    id->Build();
    members->BuildScope2(this->dino);
}

void InterfaceDecl::Check1(){
}
	
FnDecl::FnDecl(Identifier *n, Type *r, List<VarDecl*> *d) : Decl(n) {
    Assert(n != NULL && r!= NULL && d != NULL);
    (returnType=r)->SetParent(this);
    (formals=d)->SetParentAll(this);
    body = NULL;
    dino = new Scope(this);
}

void FnDecl::SetFunctionBody(Stmt *b) { 
    (body=b)->SetParent(this);
}

void FnDecl::BuildChildren() {
    returnType->Build();
    id->Build();
    if(this->GetParent()->dino->table->Lookup(this->id->name) == NULL) ReportError::IdentifierNotDeclared(this->id, LookingForFunction);
    formals->BuildScope(this->dino);
    if (body) body->Build();
}

void FnDecl::Check1() {
	Iterator<Node*> iter = this->dino->table->GetIterator();
	Decl* decl;
	int count = 1;
	while((decl = dynamic_cast<Decl *>(iter.GetNextValue())) != NULL){
		Decl* decl2;
		Iterator<Node*> iter2 = this->dino->table->GetIterator();
		for(int a = 0; a < count; a++){decl2 = dynamic_cast<Decl *>(iter2.GetNextValue());}
		while((decl2 = dynamic_cast<Decl *>(iter2.GetNextValue())) != NULL){
			string s1(decl->id->name);  string s2 (decl2->id->name);			
			if((s1).compare(s2) == 0) ReportError::DeclConflict(decl, decl2);
		}
	count++;	
	}
	//cout << "start Fn\n";
	Iterator<Decl*> iter5 = this->dino->table2->GetIterator();
	Decl* decl3;
	count = 1;
	while((decl3 = dynamic_cast<Decl *>(iter5.GetNextValue())) != NULL){
		//cout << decl3->id->name << "\n";
		Decl* decl2;
		Iterator<Decl*> iter6 = this->dino->table2->GetIterator();
		for(int a = 0; a < count; a++){decl2 = dynamic_cast<Decl *>(iter6.GetNextValue());}
		while((decl2 = dynamic_cast<Decl *>(iter6.GetNextValue())) != NULL){
			string s1(decl3->id->name);  string s2 (decl2->id->name);			
			if((s1).compare(s2) == 0) ReportError::DeclConflict(decl3, decl2);
		}
	count++;	
	}
	//cout << "end Fn\n";
}


