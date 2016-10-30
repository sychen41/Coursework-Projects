/* File:  scanner.l
 * ----------------
 * Lex inupt file to generate the scanner for the compiler.
 */

%{

/* The text within this first region delimited by %{ and %} is assumed to
 * be C/C++ code and will be copied verbatim to the lex.yy.c file ahead
 * of the definitions of the yylex() function. Add other header file inclusions
 * or C++ variable declarations/prototypes that are needed by your code here.
 */

#include <string.h>
#include "scanner.h"
#include "utility.h" // for PrintDebug()
#include "errors.h"

/* Global variable: yylval
 * -----------------------
 * This global variable is how we get attribute information about the token
 * just scanned to the client. The scanner sets the global variable
 * appropriately and since it's global the client can just read it.  In the
 * future, this variable will be declared for us in the y.tab.c file
 * produced by Yacc, but for now, we declare it manually.
 */
YYSTYPE yylval;  // manually declared for pp1, later Yacc provides

/* Global variable: yylloc
 * -----------------------
 * This global variable is how we get position information about the token
 * just scanned to the client. (Operates similarly to yylval above)
 */
struct yyltype yylloc; // manually dclared for pp1, later Yacc provides

/* Macro: YY_USER_ACTION 
 * ---------------------
 * This flex built-in macro can be defined to provide an action which is
 * always executed prior to any matched rule's action. Basically, it is
 * a way of having a piece of code common to all actions factored out to
 * this routine.  We already defined it for you and left the empty
 * function DoBeforeEachAction ready for your use as needed. It will
 * be called once for each pattern scanned from the file, before
 * executing its action.
 */
static void DoBeforeEachAction(); 
#define YY_USER_ACTION DoBeforeEachAction();

%}

 /* The section before the first %% is the Definitions section of the lex
  * input file. Here is where you set options for the scanner, define lex
  * states, and can set up definitions to give names to regular expressions
  * as a simple substitution mechanism that allows for more readable
  * entries in the Rules section later. 
  */
tab	    [\t]+
space	    [ ]+
newLine	    [\n]+
digit	    [0-9]
dint	    {digit}+
hint	    0(X|x)({digit}|[A-F]|[a-f])+
letter	    [A-Z]|[a-z]
id	    {letter}({letter}|{digit}|_)*
doubleConst {digit}+\.{digit}*((E|e)[+-]?{digit}+)?
stringConst \"([^\"\n])*\"
notString   \"([^\"\n])*\n
boolConst   true|false

%%             /* BEGIN RULES SECTION */
 /* All patterns and actions should be placed between the start and stop
  * %% markers which delimit the Rules section. 
  */ 
{tab}		{}
{space}		{};
{newLine}	{};
int		{return(T_Int);};
void		{return(T_Void);};
double		{return(T_Double);};
bool		{return(T_Bool);};
string		{return(T_String);};
class		{return(T_Class);};
interface	{return(T_Interface);};
null		{return(T_Null);};
this		{return(T_This);};
extends		{return(T_Extends);};
implements	{return(T_Implements);};
for		{return(T_For);};
while		{return(T_While);};
if		{return(T_If);};
else		{return(T_Else);};
return		{return(T_Return);};
break		{return(T_Break);};
New		{return(T_New);};
NewArray	{return(T_NewArray);};
"<="		{return(T_LessEqual);};
">="		{return(T_GreaterEqual);};
"=="		{return(T_Equal);};
"!="		{return(T_NotEqual);};
"&&"		{return(T_And);};
"||"		{return(T_Or);};
{boolConst}	{yylval.boolConstant = *yytext == 't'? 1 : 0; return(T_BoolConstant);};
{dint}		{yylval.integerConstant = atoi(yytext); return(T_IntConstant);};
{hint}		{yylval.integerConstant = (int)(strtol(yytext,NULL,0)); return(T_IntConstant);};
{id}		{if(strlen(yytext)>(sizeof(yylval.identifier)-1))ReportError::LongIdentifier(&yylloc, yytext); strncpy(yylval.identifier, yytext, sizeof(yylval.identifier)-1); return(T_Identifier);};
{doubleConst}   {yylval.doubleConstant = atof(yytext); return(T_DoubleConstant);};
{notString}	{yylloc.last_line = 1; yylloc.last_column = 0; ReportError::UntermString(&yylloc, yytext);};
{stringConst}   {yylval.stringConstant = yytext; return(T_StringConstant);};
"+"|"-"|"*"|"/"|"%"|"<"|">"|"="|"!"|";"|","|"."|"["|"]"|"("|")"|"{"|"}" {return(*yytext);};
"@"|"#"|"$"|"^"|"~"|"&"|":"|"\\"|"?"|"`"|"'" {ReportError::UnrecogChar(&yylloc, *yytext);};
.		{/*printf("ERROR\n");*/};
%%
/* The closing %% above marks the end of the Rules section and the beginning
 * of the User Subroutines section. All text from here to the end of the
 * file is copied verbatim to the end of the generated lex.yy.c file.
 * This section is where you put definitions of helper functions.
 */


/* Function: InitScanner
 * ---------------------
 * This function will be called before any calls to yylex().  It is designed
 * to give you an opportunity to do anything that must be done to initialize
 * the scanner (set global variables, configure starting state, etc.). One
 * thing it already does for you is assign the value of the global variable
 * yy_flex_debug that controls whether flex prints debugging information
 * about each token and what rule was matched. If set to false, no information
 * is printed. Setting it to true will give you a running trail that might
 * be helpful when debugging your scanner. Please be sure the variable is
 * set to false when submitting your final version.
 */
void InitScanner()
{
    PrintDebug("lex", "Initializing scanner");
    yy_flex_debug = false;
    yylloc.first_line = 1;
    yylloc.first_column = 0;
    yylloc.last_column = 0;
    yylloc.last_line = 0; //use as a flag to indicate notString read
}


/* Function: DoBeforeEachAction()
 * ------------------------------
 * This function is installed as the YY_USER_ACTION. This is a place
 * to group code common to all actions.
 */
static void DoBeforeEachAction()
{
    if (yylloc.last_line == 1) { //had a notString (end with newline)
    	yylloc.last_line = 0;
    	yylloc.first_line+=1;
    }
    if (*yytext == '\n') {
	yylloc.first_line+=strlen(yytext);
	yylloc.first_column = 0;
	yylloc.last_column = 0;
    }
    else {
	yylloc.last_column+=strlen(yytext);
	yylloc.first_column = yylloc.last_column - strlen(yytext) + 1;
    }
}
