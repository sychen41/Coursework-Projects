
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 1



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 10 "parser.y"


/* Just like lex, the text within this first region delimited by %{ and %}
 * is assumed to be C/C++ code and will be copied verbatim to the y.tab.c
 * file ahead of the definitions of the yyparse() function. Add other header
 * file inclusions or C++ variable declarations/prototypes that are needed
 * by your code here.
 */
#include "scanner.h" // for yylex
#include "parser.h"
#include "errors.h"

void yyerror(const char *msg); // standard error-handling routine



/* Line 189 of yacc.c  */
#line 90 "y.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     T_Void = 258,
     T_Bool = 259,
     T_Int = 260,
     T_Double = 261,
     T_String = 262,
     T_Class = 263,
     T_LessEqual = 264,
     T_GreaterEqual = 265,
     T_Equal = 266,
     T_NotEqual = 267,
     T_Dims = 268,
     T_Increment = 269,
     T_Decrement = 270,
     T_And = 271,
     T_Or = 272,
     T_Null = 273,
     T_Extends = 274,
     T_This = 275,
     T_Interface = 276,
     T_Implements = 277,
     T_While = 278,
     T_For = 279,
     T_If = 280,
     T_Else = 281,
     T_Return = 282,
     T_Break = 283,
     T_Switch = 284,
     T_Case = 285,
     T_Default = 286,
     T_New = 287,
     T_NewArray = 288,
     T_Print = 289,
     T_ReadInteger = 290,
     T_ReadLine = 291,
     T_Identifier = 292,
     T_StringConstant = 293,
     T_IntConstant = 294,
     T_DoubleConstant = 295,
     T_BoolConstant = 296,
     LOWER_THAN_ELSE = 297,
     UMINUS = 298
   };
#endif
/* Tokens.  */
#define T_Void 258
#define T_Bool 259
#define T_Int 260
#define T_Double 261
#define T_String 262
#define T_Class 263
#define T_LessEqual 264
#define T_GreaterEqual 265
#define T_Equal 266
#define T_NotEqual 267
#define T_Dims 268
#define T_Increment 269
#define T_Decrement 270
#define T_And 271
#define T_Or 272
#define T_Null 273
#define T_Extends 274
#define T_This 275
#define T_Interface 276
#define T_Implements 277
#define T_While 278
#define T_For 279
#define T_If 280
#define T_Else 281
#define T_Return 282
#define T_Break 283
#define T_Switch 284
#define T_Case 285
#define T_Default 286
#define T_New 287
#define T_NewArray 288
#define T_Print 289
#define T_ReadInteger 290
#define T_ReadLine 291
#define T_Identifier 292
#define T_StringConstant 293
#define T_IntConstant 294
#define T_DoubleConstant 295
#define T_BoolConstant 296
#define LOWER_THAN_ELSE 297
#define UMINUS 298




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 40 "parser.y"

    Program *program;
    
    int integerConstant;
    bool boolConstant;
    const char *stringConstant;
    double doubleConstant;
    char identifier[MaxIdentLen+1]; // +1 for terminating null
    Decl *decl;
  

    VarDecl *vardecl;
    FnDecl *fndecl;
    ClassDecl *classdecl;
    InterfaceDecl *interfacedecl;  
    
    Type *simpletype;
    NamedType *namedtype;
    ArrayType *arraytype;
    
    List<NamedType*> *implements;
    List<Decl*> *declList;
    List<VarDecl*> *vardecls;
      
   
    StmtBlock *stmtblock;
    Stmt *stmt;
    IfStmt *ifstmt;
    ForStmt *forstmt;
    WhileStmt *whilestmt;
    ReturnStmt *rtnstmt;	
    BreakStmt *brkstmt;
    SwitchStmt *switchstmt;
    CaseStmt *casestmt;
    DefaultStmt *defaultstmt;
    PrintStmt *pntstmt;
    List<Stmt*> *stmts;
    List<CaseStmt*> *casestmts;
    
    Expr *expr;
    Expr *optexpr;
    List<Expr*> *exprs;
    Call *call;
    
    IntConstant *intconst;
    DoubleConstant *doubleconst;
    BoolConstant *boolconst;
    StringConstant *stringconst;
    NullConstant *nullconst;
    
    ArithmeticExpr *arithmeticexpr;
    RelationalExpr *relationalexpr;
    EqualityExpr   *equalityexpr;
    LogicalExpr    *logicalexpr;
    AssignExpr     *assignexpr;
    PostfixExpr    *postfixexpr;
    
    LValue *lvalue;
    FieldAccess *fieldaccess;
    ArrayAccess *arrayaccess;



