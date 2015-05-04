# https://docs.python.org/release/2.7.2/library/ast.html#abstract-grammar
# https://docs.python.org/release/3.4.2/library/ast.html#abstract-grammar

from ast import *
import ast
import sys
import _ast


class Print(ast.Print):
    # todo : more beautiful defaults
      def __init__(self, **kwargs):
          super(Print, self).__init__(*kwargs)
          if not "nl" in kwargs:
              self.nl=True


if sys.version_info > (3,0):
     # PYTHON 3 HACK!!
    class Print(stmt):
        _fields = (
            'dest',
            'values',
            'nl',
        )
    # | Exec(expr body, expr? globals, expr? locals)
    class Exec(Call):
        _fields = (
            'body',
            'globals',
            'locals',
        )


class Name(ast.Name):
    def __str__(self):
         return "<kast.Name id='%s'>"%self.id

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

# workaround: alias is keyword in ruby!
mapped_types={
    "Alias":alias,
    "int":Num,
    "Condition":expr,
    "Value":expr,
    "Then":expr #Value
}

types.update(mapped_types)
