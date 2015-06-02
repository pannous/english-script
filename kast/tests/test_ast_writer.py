import ast
import os
import ast2json
from ast import *
import ast_export

# import codegen
from astor import codegen

source=os.path.realpath(__file__)
# source='/Users/me/angelos/kast/tests/hi.py'
source='/Users/me/angelos/kast/ast_import.py'
print(source)
contents=open(source).readlines()# all()
contents="\n".join(contents)
source="(string)" # compile from inline string source:
# contents="def x():pass"
# contents="from x import *"
# contents="x.y=1"
# contents="x=1;x=x+1"
# contents="x=1;x++" # INVALID!
contents="x=6;x%=3"
# contents="x=y[1]"
# contents="self.x(1)"
# contents="(1 or 2) and 0" # 0  BoolOp(And(), [BoolOp(Or(), [Num(1), Num(2)]), Num(0)])
# contents="1 or 2 and 0" #1   BoolOp(Or(), [Num(1), BoolOp(And(), [Num(2), Num(0)])
# contents="@classmethod\ndef c():pass"
# contents='re.match(r"a(.*)b","acb")'
# contents="x[1:3]" #Subscript(Name('x', Load()), Slice(Num(1), Num(3), None), Load())
# contents="super(1)"
# contents="'a %s'%(1)" #BinOp(Str('a %s'), Mod(), Num(1)))
# contents="'a'+ok+'b'" #BinOp(BinOp(Str('a'), Add(), Name('ok', Load())), Add(), Str('b')))
# contents="class T:pass\ndef test(self):self.x=1\nz=T();test(z);print(z.x)" #Assign([Attribute(Name('self', Load()), attr='x', Store())], Num(1))
# contents="x[1]" # Subscript(Name('x', Load()), Index(Num(1)), Load()))
# contents="x[1]=3" # Assign(targets=[Subscript(Name('x', Load()), Index(Num(1)), Store())], value=Num(3))
# <AttrAssign name='[]='>
# 	<VCall name='variables'/>
# 	<Array>
# 		<Str value='x'/> # << TARGET
# 		<Str value='/Users/me'/> << VALUE!!
# 	</Array>
# </AttrAssign>

# It seems that the best way is using tokenize.open(): http://code.activestate.com/lists/python-dev/131251/
# code=compile(contents, source, 'eval')# import ast -> SyntaxError: invalid syntax  NO IMPORT HERE!
# code=compile(contents, source, 'exec') # code object  AH!!!
file_ast=compile(contents, source, 'exec',ast.PyCF_ONLY_AST) # AAAAHHH!!!



x=ast.dump(file_ast, annotate_fields=True, include_attributes=True)
print(x)

file_ast=ast.parse(contents ,source,'exec')
x=ast.dump(file_ast, annotate_fields=False, include_attributes=False)
print(x)


j=ast2json.ast2json(file_ast)
# print(j)
# assert code==code2
# code=compile(open(source), source, 'exec')

# import compiler # OLD! Module(None, Stmt([Discard(Add((Const(1), Const(2))))]))
# file_ast=compiler.parseFile(source)
# print(file_ast)

# file_ast=ast.parse(code ,source,'eval')
# x=ast.dump(file_ast, annotate_fields=True, include_attributes=False)
# print(x)
# file_ast=ast.parse(code ,source,'eval')

# x=ast.dump(file_ast, annotate_fields=True, include_attributes=False)

my_ast=Module(body=[
    For(
        target=Name(id='i', ctx=Store(),lineno=1, col_offset=4),
        iter=Call(
            func=Name(id='range', ctx=Load(), lineno=1, col_offset=9),
            args=[Num(n=10, lineno=1, col_offset=15)],
            keywords=[], starargs=None, kwargs=None, lineno=1, col_offset=9),
            body=[
                Print(
                    value="dbg",
                    dest=None,
                    values=[Name(id='i', ctx=Load(), lineno=1, col_offset=26)],
                    nl=True,
                    lineno=1,
                    col_offset=20
                )
        ],
        orelse=[],
        lineno=1,
        col_offset=0
    )
])

my_ast=file_ast
# my_ast=Module([Assign([Attribute(Name('self', Load()), 'x', Store())], Num(1))])
# my_ast=Module([Assign([Name('self.x', Store())], Num(1))]) # DANGER!! syntaktisch korrekt aber semantisch sich nicht!!
# my_ast=Module([Assign([Name('self.x', Store())], Num(1)),Print(None, [Name('self.x', Load())], True)])
# my_ast=Module(body=[Assign(targets=[Attribute(value=Name(id='self', ctx=Load(), lineno=1, col_offset=0), attr='x', ctx=Store(), lineno=1, col_offset=0)], value=Num(n=1, lineno=1, col_offset=7), lineno=1, col_offset=0)])

ast_export.Visitor().visit(my_ast) # => XML

source=codegen.to_source(my_ast)
print(source) # => CODE

my_ast=ast.fix_missing_locations(my_ast)
code=compile(my_ast, 'file', 'exec')
# ast_reader.emit_pyc(code)
exec(code)
# print (self.x)
