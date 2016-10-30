
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
#line 11 "parser.y"


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
     T_And = 269,
     T_Or = 270,
     T_Null = 271,
     T_Extends = 272,
     T_This = 273,
     T_Interface = 274,
     T_Implements = 275,
     T_While = 276,
     T_For = 277,
     T_If = 278,
     T_Else = 279,
     T_Return = 280,
     T_Break = 281,
     T_New = 282,
     T_NewArray = 283,
     T_Print = 284,
     T_ReadInteger = 285,
     T_ReadLine = 286,
     T_Pincrement = 287,
     T_Pdecrement = 288,
     T_Identifier = 289,
     T_StringConstant = 290,
     T_IntConstant = 291,
     T_DoubleConstant = 292,
     T_BoolConstant = 293,
     UnaryMinus = 294
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
#define T_And 269
#define T_Or 270
#define T_Null 271
#define T_Extends 272
#define T_This 273
#define T_Interface 274
#define T_Implements 275
#define T_While 276
#define T_For 277
#define T_If 278
#define T_Else 279
#define T_Return 280
#define T_Break 281
#define T_New 282
#define T_NewArray 283
#define T_Print 284
#define T_ReadInteger 285
#define T_ReadLine 286
#define T_Pincrement 287
#define T_Pdecrement 288
#define T_Identifier 289
#define T_StringConstant 290
#define T_IntConstant 291
#define T_DoubleConstant 292
#define T_BoolConstant 293
#define UnaryMinus 294




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 41 "parser.y"

    int integerConstant;
    bool boolConstant;
    char *stringConstant;
    double doubleConstant;
    char identifier[MaxIdentLen+1]; // +1 for terminating null
    Decl *decl;
    List<Decl*> *declList;
    FnDecl *functionDecl;
    Type *type;
    VarDecl *variable;
    VarDecl *varDecl;
    List<VarDecl*> *formals;
    List<VarDecl*> *varDeclList;
    Stmt *stmt;
    List<Stmt*> *stmtList;
    StmtBlock *stmtBlock;
    Expr *expr;
    List<Expr*> *exprList;
    IfStmt *ifStmt;
    WhileStmt *whileStmt;
    ForStmt *forStmt;
    BreakStmt *breakStmt;
    ReturnStmt *returnStmt;
    PrintStmt *printStmt;
    LValue *lValue;
    Expr *constant;
    List<NamedType*> *idList;
    List<Decl*> *fieldList;
    List<Decl*> *fieldStar;
    ClassDecl *classDecl;
    Decl *field;
    List<Expr*> *actuals;
    Expr *call;
    FnDecl *prototype;
    List<Decl*> *prototypePlus;
    InterfaceDecl *interfaceDecl;



