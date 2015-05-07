# https://docs.python.org/release/2.7.2/library/ast.html#abstract-grammar
# https://docs.python.org/release/3.4.2/library/ast.html#abstract-grammar

from ast import *
import ast
import sys
import _ast


class Assign(ast.Assign):
    def set_var(self,var):self.targets=[var]
    var = property(lambda self:self.targets, set_var)
    variable = property(lambda self:self.targets, set_var)
    variables = property(lambda self:self.targets, set_var)
    object = property(lambda self:self.targets, set_var)

class Call(ast.Call):
    def set_method(self,method):self.func=method
    method = property(lambda self:self.func, set_method)
    def set_object(self,o):self.targets=[o]
    object = property(lambda self:self.targets, set_object)
    # method = property(lambda self:self.func, lambda self,method:[0 for self.func in [method]])

class ClassDef(ast.ClassDef):
    def __init__(self, **kwargs):
        super(ast.ClassDef,self).__init__(*kwargs)
        if not "nl" in kwargs:
            self.nl=True
        if not "decorator_list" in kwargs:
            self.decorator_list=[]
        if not "bases" in kwargs:
            self.bases=[]

# todo : more beautiful mappings / defaults
class Import(ast.Import):
    def set_package(self,package):
        self.names=[package]
    def get_package(self):
        return self.names
    package = property(get_package , set_package )

class FunctionDef(ast.FunctionDef):
    def __init__(self, **kwargs):
        super(ast.FunctionDef,self).__init__(*kwargs)
        if not "decorator_list" in kwargs:
            self.decorator_list=[]

class Print(ast.Print):
      def __init__(self, **kwargs):
          super(ast.Print,self).__init__(*kwargs)
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
    # def __init__(self, **kwargs):
    #     super(ast.Name,self).__init__(*kwargs)
    def __str__(self):
         return "<kast.Name id='%s'>"%self.id

types={ # see _ast.py , F12:
"Raise":Raise,#danger raise keyword
"class":ClassDef,
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
'Raise':Raise,
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
    "class_method":FunctionDef,
    "int":Num,
    "let":Assign,
    "Condition":expr,
    "Value":expr,
    "Then":expr #Value
}

types.update(mapped_types)
for k,v in types.items():
    if(k=='Raise'):continue
    if(k=='Let'):continue
    types[k.lower()]=types[k]
    types["{http://angle-lang.org}"+k.lower()]=types[k]

