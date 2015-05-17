import ast
import os
import ast2json
from ast import *
import ast_writer

source=os.path.realpath(__file__)
source='/Users/me/angelos/kast/tests/hi.py'
print(source)
contents=open(source).readlines()# all()
contents="\n".join(contents)
# It seems that the best way is using tokenize.open(): http://code.activestate.com/lists/python-dev/131251/
# code=compile(contents, source, 'eval')# import ast -> SyntaxError: invalid syntax  NO IMPORT HERE!
code=compile(contents, source, 'exec') # code object  AH!!!
file_ast=compile(contents, source, 'exec',ast.PyCF_ONLY_AST) # AAAAHHH!!!
ast.dump(file_ast)
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
x=ast.dump(file_ast, annotate_fields=True, include_attributes=True)
print(x)

file_ast=ast.parse(contents ,source,'exec')
x=ast.dump(file_ast, annotate_fields=True, include_attributes=False)
print(x)

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
ast_writer.Visitor().visit(my_ast)
