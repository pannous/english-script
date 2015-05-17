# https://docs.python.org/release/2.7.2/library/ast.html#abstract-grammar
# https://docs.python.org/release/3.4.2/library/ast.html#abstract-grammar

from ast import *
import ast
import sys
import _ast

class Args(list):
    pass

class Num(ast.Num):
    def set_value(self,n):self.n=n
    value = property(lambda self:self.n, set_value)

# class Name(ast.Name):
#     def set_name(self,id):
#         if(isinstance(id,Name)):id=id.id #WWWTTTFFF
#         self.id=id
#     name=property(lambda self:self.id,set_name)

class Str(ast.Str):
    def set_value(self,s):self.s=s
    value = property(lambda self:self.s, set_value)

class Assign(ast.Assign):
    def set_var(self,var):self.targets=[var]
    def set_val(self,val):self.value=val
    def set_vals(self,vals):self.value=vals[0]
    var = property(lambda self:self.targets, set_var)
    variable = property(lambda self:self.targets, set_var)
    variables = property(lambda self:self.targets, set_var)
    object = property(lambda self:self.targets, set_var)
    name = property(lambda self:self.targets, set_var)
    # body = property(lambda self:self.targets, set_var)
    body = property(lambda self:self.value, set_vals)

# a.split('b') =>
# Call(func=Attribute(value=Name(id='a', ctx=Load()), attr='split', ctx=Load()), args=[Str(s='b')]
class Call(ast.Call):
    def set_method(self,method):self.func=method
    method = property(lambda self:self.func, set_method)
    name = property(lambda self:self.func, set_method)

    def set_object(self,o):
        self.object=o
        if(isinstance(self.func,Name)):self.func=Attribute(attr=self.func)
        if(isinstance(self.func,Attribute)):self.func.value=o
    def get_object(self):
        if(isinstance(self.func,Attribute)):return self.func.value
        return None
    object = property(get_object, set_object)

    def set_args(self,oas):self.args=oas
    body = property(lambda self:self.args, set_args)
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
    "Block":Module, #NOT REALLY!
    # "Variable": Name,
    # "Const": Name, #todo
    "Class":ClassDef,
    "Alias":alias,
    # "Arguments":arguments,
    # "Args":arguments,
    # "Args":Args,
    "class_method":FunctionDef,
    "Method":FunctionDef,
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