/* Line 214 of yacc.c  */
#line 276 "y.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 301 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
	     && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  22
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   621

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  63
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  54
/* YYNRULES -- Number of rules.  */
#define YYNRULES  126
/* YYNRULES -- Number of states.  */
#define YYNSTATES  235

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   298

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    51,     2,     2,     2,    50,     2,     2,
      56,    57,    48,    46,    58,    47,    54,    49,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    61,    55,
      44,    43,    45,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    53,     2,    62,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    59,     2,    60,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    52
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     8,    10,    12,    14,    16,    18,
      22,    24,    26,    28,    30,    32,    34,    36,    39,    46,
      53,    55,    56,    61,    64,    72,    79,    82,    83,    86,
      87,    91,    93,    96,    98,   100,   102,   108,   113,   116,
     118,   125,   132,   137,   141,   144,   145,   148,   150,   153,
     155,   157,   159,   161,   163,   165,   167,   169,   175,   183,
     189,   199,   203,   206,   215,   218,   220,   225,   229,   233,
     234,   240,   242,   244,   246,   248,   250,   254,   256,   258,
     260,   262,   264,   268,   272,   275,   282,   286,   290,   294,
     298,   302,   306,   309,   312,   315,   319,   323,   327,   331,
     335,   339,   343,   347,   350,   354,   356,   358,   359,   361,
     363,   365,   369,   374,   381,   386,   388,   389,   391,   393,
     395,   397,   399,   401,   403,   405,   407
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      64,     0,    -1,    65,    -1,    65,    66,    -1,    66,    -1,
      67,    -1,    71,    -1,    74,    -1,    80,    -1,    68,    37,
      55,    -1,     5,    -1,     6,    -1,     4,    -1,     7,    -1,
      69,    -1,    70,    -1,    37,    -1,    68,    13,    -1,    68,
      37,    56,    72,    57,    83,    -1,     3,    37,    56,    72,
      57,    83,    -1,    73,    -1,    -1,    73,    58,    68,    37,
      -1,    68,    37,    -1,     8,    37,    75,    76,    59,    78,
      60,    -1,     8,    37,    75,    76,    59,    60,    -1,    19,
      69,    -1,    -1,    22,    77,    -1,    -1,    77,    58,    69,
      -1,    69,    -1,    78,    79,    -1,    79,    -1,    67,    -1,
      71,    -1,    21,    37,    59,    81,    60,    -1,    21,    37,
      59,    60,    -1,    81,    82,    -1,    82,    -1,    68,    37,
      56,    72,    57,    55,    -1,     3,    37,    56,    72,    57,
      55,    -1,    59,    84,    85,    60,    -1,    59,    84,    60,
      -1,    84,    67,    -1,    -1,    85,    86,    -1,    86,    -1,
     105,    55,    -1,    87,    -1,    88,    -1,    89,    -1,    91,
      -1,    90,    -1,    92,    -1,    96,    -1,    83,    -1,    25,
      56,    97,    57,    86,    -1,    25,    56,    97,    57,    86,
      26,    86,    -1,    23,    56,    97,    57,    86,    -1,    24,
      56,   105,    55,    97,    55,   105,    57,    86,    -1,    27,
     105,    55,    -1,    28,    55,    -1,    29,    56,    97,    57,
      59,    93,    95,    60,    -1,    93,    94,    -1,    94,    -1,
      30,   112,    61,    85,    -1,    30,   112,    61,    -1,    31,
      61,    85,    -1,    -1,    34,    56,   104,    57,    55,    -1,
      98,    -1,   111,    -1,   106,    -1,    20,    -1,   108,    -1,
      56,    97,    57,    -1,    99,    -1,   101,    -1,   102,    -1,
     103,    -1,   100,    -1,    35,    56,    57,    -1,    36,    56,
      57,    -1,    32,    37,    -1,    33,    56,    97,    58,    68,
      57,    -1,   106,    43,    97,    -1,    97,    46,    97,    -1,
      97,    47,    97,    -1,    97,    48,    97,    -1,    97,    49,
      97,    -1,    97,    50,    97,    -1,    47,    97,    -1,   106,
      14,    -1,   106,    15,    -1,    97,    11,    97,    -1,    97,
      12,    97,    -1,    97,    44,    97,    -1,    97,    45,    97,
      -1,    97,     9,    97,    -1,    97,    10,    97,    -1,    97,
      16,    97,    -1,    97,    17,    97,    -1,    51,    97,    -1,
     104,    58,    97,    -1,    97,    -1,    97,    -1,    -1,   107,
      -1,   109,    -1,    37,    -1,    97,    54,    37,    -1,    37,
      56,   110,    57,    -1,    97,    54,    37,    56,   110,    57,
      -1,    97,    53,    97,    62,    -1,   104,    -1,    -1,   112,
      -1,   113,    -1,   114,    -1,   115,    -1,   116,    -1,    39,
      -1,    40,    -1,    41,    -1,    38,    -1,    18,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   221,   221,   236,   237,   240,   241,   242,   243,   246,
     249,   250,   251,   252,   253,   254,   257,   260,   263,   266,
     271,   272,   275,   277,   280,   282,   286,   288,   291,   293,
     296,   298,   301,   302,   305,   306,   309,   311,   315,   316,
     319,   321,   325,   326,   329,   330,   333,   334,   337,   338,
     339,   340,   341,   342,   343,   344,   345,   349,   351,   356,
     360,   364,   367,   370,   374,   375,   378,   380,   383,   384,
     387,   391,   392,   393,   394,   395,   396,   397,   398,   399,
     400,   401,   402,   403,   404,   405,   409,   413,   414,   415,
     416,   417,   418,   422,   423,   426,   428,   432,   434,   436,
     438,   442,   444,   446,   450,   451,   454,   455,   459,   460,
     463,   464,   468,   470,   474,   477,   478,   481,   482,   483,
     484,   485,   488,   491,   494,   497,   500
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "T_Void", "T_Bool", "T_Int", "T_Double",
  "T_String", "T_Class", "T_LessEqual", "T_GreaterEqual", "T_Equal",
  "T_NotEqual", "T_Dims", "T_Increment", "T_Decrement", "T_And", "T_Or",
  "T_Null", "T_Extends", "T_This", "T_Interface", "T_Implements",
  "T_While", "T_For", "T_If", "T_Else", "T_Return", "T_Break", "T_Switch",
  "T_Case", "T_Default", "T_New", "T_NewArray", "T_Print", "T_ReadInteger",
  "T_ReadLine", "T_Identifier", "T_StringConstant", "T_IntConstant",
  "T_DoubleConstant", "T_BoolConstant", "LOWER_THAN_ELSE", "'='", "'<'",
  "'>'", "'+'", "'-'", "'*'", "'/'", "'%'", "'!'", "UMINUS", "'['", "'.'",
  "';'", "'('", "')'", "','", "'{'", "'}'", "':'", "']'", "$accept",
  "Program", "DeclList", "Decl", "VarDecl", "Type", "NamedType",
  "ArrayType", "FnDecl", "Formals", "Variables", "ClassDecl", "Extend",
  "Impl", "Implements", "Fields", "Field", "InterfaceDecl", "Prototypes",
  "Prototype", "StmtBlock", "VarDecls", "Stmts", "Stmt", "IfStmt",
  "WhileStmt", "ForStmt", "ReturnStmt", "BreakStmt", "SwitchStmt", "Cases",
  "Case", "Default", "PrintStmt", "Expr", "AssignExpr", "ArithmeticExpr",
  "PostfixExpr", "EqualityExpr", "RelationalExpr", "LogicalExpr", "Exprs",
  "OptExpr", "LValue", "FieldAccess", "Call", "ArrayAccess", "Actuals",
  "Constant", "IntConstant", "DoubleConstant", "BoolConstant",
  "StringConstant", "NullConstant", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,    61,    60,    62,    43,    45,    42,    47,
      37,    33,   298,    91,    46,    59,    40,    41,    44,   123,
     125,    58,    93
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    63,    64,    65,    65,    66,    66,    66,    66,    67,
      68,    68,    68,    68,    68,    68,    69,    70,    71,    71,
      72,    72,    73,    73,    74,    74,    75,    75,    76,    76,
      77,    77,    78,    78,    79,    79,    80,    80,    81,    81,
      82,    82,    83,    83,    84,    84,    85,    85,    86,    86,
      86,    86,    86,    86,    86,    86,    86,    87,    87,    88,
      89,    90,    91,    92,    93,    93,    94,    94,    95,    95,
      96,    97,    97,    97,    97,    97,    97,    97,    97,    97,
      97,    97,    97,    97,    97,    97,    98,    99,    99,    99,
      99,    99,    99,   100,   100,   101,   101,   102,   102,   102,
     102,   103,   103,   103,   104,   104,   105,   105,   106,   106,
     107,   107,   108,   108,   109,   110,   110,   111,   111,   111,
     111,   111,   112,   113,   114,   115,   116
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     1,     1,     1,     3,
       1,     1,     1,     1,     1,     1,     1,     2,     6,     6,
       1,     0,     4,     2,     7,     6,     2,     0,     2,     0,
       3,     1,     2,     1,     1,     1,     5,     4,     2,     1,
       6,     6,     4,     3,     2,     0,     2,     1,     2,     1,
       1,     1,     1,     1,     1,     1,     1,     5,     7,     5,
       9,     3,     2,     8,     2,     1,     4,     3,     3,     0,
       5,     1,     1,     1,     1,     1,     3,     1,     1,     1,
       1,     1,     3,     3,     2,     6,     3,     3,     3,     3,
       3,     3,     2,     2,     2,     3,     3,     3,     3,     3,
       3,     3,     3,     2,     3,     1,     1,     0,     1,     1,
       1,     3,     4,     6,     4,     1,     0,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,    12,    10,    11,    13,     0,     0,    16,     0,
       2,     4,     5,     0,    14,    15,     6,     7,     8,     0,
      27,     0,     1,     3,    17,     0,    21,     0,    29,     0,
       9,    21,     0,     0,    20,    26,     0,     0,     0,    37,
       0,     0,    39,     0,    23,     0,     0,    31,    28,     0,
       0,     0,    36,    38,     0,    45,    19,     0,     0,    25,
      34,    35,     0,    33,    21,    21,    18,   107,    22,    30,
      24,    32,     0,     0,   126,    74,     0,     0,     0,   107,
       0,     0,     0,     0,     0,     0,     0,   110,   125,   122,
     123,   124,     0,     0,     0,    43,    44,     0,    56,   107,
      47,    49,    50,    51,    53,    52,    54,    55,   106,    71,
      77,    81,    78,    79,    80,     0,    73,   108,    75,   109,
      72,   117,   118,   119,   120,   121,     0,     0,     0,   107,
       0,   110,     0,    62,     0,    84,     0,     0,     0,     0,
     116,    92,   103,     0,     0,    42,    46,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    48,    93,    94,     0,    41,    40,     0,     0,
       0,    61,     0,     0,   105,     0,    82,    83,   115,     0,
      76,    99,   100,    95,    96,   101,   102,    97,    98,    87,
      88,    89,    90,    91,     0,   111,    86,   107,     0,   107,
       0,     0,     0,     0,   112,   114,   116,    59,     0,    57,
       0,     0,    70,   104,     0,   107,   107,     0,    69,    65,
      85,   113,     0,    58,     0,     0,    64,     0,   107,    67,
     107,    63,    60,    66,    68
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     9,    10,    11,    12,    13,    14,    15,    16,    33,
      34,    17,    28,    37,    48,    62,    63,    18,    41,    42,
      98,    67,    99,   100,   101,   102,   103,   104,   105,   106,
     218,   219,   227,   107,   108,   109,   110,   111,   112,   113,
     114,   178,   115,   116,   117,   118,   119,   179,   120,   121,
     122,   123,   124,   125
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -96
static const yytype_int16 yypact[] =
{
      91,   -35,   -96,   -96,   -96,   -96,    -5,     6,   -96,    45,
      91,   -96,   -96,    -1,   -96,   -96,   -96,   -96,   -96,     3,
      84,    46,   -96,   -96,   -96,   -49,    12,    74,    93,    18,
     -96,    12,    21,    67,    76,   -96,    74,    83,   103,   -96,
      24,    23,   -96,    87,   -96,    88,    12,   -96,    97,    81,
      95,   100,   -96,   -96,    88,   -96,   -96,    64,    74,   -96,
     -96,   -96,    86,   -96,    12,    12,   -96,   125,   -96,   -96,
     -96,   -96,   110,   114,   -96,   -96,   121,   122,   123,   565,
     127,   124,   146,   134,   135,   136,   139,    -2,   -96,   -96,
     -96,   -96,   565,   565,   565,   -96,   -96,    69,   -96,   457,
     -96,   -96,   -96,   -96,   -96,   -96,   -96,   -96,   341,   -96,
     -96,   -96,   -96,   -96,   -96,   141,    65,   -96,   -96,   -96,
     -96,   -96,   -96,   -96,   -96,   -96,   147,   148,   565,   565,
     565,   145,   151,   -96,   565,   -96,   565,   565,   150,   152,
     565,    56,    56,   203,   153,   -96,   -96,   565,   565,   565,
     565,   565,   565,   565,   565,   565,   565,   565,   565,   565,
     565,   173,   -96,   -96,   -96,   565,   -96,   -96,   252,   156,
     266,   -96,   315,   188,   341,    59,   -96,   -96,   158,   160,
     -96,   420,   420,   398,   398,   409,   387,   420,   420,   120,
     120,    56,    56,    56,   177,   162,   341,   540,   565,   540,
     169,    12,   174,   565,   -96,   -96,   565,   -96,   329,   214,
     213,     0,   -96,   341,   187,   565,   540,   206,    96,   -96,
     -96,   -96,   197,   -96,   194,   198,   -96,   205,   540,   500,
     540,   -96,   -96,   500,   500
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -96,   -96,   -96,   248,    58,   -26,     4,   -96,    51,   -17,
     -96,   -96,   -96,   -96,   -96,   -96,   204,   -96,   -96,   226,
     -12,   -96,   -94,   -95,   -96,   -96,   -96,   -96,   -96,   -96,
     -96,    52,   -96,   -96,   -84,   -96,   -96,   -96,   -96,   -96,
     -96,   137,   -78,   -96,   -96,   -96,   -96,    66,   -96,    54,
     -96,   -96,   -96,   -96
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -108
static const yytype_int16 yytable[] =
{
      32,   132,    19,    40,   146,    32,    30,    31,   141,   142,
     143,   -16,    24,    24,    43,    40,     2,     3,     4,     5,
      57,    38,     2,     3,     4,     5,    38,     2,     3,     4,
       5,    35,    20,    56,    24,   -16,    25,    24,    32,    32,
      47,    97,    66,    21,   168,    22,   170,    72,    73,     8,
     172,   169,   173,   174,   140,     8,   174,   220,    44,    26,
       8,    51,    69,   181,   182,   183,   184,   185,   186,   187,
     188,   189,   190,   191,   192,   193,   194,    24,    39,   163,
     164,   196,    24,    52,     1,     2,     3,     4,     5,     1,
       2,     3,     4,     5,     1,     2,     3,     4,     5,     6,
      61,    68,   207,    27,   209,    29,   144,    60,   165,   160,
     161,     8,     7,    61,   208,    36,   202,   203,     8,   213,
      60,   223,   174,     8,    45,    96,   217,   225,     8,     2,
       3,     4,     5,   232,    46,   233,   234,   222,   146,   146,
      50,    59,    49,    74,    54,    75,    70,    55,    76,    77,
      78,    64,    79,    80,    81,    58,    65,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,   126,   157,   158,
     159,   127,    92,   160,   161,   211,    93,   128,   129,   130,
     134,    94,   133,   135,    55,    95,   147,   148,   149,   150,
     136,   137,   138,   151,   152,   139,   162,   147,   148,   149,
     150,   140,   166,   167,   151,   152,   171,   176,    30,   177,
     195,   198,   147,   148,   149,   150,   203,   204,   206,   151,
     152,   153,   154,   155,   156,   157,   158,   159,   210,   212,
     160,   161,   153,   154,   155,   156,   157,   158,   159,   205,
     216,   160,   161,   217,   221,    89,   201,   153,   154,   155,
     156,   157,   158,   159,   228,   229,   160,   161,    23,   230,
     180,   147,   148,   149,   150,   231,    71,    53,   151,   152,
     226,   224,   214,     0,   175,   147,   148,   149,   150,     0,
       0,     0,   151,   152,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   153,   154,   155,   156,
     157,   158,   159,     0,     0,   160,   161,     0,     0,   197,
     153,   154,   155,   156,   157,   158,   159,     0,     0,   160,
     161,     0,     0,   199,   147,   148,   149,   150,     0,     0,
       0,   151,   152,     0,     0,     0,     0,     0,   147,   148,
     149,   150,     0,     0,     0,   151,   152,     0,     0,     0,
     147,   148,   149,   150,     0,     0,     0,   151,   152,   153,
     154,   155,   156,   157,   158,   159,     0,     0,   160,   161,
       0,     0,   200,   153,   154,   155,   156,   157,   158,   159,
       0,     0,   160,   161,   215,   153,   154,   155,   156,   157,
     158,   159,     0,     0,   160,   161,   147,   148,   149,   150,
       0,     0,     0,   151,     0,     0,     0,   147,   148,  -108,
    -108,     0,     0,     0,     0,     0,     0,     0,   147,   148,
     149,   150,     0,     0,     0,     0,     0,     0,     0,  -108,
    -108,   153,   154,   155,   156,   157,   158,   159,     0,     0,
     160,   161,   153,   154,   155,   156,   157,   158,   159,     0,
       0,   160,   161,   153,   154,   155,   156,   157,   158,   159,
       0,     0,   160,   161,  -108,  -108,   155,   156,   157,   158,
     159,     0,     0,   160,   161,    74,     0,    75,     0,     0,
      76,    77,    78,     0,    79,    80,    81,     0,     0,    82,
      83,    84,    85,    86,   131,    88,    89,    90,    91,     0,
       0,     0,     0,     0,    92,     0,     0,     0,    93,     0,
       0,     0,     0,    94,     0,     0,    55,   145,    74,     0,
      75,     0,     0,    76,    77,    78,     0,    79,    80,    81,
       0,     0,    82,    83,    84,    85,    86,   131,    88,    89,
      90,    91,     0,     0,     0,     0,     0,    92,     0,     0,
       0,    93,     0,     0,     0,  -107,    94,     0,    74,    55,
      75,     0,     0,    76,    77,    78,     0,    79,    80,    81,
       0,     0,    82,    83,    84,    85,    86,   131,    88,    89,
      90,    91,     0,    74,     0,    75,     0,    92,     0,     0,
       0,    93,     0,     0,     0,     0,    94,    82,    83,    55,
      85,    86,   131,    88,    89,    90,    91,     0,     0,     0,
       0,     0,    92,     0,     0,     0,    93,     0,     0,     0,
       0,    94
};

static const yytype_int16 yycheck[] =
{
      26,    79,    37,    29,    99,    31,    55,    56,    92,    93,
      94,    13,    13,    13,    31,    41,     4,     5,     6,     7,
      46,     3,     4,     5,     6,     7,     3,     4,     5,     6,
       7,    27,    37,    45,    13,    37,    37,    13,    64,    65,
      36,    67,    54,    37,   128,     0,   130,    64,    65,    37,
     134,   129,   136,   137,    56,    37,   140,    57,    37,    56,
      37,    37,    58,   147,   148,   149,   150,   151,   152,   153,
     154,   155,   156,   157,   158,   159,   160,    13,    60,    14,
      15,   165,    13,    60,     3,     4,     5,     6,     7,     3,
       4,     5,     6,     7,     3,     4,     5,     6,     7,     8,
      49,    37,   197,    19,   199,    59,    37,    49,    43,    53,
      54,    37,    21,    62,   198,    22,    57,    58,    37,   203,
      62,   216,   206,    37,    57,    67,    30,    31,    37,     4,
       5,     6,     7,   228,    58,   229,   230,   215,   233,   234,
      37,    60,    59,    18,    57,    20,    60,    59,    23,    24,
      25,    56,    27,    28,    29,    58,    56,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    57,    48,    49,
      50,    57,    47,    53,    54,   201,    51,    56,    56,    56,
      56,    56,    55,    37,    59,    60,     9,    10,    11,    12,
      56,    56,    56,    16,    17,    56,    55,     9,    10,    11,
      12,    56,    55,    55,    16,    17,    55,    57,    55,    57,
      37,    55,     9,    10,    11,    12,    58,    57,    56,    16,
      17,    44,    45,    46,    47,    48,    49,    50,    59,    55,
      53,    54,    44,    45,    46,    47,    48,    49,    50,    62,
      26,    53,    54,    30,    57,    39,    58,    44,    45,    46,
      47,    48,    49,    50,    57,    61,    53,    54,    10,    61,
      57,     9,    10,    11,    12,    60,    62,    41,    16,    17,
     218,   217,   206,    -1,   137,     9,    10,    11,    12,    -1,
      -1,    -1,    16,    17,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    44,    45,    46,    47,
      48,    49,    50,    -1,    -1,    53,    54,    -1,    -1,    57,
      44,    45,    46,    47,    48,    49,    50,    -1,    -1,    53,
      54,    -1,    -1,    57,     9,    10,    11,    12,    -1,    -1,
      -1,    16,    17,    -1,    -1,    -1,    -1,    -1,     9,    10,
      11,    12,    -1,    -1,    -1,    16,    17,    -1,    -1,    -1,
       9,    10,    11,    12,    -1,    -1,    -1,    16,    17,    44,
      45,    46,    47,    48,    49,    50,    -1,    -1,    53,    54,
      -1,    -1,    57,    44,    45,    46,    47,    48,    49,    50,
      -1,    -1,    53,    54,    55,    44,    45,    46,    47,    48,
      49,    50,    -1,    -1,    53,    54,     9,    10,    11,    12,
      -1,    -1,    -1,    16,    -1,    -1,    -1,     9,    10,    11,
      12,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     9,    10,
      11,    12,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     9,
      10,    44,    45,    46,    47,    48,    49,    50,    -1,    -1,
      53,    54,    44,    45,    46,    47,    48,    49,    50,    -1,
      -1,    53,    54,    44,    45,    46,    47,    48,    49,    50,
      -1,    -1,    53,    54,    44,    45,    46,    47,    48,    49,
      50,    -1,    -1,    53,    54,    18,    -1,    20,    -1,    -1,
      23,    24,    25,    -1,    27,    28,    29,    -1,    -1,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    -1,
      -1,    -1,    -1,    -1,    47,    -1,    -1,    -1,    51,    -1,
      -1,    -1,    -1,    56,    -1,    -1,    59,    60,    18,    -1,
      20,    -1,    -1,    23,    24,    25,    -1,    27,    28,    29,
      -1,    -1,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    -1,    -1,    -1,    -1,    -1,    47,    -1,    -1,
      -1,    51,    -1,    -1,    -1,    55,    56,    -1,    18,    59,
      20,    -1,    -1,    23,    24,    25,    -1,    27,    28,    29,
      -1,    -1,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    -1,    18,    -1,    20,    -1,    47,    -1,    -1,
      -1,    51,    -1,    -1,    -1,    -1,    56,    32,    33,    59,
      35,    36,    37,    38,    39,    40,    41,    -1,    -1,    -1,
      -1,    -1,    47,    -1,    -1,    -1,    51,    -1,    -1,    -1,
      -1,    56
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,    21,    37,    64,
      65,    66,    67,    68,    69,    70,    71,    74,    80,    37,
      37,    37,     0,    66,    13,    37,    56,    19,    75,    59,
      55,    56,    68,    72,    73,    69,    22,    76,     3,    60,
      68,    81,    82,    72,    37,    57,    58,    69,    77,    59,
      37,    37,    60,    82,    57,    59,    83,    68,    58,    60,
      67,    71,    78,    79,    56,    56,    83,    84,    37,    69,
      60,    79,    72,    72,    18,    20,    23,    24,    25,    27,
      28,    29,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    47,    51,    56,    60,    67,    68,    83,    85,
      86,    87,    88,    89,    90,    91,    92,    96,    97,    98,
      99,   100,   101,   102,   103,   105,   106,   107,   108,   109,
     111,   112,   113,   114,   115,   116,    57,    57,    56,    56,
      56,    37,   105,    55,    56,    37,    56,    56,    56,    56,
      56,    97,    97,    97,    37,    60,    86,     9,    10,    11,
      12,    16,    17,    44,    45,    46,    47,    48,    49,    50,
      53,    54,    55,    14,    15,    43,    55,    55,    97,   105,
      97,    55,    97,    97,    97,   104,    57,    57,   104,   110,
      57,    97,    97,    97,    97,    97,    97,    97,    97,    97,
      97,    97,    97,    97,    97,    37,    97,    57,    55,    57,
      57,    58,    57,    58,    57,    62,    56,    86,    97,    86,
      59,    68,    55,    97,   110,    55,    26,    30,    93,    94,
      57,    57,   105,    86,   112,    31,    94,    95,    57,    61,
      61,    60,    86,    85,    85
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (!yyvaluep)
    return;
  YYUSE (yylocationp);
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yylsp, yyrule)
    YYSTYPE *yyvsp;
    YYLTYPE *yylsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       , &(yylsp[(yyi + 1) - (yynrhs)])		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, yylsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
#else
static void
yydestruct (yymsg, yytype, yyvaluep, yylocationp)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
    YYLTYPE *yylocationp;
#endif
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Location data for the lookahead symbol.  */
YYLTYPE yylloc;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.
       `yyls': related to locations.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[2];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;
  yylsp = yyls;

#if YYLTYPE_IS_TRIVIAL
  /* Initialize the default location before parsing starts.  */
  yylloc.first_line   = yylloc.last_line   = 1;
  yylloc.first_column = yylloc.last_column = 1;
#endif

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;
	YYLTYPE *yyls1 = yyls;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yyls1, yysize * sizeof (*yylsp),
		    &yystacksize);

	yyls = yyls1;
	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
	YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location.  */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:

/* Line 1455 of yacc.c  */
#line 221 "parser.y"
    {
                                      (yylsp[(1) - (1)]);
                                      /* pp2: The @1 is needed to convince
                                       * yacc to set up yylloc. You can remove
                                       * it once you have other uses of @n*/
                                      (yyval.program) = new Program((yyvsp[(1) - (1)].declList));
                                      // if no errors, advance to next phase
                                      if (ReportError::NumErrors() == 0)
                                        {
                                          (yyval.program)->CheckDeclError();
                                          (yyval.program)->CheckStatements();
                                        }
                                     }
    break;

  case 3:

/* Line 1455 of yacc.c  */
#line 236 "parser.y"
    { ((yyval.declList) = (yyvsp[(1) - (2)].declList))->Append((yyvsp[(2) - (2)].decl)); }
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 237 "parser.y"
    { ((yyval.declList) = new List<Decl*>)->Append((yyvsp[(1) - (1)].decl)); }
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 246 "parser.y"
    { (yyval.vardecl) = new VarDecl(new Identifier((yylsp[(2) - (3)]), (yyvsp[(2) - (3)].identifier)), (yyvsp[(1) - (3)].simpletype)); }
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 249 "parser.y"
    { (yyval.simpletype) = Type::intType; }
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 250 "parser.y"
    { (yyval.simpletype) = Type::doubleType; }
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 251 "parser.y"
    { (yyval.simpletype) = Type::boolType; }
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 252 "parser.y"
    { (yyval.simpletype) = Type::stringType; }
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 257 "parser.y"
    { (yyval.namedtype) = new NamedType(new Identifier((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].identifier))); }
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 260 "parser.y"
    { (yyval.arraytype) = new ArrayType((yylsp[(1) - (2)]), (yyvsp[(1) - (2)].simpletype)); }
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 264 "parser.y"
    { (yyval.fndecl) = new FnDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), (yyvsp[(1) - (6)].simpletype), (yyvsp[(4) - (6)].vardecls)); 
                                       (yyval.fndecl)->SetFunctionBody((yyvsp[(6) - (6)].stmtblock)); }
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 267 "parser.y"
    { (yyval.fndecl) = new FnDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), Type::voidType, (yyvsp[(4) - (6)].vardecls)); 
                                       (yyval.fndecl)->SetFunctionBody((yyvsp[(6) - (6)].stmtblock)); }
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 272 "parser.y"
    { (yyval.vardecls) = new List<VarDecl*>; }
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 276 "parser.y"
    { ((yyval.vardecls) = (yyvsp[(1) - (4)].vardecls))->Append(new VarDecl(new Identifier((yylsp[(4) - (4)]), (yyvsp[(4) - (4)].identifier)), (yyvsp[(3) - (4)].simpletype))); }
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 277 "parser.y"
    { ((yyval.vardecls) = new List<VarDecl*>)->Append(new VarDecl(new Identifier((yylsp[(2) - (2)]), (yyvsp[(2) - (2)].identifier)), (yyvsp[(1) - (2)].simpletype))); }
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 281 "parser.y"
    { (yyval.classdecl) = new ClassDecl(new Identifier((yylsp[(2) - (7)]), (yyvsp[(2) - (7)].identifier)), (yyvsp[(3) - (7)].namedtype), (yyvsp[(4) - (7)].implements), (yyvsp[(6) - (7)].declList)); }
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 283 "parser.y"
    { (yyval.classdecl) = new ClassDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), (yyvsp[(3) - (6)].namedtype), (yyvsp[(4) - (6)].implements), new List<Decl*>); }
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 287 "parser.y"
    { (yyval.namedtype) = (yyvsp[(2) - (2)].namedtype); }
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 288 "parser.y"
    { (yyval.namedtype) = NULL; }
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 292 "parser.y"
    { (yyval.implements) = (yyvsp[(2) - (2)].implements); }
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 293 "parser.y"
    { (yyval.implements) = new List<NamedType*>; }
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 297 "parser.y"
    { ((yyval.implements) = (yyvsp[(1) - (3)].implements))->Append((yyvsp[(3) - (3)].namedtype)); }
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 298 "parser.y"
    { ((yyval.implements) = new List<NamedType*>)->Append((yyvsp[(1) - (1)].namedtype)); }
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 301 "parser.y"
    { ((yyval.declList) = (yyvsp[(1) - (2)].declList))->Append((yyvsp[(2) - (2)].decl)); }
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 302 "parser.y"
    { ((yyval.declList) = new List<Decl*>)->Append((yyvsp[(1) - (1)].decl));  }
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 310 "parser.y"
    { (yyval.interfacedecl) = new InterfaceDecl(new Identifier((yylsp[(2) - (5)]), (yyvsp[(2) - (5)].identifier)), (yyvsp[(4) - (5)].declList)); }
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 312 "parser.y"
    { (yyval.interfacedecl) = new InterfaceDecl(new Identifier((yylsp[(2) - (4)]), (yyvsp[(2) - (4)].identifier)), new List<Decl*>); }
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 315 "parser.y"
    { ((yyval.declList) = (yyvsp[(1) - (2)].declList))->Append((yyvsp[(2) - (2)].decl)); }
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 316 "parser.y"
    { ((yyval.declList) = new List<Decl*>)->Append((yyvsp[(1) - (1)].decl)); }
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 320 "parser.y"
    { (yyval.decl) = new FnDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), (yyvsp[(1) - (6)].simpletype), (yyvsp[(4) - (6)].vardecls)); }
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 322 "parser.y"
    { (yyval.decl) = new FnDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), Type::voidType, (yyvsp[(4) - (6)].vardecls)); }
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 325 "parser.y"
    { (yyval.stmtblock) = new StmtBlock((yyvsp[(2) - (4)].vardecls), (yyvsp[(3) - (4)].stmts)); }
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 326 "parser.y"
    { (yyval.stmtblock) = new StmtBlock((yyvsp[(2) - (3)].vardecls), new List<Stmt*>); }
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 329 "parser.y"
    { ((yyval.vardecls) = (yyvsp[(1) - (2)].vardecls))->Append((yyvsp[(2) - (2)].vardecl));    }
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 330 "parser.y"
    { (yyval.vardecls) = new List<VarDecl*>;  }
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 333 "parser.y"
    { ((yyval.stmts) = (yyvsp[(1) - (2)].stmts))->Append((yyvsp[(2) - (2)].stmt)); }
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 334 "parser.y"
    { ((yyval.stmts) = new List<Stmt*>)->Append((yyvsp[(1) - (1)].stmt));  }
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 350 "parser.y"
    { (yyval.ifstmt) = new IfStmt((yyvsp[(3) - (5)].expr), (yyvsp[(5) - (5)].stmt), NULL); }
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 352 "parser.y"
    { (yyval.ifstmt) = new IfStmt((yyvsp[(3) - (7)].expr), (yyvsp[(5) - (7)].stmt), (yyvsp[(7) - (7)].stmt)); }
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 357 "parser.y"
    { (yyval.whilestmt) = new WhileStmt((yyvsp[(3) - (5)].expr), (yyvsp[(5) - (5)].stmt)); }
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 361 "parser.y"
    { (yyval.forstmt) = new ForStmt((yyvsp[(3) - (9)].expr), (yyvsp[(5) - (9)].expr), (yyvsp[(7) - (9)].expr), (yyvsp[(9) - (9)].stmt)); }
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 364 "parser.y"
    { (yyval.rtnstmt) = new ReturnStmt((yylsp[(2) - (3)]), (yyvsp[(2) - (3)].expr)); }
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 367 "parser.y"
    { (yyval.brkstmt) = new BreakStmt((yylsp[(1) - (2)])); }
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 371 "parser.y"
    { (yyval.switchstmt) = new SwitchStmt((yyvsp[(3) - (8)].expr), (yyvsp[(6) - (8)].casestmts), (yyvsp[(7) - (8)].defaultstmt)); }
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 374 "parser.y"
    { ((yyval.casestmts) = (yyvsp[(1) - (2)].casestmts))->Append((yyvsp[(2) - (2)].casestmt)); }
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 375 "parser.y"
    { ((yyval.casestmts) = new List<CaseStmt*>)->Append((yyvsp[(1) - (1)].casestmt)); }
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 379 "parser.y"
    { (yyval.casestmt) = new CaseStmt((yyvsp[(2) - (4)].intconst), (yyvsp[(4) - (4)].stmts)); }
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 380 "parser.y"
    { (yyval.casestmt) = new CaseStmt((yyvsp[(2) - (3)].intconst), new List<Stmt*>); }
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 383 "parser.y"
    { (yyval.defaultstmt) = new DefaultStmt((yyvsp[(3) - (3)].stmts)); }
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 384 "parser.y"
    { (yyval.defaultstmt) = NULL; }
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 388 "parser.y"
    { (yyval.pntstmt) = new PrintStmt((yyvsp[(3) - (5)].exprs)); }
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 394 "parser.y"
    { (yyval.expr) = new This((yylsp[(1) - (1)])); }
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 396 "parser.y"
    { (yyval.expr) = (yyvsp[(2) - (3)].expr); }
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 402 "parser.y"
    { (yyval.expr) = new ReadIntegerExpr(Join((yylsp[(1) - (3)]), (yylsp[(3) - (3)]))); }
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 403 "parser.y"
    { (yyval.expr) = new ReadLineExpr(Join((yylsp[(1) - (3)]), (yylsp[(3) - (3)]))); }
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 404 "parser.y"
    { (yyval.expr) = new NewExpr(Join((yylsp[(1) - (2)]), (yylsp[(2) - (2)])), new NamedType(new Identifier((yylsp[(2) - (2)]), (yyvsp[(2) - (2)].identifier)))); }
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 406 "parser.y"
    { (yyval.expr) = new NewArrayExpr(Join((yylsp[(1) - (6)]), (yylsp[(6) - (6)])), (yyvsp[(3) - (6)].expr), (yyvsp[(5) - (6)].simpletype)); }
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 410 "parser.y"
    { (yyval.assignexpr) = new AssignExpr((yyvsp[(1) - (3)].lvalue), new Operator((yylsp[(2) - (3)]), "="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 413 "parser.y"
    { (yyval.arithmeticexpr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "+"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 414 "parser.y"
    { (yyval.arithmeticexpr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "-"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 415 "parser.y"
    { (yyval.arithmeticexpr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "*"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 416 "parser.y"
    { (yyval.arithmeticexpr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "/"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 417 "parser.y"
    { (yyval.arithmeticexpr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "%"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 419 "parser.y"
    { (yyval.arithmeticexpr) = new ArithmeticExpr(new Operator((yylsp[(1) - (2)]), "-"), (yyvsp[(2) - (2)].expr)); }
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 422 "parser.y"
    { (yyval.postfixexpr) = new PostfixExpr(Join((yylsp[(1) - (2)]), (yylsp[(2) - (2)])), (yyvsp[(1) - (2)].lvalue), new Operator((yylsp[(2) - (2)]), "++")); }
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 423 "parser.y"
    { (yyval.postfixexpr) = new PostfixExpr(Join((yylsp[(1) - (2)]), (yylsp[(2) - (2)])), (yyvsp[(1) - (2)].lvalue), new Operator((yylsp[(2) - (2)]), "--")); }
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 427 "parser.y"
    { (yyval.equalityexpr) = new EqualityExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "=="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 429 "parser.y"
    { (yyval.equalityexpr) = new EqualityExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "!="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 433 "parser.y"
    { (yyval.relationalexpr) = new RelationalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "<"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 435 "parser.y"
    { (yyval.relationalexpr) = new RelationalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), ">"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 437 "parser.y"
    { (yyval.relationalexpr) = new RelationalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "<="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 439 "parser.y"
    { (yyval.relationalexpr) = new RelationalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), ">="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 443 "parser.y"
    { (yyval.logicalexpr) = new LogicalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "&&"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 445 "parser.y"
    { (yyval.logicalexpr) = new LogicalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "||"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 446 "parser.y"
    { (yyval.logicalexpr) = new LogicalExpr(new Operator((yylsp[(1) - (2)]), "!"), (yyvsp[(2) - (2)].expr)); }
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 450 "parser.y"
    { ((yyval.exprs) = (yyvsp[(1) - (3)].exprs))->Append((yyvsp[(3) - (3)].expr)); }
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 451 "parser.y"
    { ((yyval.exprs) = new List<Expr*>)->Append((yyvsp[(1) - (1)].expr)); }
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 455 "parser.y"
    { (yyval.expr) = new EmptyExpr(); }
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 463 "parser.y"
    { (yyval.fieldaccess) = new FieldAccess(NULL, new Identifier((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].identifier))); }
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 465 "parser.y"
    { (yyval.fieldaccess) = new FieldAccess((yyvsp[(1) - (3)].expr), new Identifier((yylsp[(3) - (3)]), (yyvsp[(3) - (3)].identifier))); }
    break;

  case 112:

/* Line 1455 of yacc.c  */
#line 469 "parser.y"
    { (yyval.call) = new Call(Join((yylsp[(1) - (4)]), (yylsp[(4) - (4)])), NULL, new Identifier((yylsp[(1) - (4)]), (yyvsp[(1) - (4)].identifier)), (yyvsp[(3) - (4)].exprs)); }
    break;

  case 113:

/* Line 1455 of yacc.c  */
#line 471 "parser.y"
    { (yyval.call) = new Call(Join((yylsp[(1) - (6)]), (yylsp[(6) - (6)])), (yyvsp[(1) - (6)].expr), new Identifier((yylsp[(3) - (6)]), (yyvsp[(3) - (6)].identifier)), (yyvsp[(5) - (6)].exprs)); }
    break;

  case 114:

/* Line 1455 of yacc.c  */
#line 474 "parser.y"
    { (yyval.arrayaccess) = new ArrayAccess(Join((yylsp[(1) - (4)]), (yylsp[(4) - (4)])), (yyvsp[(1) - (4)].expr), (yyvsp[(3) - (4)].expr)); }
    break;

  case 116:

/* Line 1455 of yacc.c  */
#line 478 "parser.y"
    { (yyval.exprs) = new List<Expr*>; }
    break;

  case 122:

/* Line 1455 of yacc.c  */
#line 488 "parser.y"
    { (yyval.intconst) = new IntConstant((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].integerConstant)); }
    break;

  case 123:

/* Line 1455 of yacc.c  */
#line 491 "parser.y"
    { (yyval.doubleconst) = new DoubleConstant((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].doubleConstant)); }
    break;

  case 124:

/* Line 1455 of yacc.c  */
#line 494 "parser.y"
    { (yyval.boolconst) = new BoolConstant((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].boolConstant)); }
    break;

  case 125:

/* Line 1455 of yacc.c  */
#line 497 "parser.y"
    { (yyval.stringconst) = new StringConstant((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].stringConstant)); }
    break;

  case 126:

/* Line 1455 of yacc.c  */
#line 500 "parser.y"
    { (yyval.nullconst) = new NullConstant((yylsp[(1) - (1)])); }
    break;



/* Line 1455 of yacc.c  */
#line 2471 "y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }

  yyerror_range[0] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval, &yylloc);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  yyerror_range[0] = yylsp[1-yylen];
  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      yyerror_range[0] = *yylsp;
      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;

  yyerror_range[1] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, (yyerror_range - 1), 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval, &yylloc);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 502 "parser.y"


/* The closing %% above marks the end of the Rules section and the beginning
 * of the User Subroutines section. All text from here to the end of the
 * file is copied verbatim to the end of the generated y.tab.c file.
 * This section is where you put definitions of helper functions.
 */

/* Function: InitParser
 * --------------------
 * This function will be called before any calls to yyparse().  It is designed
 * to give you an opportunity to do anything that must be done to initialize
 * the parser (set global variables, configure starting state, etc.). One
 * thing it already does for you is assign the value of the global variable
 * yydebug that controls whether yacc prints debugging information about
 * parser actions (shift/reduce) and contents of state stack during parser.
 * If set to false, no information is printed. Setting it to true will give
 * you a running trail that might be helpful when debugging your parser.
 * Please be sure the variable is set to false when submitting your final
 * version.
 */
void InitParser()
{
   PrintDebug("parser", "Initializing parser");
   yydebug = false;
}

