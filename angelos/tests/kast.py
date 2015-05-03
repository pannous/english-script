from ast import *
import ast

types={ # see _ast.py , F12:
    "class":ast.ClassDef,
"operator":operator,
"Add":Add,
"alias":alias,
"boolop":boolop,
"And":And,
"arguments":arguments,
"stmt":stmt,
"Assert":Assert,
"Assign":Assign,
"expr":expr,
"Attribute":Attribute,
"AugAssign":AugAssign,
"expr_context":expr_context,
"AugLoad":AugLoad,
"AugStore":AugStore,
"BinOp":BinOp,
"BitAnd":BitAnd,
"BitOr":BitOr,
"BitXor":BitXor,
"BoolOp":BoolOp,
"Break":Break,
"Call":Call,
"ClassDef":ClassDef,
"cmpop":cmpop,
"Compare":Compare,
"comprehension":comprehension,
"Continue":Continue,
"Del":Del,
"Delete":Delete,
"Dict":Dict,
"DictComp":DictComp,
"Div":Div,
"slice":slice,
"Ellipsis":Ellipsis,
"Eq":Eq,
"excepthandler":excepthandler,
"ExceptHandler":ExceptHandler,
"Exec":Exec,
"Expr":Expr,
"mod":mod,
"Expression":Expression,
"ExtSlice":ExtSlice,
"FloorDiv":FloorDiv,
"For":For,
"FunctionDef":FunctionDef,
"GeneratorExp":GeneratorExp,
"Global":Global,
"Gt":Gt,
"GtE":GtE,
"If":If,
"IfExp":IfExp,
"Import":Import,
"ImportFrom":ImportFrom,
"In":In,
"Index":Index,
"Interactive":Interactive,
"unaryop":unaryop,
"Invert":Invert,
"Is":Is,
"IsNot":IsNot,
"keyword":keyword,
"Lambda":Lambda,
"List":List,
"ListComp":ListComp,
"Load":Load,
"LShift":LShift,
"Lt":Lt,
"LtE":LtE,
"Mod":Mod,
"Module":Module,
"Mult":Mult,
"Name":Name,
"Not":Not,
"NotEq":NotEq,
"NotIn":NotIn,
"Num":Num,
"Or":Or,
"Param":Param,
"Pass":Pass,
"Pow":Pow,
"Print":Print,
"Raise":Raise,
"Repr":Repr,
"Return":Return,
"RShift":RShift,
"Set":Set,
"SetComp":SetComp,
"Slice":Slice,
"Store":Store,
"Str":Str,
"Sub":Sub,
"Subscript":Subscript,
"Suite":Suite,
"TryExcept":TryExcept,
"TryFinally":TryFinally,
"Tuple":Tuple,
"UAdd":UAdd,
"UnaryOp":UnaryOp,
"USub":USub,
"While":While,
"With":With
    }

mapped_types={
    "Condition":expr,
    "Value":expr,
    "Then":expr #Value
}

types.update(mapped_types)

 # PYTHON 3 HACK!!
# class Print(stmt):
#     # no doc
#     def __init__(self, *args, **kwargs): # real signature unknown
#         pass
#
#     _fields = (
#         'dest',
#         'values',
#         'nl',
#     )
# class Print(ast.Pass):pass
# class Print(ast.Expr):pass
# class Print(ast.Expression):pass #TypeError: expected some sort of stmt,

class Alias(alias):
    pass