/* Line 214 of yacc.c  */
#line 245 "y.tab.c"
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
#line 270 "y.tab.c"

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
#define YYFINAL  21
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   828

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  58
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  33
/* YYNRULES -- Number of rules.  */
#define YYNRULES  106
/* YYNRULES -- Number of states.  */
#define YYNSTATES  219

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   294

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    46,     2,     2,     2,    45,     2,     2,
      50,    51,    43,    41,    53,    42,    55,    44,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    52,
      39,    54,    40,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    56,     2,    57,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    48,     2,    49,     2,     2,     2,     2,
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
      35,    36,    37,    38,    47
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     8,    10,    12,    14,    16,    18,
      24,    29,    32,    34,    41,    48,    52,    58,    64,    72,
      76,    78,    81,    83,    86,    90,    92,    94,    97,   100,
     102,   105,   112,   119,   121,   123,   125,   127,   129,   132,
     136,   138,   139,   144,   148,   152,   155,   158,   160,   162,
     164,   166,   168,   170,   172,   174,   178,   180,   182,   184,
     186,   190,   194,   198,   202,   206,   210,   213,   217,   221,
     225,   229,   233,   237,   241,   245,   248,   252,   256,   261,
     268,   272,   274,   276,   280,   285,   287,   289,   291,   293,
     295,   300,   307,   309,   310,   316,   324,   330,   340,   349,
     358,   366,   369,   372,   376,   382,   385
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      59,     0,    -1,    60,    -1,    60,    61,    -1,    61,    -1,
      73,    -1,    70,    -1,    65,    -1,    62,    -1,    19,    34,
      48,    63,    49,    -1,    19,    34,    48,    49,    -1,    63,
      64,    -1,    64,    -1,    74,    34,    50,    75,    51,    52,
      -1,     3,    34,    50,    75,    51,    52,    -1,     8,    34,
      68,    -1,     8,    34,    17,    34,    68,    -1,     8,    34,
      20,    66,    68,    -1,     8,    34,    17,    34,    20,    66,
      68,    -1,    66,    53,    34,    -1,    34,    -1,    67,    69,
      -1,    69,    -1,    48,    49,    -1,    48,    67,    49,    -1,
      70,    -1,    73,    -1,    72,    52,    -1,    71,    70,    -1,
      70,    -1,    74,    34,    -1,    74,    34,    50,    75,    51,
      76,    -1,     3,    34,    50,    75,    51,    76,    -1,     5,
      -1,     6,    -1,     4,    -1,     7,    -1,    34,    -1,    74,
      13,    -1,    75,    53,    72,    -1,    72,    -1,    -1,    48,
      71,    90,    49,    -1,    48,    71,    49,    -1,    48,    90,
      49,    -1,    48,    49,    -1,    78,    52,    -1,    52,    -1,
      84,    -1,    85,    -1,    86,    -1,    87,    -1,    88,    -1,
      89,    -1,    76,    -1,    80,    54,    78,    -1,    81,    -1,
      80,    -1,    18,    -1,    82,    -1,    50,    78,    51,    -1,
      78,    41,    78,    -1,    78,    42,    78,    -1,    78,    43,
      78,    -1,    78,    44,    78,    -1,    78,    45,    78,    -1,
      42,    78,    -1,    78,    39,    78,    -1,    78,    40,    78,
      -1,    78,     9,    78,    -1,    78,    10,    78,    -1,    78,
      11,    78,    -1,    78,    12,    78,    -1,    78,    14,    78,
      -1,    78,    15,    78,    -1,    46,    78,    -1,    30,    50,
      51,    -1,    31,    50,    51,    -1,    27,    50,    34,    51,
      -1,    28,    50,    78,    53,    74,    51,    -1,    79,    53,
      78,    -1,    78,    -1,    34,    -1,    78,    55,    34,    -1,
      78,    56,    78,    57,    -1,    36,    -1,    37,    -1,    38,
      -1,    35,    -1,    16,    -1,    34,    50,    83,    51,    -1,
      78,    55,    34,    50,    83,    51,    -1,    79,    -1,    -1,
      23,    50,    78,    51,    77,    -1,    23,    50,    78,    51,
      77,    24,    77,    -1,    21,    50,    78,    51,    77,    -1,
      22,    50,    78,    52,    78,    52,    78,    51,    77,    -1,
      22,    50,    52,    78,    52,    78,    51,    77,    -1,    22,
      50,    78,    52,    78,    52,    51,    77,    -1,    22,    50,
      52,    78,    52,    51,    77,    -1,    26,    52,    -1,    25,
      52,    -1,    25,    78,    52,    -1,    29,    50,    79,    51,
      52,    -1,    90,    77,    -1,    77,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   158,   158,   170,   171,   174,   175,   176,   177,   180,
     182,   186,   187,   190,   191,   195,   197,   199,   201,   204,
     205,   208,   209,   212,   213,   216,   217,   220,   222,   223,
     226,   229,   231,   235,   236,   237,   238,   239,   240,   243,
     244,   245,   248,   249,   250,   251,   254,   255,   256,   257,
     258,   259,   260,   261,   262,   265,   266,   267,   268,   269,
     270,   271,   272,   273,   274,   275,   276,   278,   279,   280,
     281,   282,   283,   284,   285,   286,   287,   288,   289,   290,
     293,   294,   297,   298,   299,   302,   303,   304,   305,   306,
     309,   310,   313,   314,   317,   318,   321,   324,   325,   326,
     327,   330,   333,   334,   337,   340,   341
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "T_Void", "T_Bool", "T_Int", "T_Double",
  "T_String", "T_Class", "T_LessEqual", "T_GreaterEqual", "T_Equal",
  "T_NotEqual", "T_Dims", "T_And", "T_Or", "T_Null", "T_Extends", "T_This",
  "T_Interface", "T_Implements", "T_While", "T_For", "T_If", "T_Else",
  "T_Return", "T_Break", "T_New", "T_NewArray", "T_Print", "T_ReadInteger",
  "T_ReadLine", "T_Pincrement", "T_Pdecrement", "T_Identifier",
  "T_StringConstant", "T_IntConstant", "T_DoubleConstant",
  "T_BoolConstant", "'<'", "'>'", "'+'", "'-'", "'*'", "'/'", "'%'", "'!'",
  "UnaryMinus", "'{'", "'}'", "'('", "')'", "';'", "','", "'='", "'.'",
  "'['", "']'", "$accept", "Program", "DeclList", "Decl", "InterfaceDecl",
  "PrototypePlus", "Prototype", "ClassDecl", "IdList", "FieldList",
  "FieldStar", "Field", "VarDecl", "VarDeclList", "Variable",
  "FunctionDecl", "Type", "Formals", "StmtBlock", "Stmt", "Expr",
  "ExprList", "LValue", "Constant", "Call", "Actuals", "IfStmt",
  "WhileStmt", "ForStmt", "BreakStmt", "ReturnStmt", "PrintStmt",
  "StmtList", 0
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
     285,   286,   287,   288,   289,   290,   291,   292,   293,    60,
      62,    43,    45,    42,    47,    37,    33,   294,   123,   125,
      40,    41,    59,    44,    61,    46,    91,    93
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    58,    59,    60,    60,    61,    61,    61,    61,    62,
      62,    63,    63,    64,    64,    65,    65,    65,    65,    66,
      66,    67,    67,    68,    68,    69,    69,    70,    71,    71,
      72,    73,    73,    74,    74,    74,    74,    74,    74,    75,
      75,    75,    76,    76,    76,    76,    77,    77,    77,    77,
      77,    77,    77,    77,    77,    78,    78,    78,    78,    78,
      78,    78,    78,    78,    78,    78,    78,    78,    78,    78,
      78,    78,    78,    78,    78,    78,    78,    78,    78,    78,
      79,    79,    80,    80,    80,    81,    81,    81,    81,    81,
      82,    82,    83,    83,    84,    84,    85,    86,    86,    86,
      86,    87,    88,    88,    89,    90,    90
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     1,     1,     1,     5,
       4,     2,     1,     6,     6,     3,     5,     5,     7,     3,
       1,     2,     1,     2,     3,     1,     1,     2,     2,     1,
       2,     6,     6,     1,     1,     1,     1,     1,     2,     3,
       1,     0,     4,     3,     3,     2,     2,     1,     1,     1,
       1,     1,     1,     1,     1,     3,     1,     1,     1,     1,
       3,     3,     3,     3,     3,     3,     2,     3,     3,     3,
       3,     3,     3,     3,     3,     2,     3,     3,     4,     6,
       3,     1,     1,     3,     4,     1,     1,     1,     1,     1,
       4,     6,     1,     0,     5,     7,     5,     9,     8,     8,
       7,     2,     2,     3,     5,     2,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,    35,    33,    34,    36,     0,     0,    37,     0,
       2,     4,     8,     7,     6,     0,     5,     0,     0,     0,
       0,     1,     3,    27,    38,    30,    41,     0,     0,     0,
      15,     0,    41,    40,     0,     0,     0,    20,     0,    23,
       0,    22,    25,    26,     0,    10,     0,    12,     0,     0,
      30,     0,     0,     0,    16,     0,    17,    24,    21,     0,
       9,    11,     0,     0,     0,    32,    39,     0,    19,    41,
      41,    31,    89,    58,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    82,    88,    85,    86,    87,     0,
       0,    45,     0,    47,    29,     0,    54,   106,     0,    57,
      56,    59,    48,    49,    50,    51,    52,    53,     0,    18,
       0,     0,     0,     0,     0,    82,   102,     0,   101,     0,
       0,     0,     0,     0,    93,    66,    75,     0,    43,    28,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    46,     0,     0,     0,    44,   105,
       0,     0,     0,     0,     0,     0,   103,     0,     0,    81,
       0,    76,    77,    92,     0,    60,    42,    69,    70,    71,
      72,    73,    74,    67,    68,    61,    62,    63,    64,    65,
      83,     0,    55,    14,    13,     0,     0,     0,     0,    78,
       0,     0,     0,    90,    93,    84,    96,     0,     0,    94,
       0,   104,    80,     0,     0,     0,     0,     0,    79,    91,
     100,     0,     0,     0,    95,    98,    99,     0,    97
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     9,    10,    11,    12,    46,    47,    13,    38,    40,
      30,    41,    14,    95,    15,    16,    34,    35,    96,    97,
      98,   163,    99,   100,   101,   164,   102,   103,   104,   105,
     106,   107,   108
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -106
static const yytype_int16 yypact[] =
{
     175,    34,  -106,  -106,  -106,  -106,    48,    51,  -106,    21,
     175,  -106,  -106,  -106,  -106,   -22,  -106,    -2,   -16,   -13,
      43,  -106,  -106,  -106,  -106,    42,    69,    61,    67,    47,
    -106,    83,    69,  -106,    -1,   -29,    49,  -106,    45,  -106,
     238,  -106,  -106,  -106,    70,  -106,   560,  -106,    71,   -25,
    -106,    66,    69,    67,  -106,    85,  -106,  -106,  -106,    59,
    -106,  -106,    77,    66,   118,  -106,  -106,    45,  -106,    69,
      69,  -106,  -106,  -106,    79,    81,    92,   674,    98,   101,
     107,   108,   109,   111,   -11,  -106,  -106,  -106,  -106,   778,
     778,  -106,   778,  -106,  -106,   170,  -106,  -106,   221,   115,
    -106,  -106,  -106,  -106,  -106,  -106,  -106,  -106,   577,  -106,
      57,    62,   778,   701,   778,   112,  -106,   269,  -106,    99,
     778,   778,    84,   114,   778,    23,    23,   287,  -106,  -106,
     612,   778,   778,   778,   778,   778,   778,   778,   778,   778,
     778,   778,   778,   778,  -106,   129,   778,   778,  -106,  -106,
     119,   120,   308,   778,   346,   364,  -106,   122,   385,   499,
      75,  -106,  -106,   131,   134,  -106,  -106,   536,   536,   536,
     536,   517,   517,   536,   536,   194,   194,    23,    23,    23,
     137,   214,   499,  -106,  -106,   647,   422,   778,   647,  -106,
      69,   150,   778,  -106,   778,  -106,  -106,   728,   440,   165,
      -4,  -106,   499,   152,   647,   461,   753,   647,  -106,  -106,
    -106,   647,   647,   479,  -106,  -106,  -106,   647,  -106
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -106,  -106,  -106,   200,  -106,  -106,   167,  -106,   158,  -106,
     -18,   174,   -23,  -106,    68,   -21,     0,   -27,   -36,  -105,
     -76,    94,  -106,  -106,  -106,    27,  -106,  -106,  -106,  -106,
    -106,  -106,   132
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -38
static const yytype_int16 yytable[] =
{
      17,   117,   -37,   149,    27,    49,    42,    28,    43,    24,
      17,    24,    24,   125,   126,    65,   127,    42,    54,    43,
      56,    21,    51,   -37,    52,   149,    63,    71,    52,    17,
      23,    48,    25,    50,    26,    29,   152,   154,   155,   124,
      17,    94,   110,   111,   158,   159,    48,   208,   159,   109,
       1,     2,     3,     4,     5,   167,   168,   169,   170,   171,
     172,   173,   174,   175,   176,   177,   178,   179,    18,    53,
     181,   182,   129,     2,     3,     4,     5,   186,   145,   146,
     196,     8,    19,   199,    24,    20,    44,     2,     3,     4,
       5,    31,    32,    29,    33,    36,    39,    29,    55,   210,
      33,    37,   214,     8,    59,    62,   215,   216,   150,    69,
      52,   198,   218,   151,    64,    52,   202,     8,   159,    68,
      66,   205,     2,     3,     4,     5,   191,    70,   192,   112,
     213,   113,    45,   157,    72,   161,    73,    33,    33,    74,
      75,    76,   114,    77,    78,    79,    80,    81,    82,    83,
     118,   119,    84,    85,    86,    87,    88,   120,   121,   122,
      89,   123,   124,   180,    90,   162,    64,    91,    92,   147,
      93,   183,   184,   189,     2,     3,     4,     5,     1,     2,
       3,     4,     5,     6,   192,   193,    72,   194,    73,   207,
     200,    74,    75,    76,     7,    77,    78,    79,    80,    81,
      82,    83,   201,   209,    84,    85,    86,    87,    88,     8,
      22,    67,    89,    61,    58,   160,    90,     0,    64,   128,
      92,   203,    93,   131,   132,   133,   134,   130,   135,   136,
     131,   132,   133,   134,     0,   135,   136,   141,   142,   143,
       0,     1,     2,     3,     4,     5,     0,     0,     0,   145,
     146,     0,     0,   137,   138,   139,   140,   141,   142,   143,
     137,   138,   139,   140,   141,   142,   143,     0,     0,   145,
     146,   195,     8,   144,     0,     0,   145,   146,   131,   132,
     133,   134,     0,   135,   136,     0,     0,    57,     0,     0,
       0,     0,     0,     0,     0,     0,   131,   132,   133,   134,
       0,   135,   136,     0,     0,     0,     0,     0,   137,   138,
     139,   140,   141,   142,   143,     0,     0,   131,   132,   133,
     134,   156,   135,   136,   145,   146,   137,   138,   139,   140,
     141,   142,   143,     0,     0,     0,     0,     0,   165,     0,
       0,     0,   145,   146,     0,     0,     0,   137,   138,   139,
     140,   141,   142,   143,     0,   131,   132,   133,   134,   185,
     135,   136,     0,   145,   146,     0,     0,     0,     0,     0,
       0,     0,     0,   131,   132,   133,   134,     0,   135,   136,
       0,     0,     0,     0,     0,   137,   138,   139,   140,   141,
     142,   143,     0,     0,   131,   132,   133,   134,   187,   135,
     136,   145,   146,   137,   138,   139,   140,   141,   142,   143,
       0,     0,     0,     0,     0,   188,     0,     0,     0,   145,
     146,     0,     0,     0,   137,   138,   139,   140,   141,   142,
     143,   131,   132,   133,   134,     0,   135,   136,   190,     0,
     145,   146,     0,     0,     0,     0,     0,     0,     0,   131,
     132,   133,   134,     0,   135,   136,     0,     0,     0,     0,
       0,   137,   138,   139,   140,   141,   142,   143,     0,     0,
     131,   132,   133,   134,   197,   135,   136,   145,   146,   137,
     138,   139,   140,   141,   142,   143,     0,     0,   131,   132,
     133,   134,   206,   135,   136,   145,   146,     0,     0,     0,
     137,   138,   139,   140,   141,   142,   143,     0,   131,   132,
     133,   134,   211,   135,   136,     0,   145,   146,   137,   138,
     139,   140,   141,   142,   143,     0,   131,   132,   133,   134,
     217,   -38,   -38,     0,   145,   146,     0,     0,   137,   138,
     139,   140,   141,   142,   143,   -38,   -38,   -38,   -38,     0,
       0,     0,     0,     0,   145,   146,   137,   138,   139,   140,
     141,   142,   143,    44,     2,     3,     4,     5,     0,     0,
       0,     0,   145,   146,     0,   -38,   -38,   139,   140,   141,
     142,   143,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   145,   146,    72,     8,    73,     0,     0,    74,    75,
      76,     0,    77,    78,    79,    80,    81,    82,    83,    60,
       0,   115,    85,    86,    87,    88,     0,     0,     0,    89,
       0,     0,     0,    90,     0,    64,   148,    92,    72,    93,
      73,     0,     0,    74,    75,    76,     0,    77,    78,    79,
      80,    81,    82,    83,     0,     0,   115,    85,    86,    87,
      88,     0,     0,     0,    89,     0,     0,     0,    90,     0,
      64,   166,    92,    72,    93,    73,     0,     0,    74,    75,
      76,     0,    77,    78,    79,    80,    81,    82,    83,     0,
       0,   115,    85,    86,    87,    88,     0,     0,     0,    89,
      72,     0,    73,    90,     0,    64,     0,    92,     0,    93,
       0,    79,    80,     0,    82,    83,     0,     0,   115,    85,
      86,    87,    88,     0,     0,     0,    89,    72,     0,    73,
      90,     0,     0,     0,    92,     0,   116,     0,    79,    80,
       0,    82,    83,     0,     0,   115,    85,    86,    87,    88,
       0,     0,     0,    89,    72,     0,    73,    90,     0,     0,
       0,    92,     0,   153,     0,    79,    80,     0,    82,    83,
       0,     0,   115,    85,    86,    87,    88,     0,     0,    72,
      89,    73,     0,     0,    90,     0,     0,     0,    92,   204,
      79,    80,     0,    82,    83,     0,     0,   115,    85,    86,
      87,    88,     0,     0,    72,    89,    73,     0,     0,    90,
       0,     0,     0,    92,   212,    79,    80,     0,    82,    83,
       0,     0,   115,    85,    86,    87,    88,     0,     0,     0,
      89,     0,     0,     0,    90,     0,     0,     0,    92
};

static const yytype_int16 yycheck[] =
{
       0,    77,    13,   108,    17,    32,    29,    20,    29,    13,
      10,    13,    13,    89,    90,    51,    92,    40,    36,    40,
      38,     0,    51,    34,    53,   130,    51,    63,    53,    29,
      52,    31,    34,    34,    50,    48,   112,   113,   114,    50,
      40,    64,    69,    70,   120,   121,    46,    51,   124,    67,
       3,     4,     5,     6,     7,   131,   132,   133,   134,   135,
     136,   137,   138,   139,   140,   141,   142,   143,    34,    20,
     146,   147,    95,     4,     5,     6,     7,   153,    55,    56,
     185,    34,    34,   188,    13,    34,     3,     4,     5,     6,
       7,    48,    50,    48,    26,    34,    49,    48,    53,   204,
      32,    34,   207,    34,    34,    34,   211,   212,    51,    50,
      53,   187,   217,    51,    48,    53,   192,    34,   194,    34,
      52,   197,     4,     5,     6,     7,    51,    50,    53,    50,
     206,    50,    49,    34,    16,    51,    18,    69,    70,    21,
      22,    23,    50,    25,    26,    27,    28,    29,    30,    31,
      52,    50,    34,    35,    36,    37,    38,    50,    50,    50,
      42,    50,    50,    34,    46,    51,    48,    49,    50,    54,
      52,    52,    52,    51,     4,     5,     6,     7,     3,     4,
       5,     6,     7,     8,    53,    51,    16,    50,    18,    24,
     190,    21,    22,    23,    19,    25,    26,    27,    28,    29,
      30,    31,    52,    51,    34,    35,    36,    37,    38,    34,
      10,    53,    42,    46,    40,   121,    46,    -1,    48,    49,
      50,   194,    52,     9,    10,    11,    12,    95,    14,    15,
       9,    10,    11,    12,    -1,    14,    15,    43,    44,    45,
      -1,     3,     4,     5,     6,     7,    -1,    -1,    -1,    55,
      56,    -1,    -1,    39,    40,    41,    42,    43,    44,    45,
      39,    40,    41,    42,    43,    44,    45,    -1,    -1,    55,
      56,    57,    34,    52,    -1,    -1,    55,    56,     9,    10,
      11,    12,    -1,    14,    15,    -1,    -1,    49,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,     9,    10,    11,    12,
      -1,    14,    15,    -1,    -1,    -1,    -1,    -1,    39,    40,
      41,    42,    43,    44,    45,    -1,    -1,     9,    10,    11,
      12,    52,    14,    15,    55,    56,    39,    40,    41,    42,
      43,    44,    45,    -1,    -1,    -1,    -1,    -1,    51,    -1,
      -1,    -1,    55,    56,    -1,    -1,    -1,    39,    40,    41,
      42,    43,    44,    45,    -1,     9,    10,    11,    12,    51,
      14,    15,    -1,    55,    56,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,     9,    10,    11,    12,    -1,    14,    15,
      -1,    -1,    -1,    -1,    -1,    39,    40,    41,    42,    43,
      44,    45,    -1,    -1,     9,    10,    11,    12,    52,    14,
      15,    55,    56,    39,    40,    41,    42,    43,    44,    45,
      -1,    -1,    -1,    -1,    -1,    51,    -1,    -1,    -1,    55,
      56,    -1,    -1,    -1,    39,    40,    41,    42,    43,    44,
      45,     9,    10,    11,    12,    -1,    14,    15,    53,    -1,
      55,    56,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     9,
      10,    11,    12,    -1,    14,    15,    -1,    -1,    -1,    -1,
      -1,    39,    40,    41,    42,    43,    44,    45,    -1,    -1,
       9,    10,    11,    12,    52,    14,    15,    55,    56,    39,
      40,    41,    42,    43,    44,    45,    -1,    -1,     9,    10,
      11,    12,    52,    14,    15,    55,    56,    -1,    -1,    -1,
      39,    40,    41,    42,    43,    44,    45,    -1,     9,    10,
      11,    12,    51,    14,    15,    -1,    55,    56,    39,    40,
      41,    42,    43,    44,    45,    -1,     9,    10,    11,    12,
      51,    14,    15,    -1,    55,    56,    -1,    -1,    39,    40,
      41,    42,    43,    44,    45,     9,    10,    11,    12,    -1,
      -1,    -1,    -1,    -1,    55,    56,    39,    40,    41,    42,
      43,    44,    45,     3,     4,     5,     6,     7,    -1,    -1,
      -1,    -1,    55,    56,    -1,    39,    40,    41,    42,    43,
      44,    45,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    55,    56,    16,    34,    18,    -1,    -1,    21,    22,
      23,    -1,    25,    26,    27,    28,    29,    30,    31,    49,
      -1,    34,    35,    36,    37,    38,    -1,    -1,    -1,    42,
      -1,    -1,    -1,    46,    -1,    48,    49,    50,    16,    52,
      18,    -1,    -1,    21,    22,    23,    -1,    25,    26,    27,
      28,    29,    30,    31,    -1,    -1,    34,    35,    36,    37,
      38,    -1,    -1,    -1,    42,    -1,    -1,    -1,    46,    -1,
      48,    49,    50,    16,    52,    18,    -1,    -1,    21,    22,
      23,    -1,    25,    26,    27,    28,    29,    30,    31,    -1,
      -1,    34,    35,    36,    37,    38,    -1,    -1,    -1,    42,
      16,    -1,    18,    46,    -1,    48,    -1,    50,    -1,    52,
      -1,    27,    28,    -1,    30,    31,    -1,    -1,    34,    35,
      36,    37,    38,    -1,    -1,    -1,    42,    16,    -1,    18,
      46,    -1,    -1,    -1,    50,    -1,    52,    -1,    27,    28,
      -1,    30,    31,    -1,    -1,    34,    35,    36,    37,    38,
      -1,    -1,    -1,    42,    16,    -1,    18,    46,    -1,    -1,
      -1,    50,    -1,    52,    -1,    27,    28,    -1,    30,    31,
      -1,    -1,    34,    35,    36,    37,    38,    -1,    -1,    16,
      42,    18,    -1,    -1,    46,    -1,    -1,    -1,    50,    51,
      27,    28,    -1,    30,    31,    -1,    -1,    34,    35,    36,
      37,    38,    -1,    -1,    16,    42,    18,    -1,    -1,    46,
      -1,    -1,    -1,    50,    51,    27,    28,    -1,    30,    31,
      -1,    -1,    34,    35,    36,    37,    38,    -1,    -1,    -1,
      42,    -1,    -1,    -1,    46,    -1,    -1,    -1,    50
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,    19,    34,    59,
      60,    61,    62,    65,    70,    72,    73,    74,    34,    34,
      34,     0,    61,    52,    13,    34,    50,    17,    20,    48,
      68,    48,    50,    72,    74,    75,    34,    34,    66,    49,
      67,    69,    70,    73,     3,    49,    63,    64,    74,    75,
      34,    51,    53,    20,    68,    53,    68,    49,    69,    34,
      49,    64,    34,    51,    48,    76,    72,    66,    34,    50,
      50,    76,    16,    18,    21,    22,    23,    25,    26,    27,
      28,    29,    30,    31,    34,    35,    36,    37,    38,    42,
      46,    49,    50,    52,    70,    71,    76,    77,    78,    80,
      81,    82,    84,    85,    86,    87,    88,    89,    90,    68,
      75,    75,    50,    50,    50,    34,    52,    78,    52,    50,
      50,    50,    50,    50,    50,    78,    78,    78,    49,    70,
      90,     9,    10,    11,    12,    14,    15,    39,    40,    41,
      42,    43,    44,    45,    52,    55,    56,    54,    49,    77,
      51,    51,    78,    52,    78,    78,    52,    34,    78,    78,
      79,    51,    51,    79,    83,    51,    49,    78,    78,    78,
      78,    78,    78,    78,    78,    78,    78,    78,    78,    78,
      34,    78,    78,    52,    52,    51,    78,    52,    51,    51,
      53,    51,    53,    51,    50,    57,    77,    52,    78,    77,
      74,    52,    78,    83,    51,    78,    52,    24,    51,    51,
      77,    51,    51,    78,    77,    77,    77,    51,    77
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
#line 158 "parser.y"
    { 
                                      (yylsp[(1) - (1)]); 
                                      /* pp2: The @1 is needed to convince 
                                       * yacc to set up yylloc. You can remove 
                                       * it once you have other uses of @n*/
                                      Program *program = new Program((yyvsp[(1) - (1)].declList));
                                      // if no errors, advance to next phase
                                      if (ReportError::NumErrors() == 0) 
                                          program->Build();
                                    }
    break;

  case 3:

/* Line 1455 of yacc.c  */
#line 170 "parser.y"
    { ((yyval.declList)=(yyvsp[(1) - (2)].declList))->Append((yyvsp[(2) - (2)].decl)); }
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 171 "parser.y"
    { ((yyval.declList) = new List<Decl*>)->Append((yyvsp[(1) - (1)].decl)); }
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 174 "parser.y"
    { (yyval.decl) = (yyvsp[(1) - (1)].functionDecl); }
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 181 "parser.y"
    { (yyval.interfaceDecl) = new InterfaceDecl(new Identifier((yylsp[(2) - (5)]), (yyvsp[(2) - (5)].identifier)), (yyvsp[(4) - (5)].prototypePlus)); }
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 183 "parser.y"
    { (yyval.interfaceDecl) = new InterfaceDecl(new Identifier((yylsp[(2) - (4)]), (yyvsp[(2) - (4)].identifier)), new List<Decl*>); }
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 186 "parser.y"
    { ((yyval.prototypePlus) = (yyvsp[(1) - (2)].prototypePlus))->Append((yyvsp[(2) - (2)].prototype)); }
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 187 "parser.y"
    { ((yyval.prototypePlus) = new List<Decl*>)->Append((yyvsp[(1) - (1)].prototype)); }
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 190 "parser.y"
    { (yyval.prototype) = new FnDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), (yyvsp[(1) - (6)].type), (yyvsp[(4) - (6)].formals)); }
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 192 "parser.y"
    { (yyval.prototype) = new FnDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), Type::voidType, (yyvsp[(4) - (6)].formals)); }
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 196 "parser.y"
    { (yyval.classDecl) = new ClassDecl(new Identifier((yylsp[(2) - (3)]), (yyvsp[(2) - (3)].identifier)), NULL, new List<NamedType*>, (yyvsp[(3) - (3)].fieldStar)); }
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 198 "parser.y"
    { (yyval.classDecl) = new ClassDecl(new Identifier((yylsp[(2) - (5)]), (yyvsp[(2) - (5)].identifier)), new NamedType(new Identifier((yylsp[(4) - (5)]), (yyvsp[(4) - (5)].identifier))), new List<NamedType*>, (yyvsp[(5) - (5)].fieldStar)); }
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 200 "parser.y"
    { (yyval.classDecl) = new ClassDecl(new Identifier((yylsp[(2) - (5)]), (yyvsp[(2) - (5)].identifier)), NULL, (yyvsp[(4) - (5)].idList), (yyvsp[(5) - (5)].fieldStar)); }
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 202 "parser.y"
    { (yyval.classDecl) = new ClassDecl(new Identifier((yylsp[(2) - (7)]), (yyvsp[(2) - (7)].identifier)), new NamedType(new Identifier((yylsp[(4) - (7)]), (yyvsp[(4) - (7)].identifier))), (yyvsp[(6) - (7)].idList), (yyvsp[(7) - (7)].fieldStar)); }
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 204 "parser.y"
    { ((yyval.idList) = (yyvsp[(1) - (3)].idList))->Append(new NamedType(new Identifier((yylsp[(3) - (3)]), (yyvsp[(3) - (3)].identifier)))); }
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 205 "parser.y"
    { ((yyval.idList) = new List<NamedType*>)->Append(new NamedType(new Identifier((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].identifier)))); }
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 208 "parser.y"
    { ((yyval.fieldList) = (yyvsp[(1) - (2)].fieldList))->Append((yyvsp[(2) - (2)].field)); }
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 209 "parser.y"
    { ((yyval.fieldList) = new List<Decl*>)->Append((yyvsp[(1) - (1)].field)); }
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 212 "parser.y"
    { (yyval.fieldStar) = new List<Decl*>; }
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 213 "parser.y"
    { (yyval.fieldStar) = (yyvsp[(2) - (3)].fieldList); }
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 216 "parser.y"
    { (yyval.field) = (yyvsp[(1) - (1)].varDecl); }
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 217 "parser.y"
    { (yyval.field) = (yyvsp[(1) - (1)].functionDecl); }
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 220 "parser.y"
    { (yyval.varDecl) = (yyvsp[(1) - (2)].variable); }
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 222 "parser.y"
    { ((yyval.varDeclList) = (yyvsp[(1) - (2)].varDeclList))->Append((yyvsp[(2) - (2)].varDecl)); }
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 223 "parser.y"
    { ((yyval.varDeclList) = new List<VarDecl*>)->Append((yyvsp[(1) - (1)].varDecl)); }
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 226 "parser.y"
    { (yyval.variable) = new VarDecl(new Identifier((yylsp[(2) - (2)]),(yyvsp[(2) - (2)].identifier)), (yyvsp[(1) - (2)].type)); }
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 230 "parser.y"
    { ((yyval.functionDecl) = new FnDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), (yyvsp[(1) - (6)].type), (yyvsp[(4) - (6)].formals)))->SetFunctionBody((yyvsp[(6) - (6)].stmtBlock));}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 232 "parser.y"
    { ((yyval.functionDecl) = new FnDecl(new Identifier((yylsp[(2) - (6)]), (yyvsp[(2) - (6)].identifier)), Type::voidType, (yyvsp[(4) - (6)].formals)))->SetFunctionBody((yyvsp[(6) - (6)].stmtBlock));}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 235 "parser.y"
    { (yyval.type) = Type::intType; }
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 236 "parser.y"
    { (yyval.type) = Type::doubleType; }
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 237 "parser.y"
    { (yyval.type) = Type::boolType; }
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 238 "parser.y"
    { (yyval.type) = Type::stringType; }
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 239 "parser.y"
    { (yyval.type) = new NamedType(new Identifier((yylsp[(1) - (1)]),(yyvsp[(1) - (1)].identifier))); }
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 240 "parser.y"
    { (yyval.type) = new ArrayType((yylsp[(1) - (2)]), (yyvsp[(1) - (2)].type)); }
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 243 "parser.y"
    { ((yyval.formals) = (yyvsp[(1) - (3)].formals))->Append((yyvsp[(3) - (3)].variable)); }
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 244 "parser.y"
    { ((yyval.formals) = new List<VarDecl*>)->Append((yyvsp[(1) - (1)].variable)); }
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 245 "parser.y"
    { (yyval.formals) = new List<VarDecl*>; }
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 248 "parser.y"
    { (yyval.stmtBlock) = new StmtBlock((yyvsp[(2) - (4)].varDeclList), (yyvsp[(3) - (4)].stmtList)); }
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 249 "parser.y"
    { (yyval.stmtBlock) = new StmtBlock((yyvsp[(2) - (3)].varDeclList), new List<Stmt*>); }
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 250 "parser.y"
    { (yyval.stmtBlock) = new StmtBlock(new List<VarDecl*>, (yyvsp[(2) - (3)].stmtList)); }
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 251 "parser.y"
    { (yyval.stmtBlock) = new StmtBlock(new List<VarDecl*>, new List<Stmt*>); }
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 254 "parser.y"
    { (yyval.stmt) = (yyvsp[(1) - (2)].expr); }
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 255 "parser.y"
    { (yyval.stmt) = new EmptyExpr(); }
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 256 "parser.y"
    { (yyval.stmt) = (yyvsp[(1) - (1)].ifStmt); }
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 257 "parser.y"
    { (yyval.stmt) = (yyvsp[(1) - (1)].whileStmt); }
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 258 "parser.y"
    { (yyval.stmt) = (yyvsp[(1) - (1)].forStmt); }
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 259 "parser.y"
    { (yyval.stmt) = (yyvsp[(1) - (1)].breakStmt); }
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 260 "parser.y"
    { (yyval.stmt) = (yyvsp[(1) - (1)].returnStmt); }
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 261 "parser.y"
    { (yyval.stmt) = (yyvsp[(1) - (1)].printStmt); }
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 262 "parser.y"
    { (yyval.stmt) = (yyvsp[(1) - (1)].stmtBlock); }
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 265 "parser.y"
    { (yyval.expr) = new AssignExpr((yyvsp[(1) - (3)].lValue), new Operator((yylsp[(2) - (3)]), "="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 266 "parser.y"
    { (yyval.expr) = (yyvsp[(1) - (1)].constant); }
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 268 "parser.y"
    { (yyval.expr) = new This((yylsp[(1) - (1)])); }
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 270 "parser.y"
    { (yyval.expr) = (yyvsp[(2) - (3)].expr); }
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 271 "parser.y"
    { (yyval.expr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "+"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 272 "parser.y"
    { (yyval.expr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "-"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 273 "parser.y"
    { (yyval.expr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "*"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 274 "parser.y"
    { (yyval.expr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "/"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 275 "parser.y"
    { (yyval.expr) = new ArithmeticExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "%"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 277 "parser.y"
    { (yyval.expr) = new ArithmeticExpr(new Operator((yylsp[(1) - (2)]), "-"), (yyvsp[(2) - (2)].expr)); }
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 278 "parser.y"
    { (yyval.expr) = new RelationalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "<"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 279 "parser.y"
    { (yyval.expr) = new RelationalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), ">"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 280 "parser.y"
    { (yyval.expr) = new RelationalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "<="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 281 "parser.y"
    { (yyval.expr) = new RelationalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), ">="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 282 "parser.y"
    { (yyval.expr) = new EqualityExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "=="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 283 "parser.y"
    { (yyval.expr) = new EqualityExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "!="), (yyvsp[(3) - (3)].expr)); }
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 284 "parser.y"
    { (yyval.expr) = new LogicalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "&&"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 285 "parser.y"
    { (yyval.expr) = new LogicalExpr((yyvsp[(1) - (3)].expr), new Operator((yylsp[(2) - (3)]), "||"), (yyvsp[(3) - (3)].expr)); }
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 286 "parser.y"
    { (yyval.expr) = new LogicalExpr(new Operator((yylsp[(1) - (2)]), "!"), (yyvsp[(2) - (2)].expr)); }
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 287 "parser.y"
    { (yyval.expr) = new ReadIntegerExpr((yylsp[(1) - (3)])); }
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 288 "parser.y"
    { (yyval.expr) = new ReadLineExpr((yylsp[(1) - (3)])); }
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 289 "parser.y"
    { (yyval.expr) = new NewExpr((yylsp[(1) - (4)]), new NamedType(new Identifier((yylsp[(3) - (4)]), (yyvsp[(3) - (4)].identifier)))); }
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 290 "parser.y"
    { (yyval.expr) = new NewArrayExpr((yylsp[(1) - (6)]), (yyvsp[(3) - (6)].expr), (yyvsp[(5) - (6)].type)); }
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 293 "parser.y"
    { ((yyval.exprList) = (yyvsp[(1) - (3)].exprList))->Append((yyvsp[(3) - (3)].expr)); }
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 294 "parser.y"
    { ((yyval.exprList) = new List<Expr*>)->Append((yyvsp[(1) - (1)].expr)); }
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 297 "parser.y"
    { (yyval.lValue) = new FieldAccess(NULL, new Identifier((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].identifier))); }
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 298 "parser.y"
    { (yyval.lValue) = new FieldAccess((yyvsp[(1) - (3)].expr), new Identifier((yylsp[(3) - (3)]), (yyvsp[(3) - (3)].identifier))); }
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 299 "parser.y"
    { (yyval.lValue) = new ArrayAccess((yylsp[(1) - (4)]), (yyvsp[(1) - (4)].expr), (yyvsp[(3) - (4)].expr)); }
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 302 "parser.y"
    { (yyval.constant) = new IntConstant((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].integerConstant)); }
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 303 "parser.y"
    { (yyval.constant) = new DoubleConstant((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].doubleConstant)); }
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 304 "parser.y"
    { (yyval.constant) = new BoolConstant((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].boolConstant)); }
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 305 "parser.y"
    { (yyval.constant) = new StringConstant((yylsp[(1) - (1)]), (yyvsp[(1) - (1)].stringConstant)); }
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 306 "parser.y"
    { (yyval.constant) = new NullConstant((yylsp[(1) - (1)])); }
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 309 "parser.y"
    { (yyval.call) = new Call((yylsp[(1) - (4)]), NULL, new Identifier((yylsp[(1) - (4)]), (yyvsp[(1) - (4)].identifier)), (yyvsp[(3) - (4)].actuals)); }
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 310 "parser.y"
    { (yyval.call) = new Call((yylsp[(1) - (6)]), (yyvsp[(1) - (6)].expr), new Identifier((yylsp[(3) - (6)]), (yyvsp[(3) - (6)].identifier)), (yyvsp[(5) - (6)].actuals)); }
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 313 "parser.y"
    { (yyval.actuals) = (yyvsp[(1) - (1)].exprList); }
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 314 "parser.y"
    { (yyval.actuals) = new List<Expr*>; }
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 317 "parser.y"
    { (yyval.ifStmt) = new IfStmt((yyvsp[(3) - (5)].expr), (yyvsp[(5) - (5)].stmt), NULL); }
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 318 "parser.y"
    { (yyval.ifStmt) = new IfStmt((yyvsp[(3) - (7)].expr), (yyvsp[(5) - (7)].stmt), (yyvsp[(7) - (7)].stmt)); }
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 321 "parser.y"
    { (yyval.whileStmt) = new WhileStmt((yyvsp[(3) - (5)].expr), (yyvsp[(5) - (5)].stmt)); }
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 324 "parser.y"
    { (yyval.forStmt) = new ForStmt((yyvsp[(3) - (9)].expr), (yyvsp[(5) - (9)].expr), (yyvsp[(7) - (9)].expr), (yyvsp[(9) - (9)].stmt)); }
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 325 "parser.y"
    { (yyval.forStmt) = new ForStmt(new EmptyExpr(), (yyvsp[(4) - (8)].expr), (yyvsp[(6) - (8)].expr), (yyvsp[(8) - (8)].stmt)); }
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 326 "parser.y"
    { (yyval.forStmt) = new ForStmt((yyvsp[(3) - (8)].expr), (yyvsp[(5) - (8)].expr), new EmptyExpr(), (yyvsp[(8) - (8)].stmt)); }
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 327 "parser.y"
    { (yyval.forStmt) = new ForStmt(new EmptyExpr(), (yyvsp[(4) - (7)].expr), new EmptyExpr(), (yyvsp[(7) - (7)].stmt)); }
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 330 "parser.y"
    { (yyval.breakStmt) = new BreakStmt((yylsp[(1) - (2)])); }
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 333 "parser.y"
    { (yyval.returnStmt) = new ReturnStmt((yylsp[(1) - (2)]), new EmptyExpr()); }
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 334 "parser.y"
    { (yyval.returnStmt) = new ReturnStmt((yylsp[(2) - (3)]), (yyvsp[(2) - (3)].expr)); }
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 337 "parser.y"
    { (yyval.printStmt) = new PrintStmt((yyvsp[(3) - (5)].exprList)); }
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 340 "parser.y"
    { ((yyval.stmtList) = (yyvsp[(1) - (2)].stmtList))->Append((yyvsp[(2) - (2)].stmt)); }
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 341 "parser.y"
    { ((yyval.stmtList) = new List<Stmt*>)->Append((yyvsp[(1) - (1)].stmt)); }
    break;



/* Line 1455 of yacc.c  */
#line 2527 "y.tab.c"
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
#line 343 "parser.y"


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

