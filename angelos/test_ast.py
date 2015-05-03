# https://docs.python.org/release/2.7.2/library/ast.html#abstract-grammar
# https://docs.python.org/release/3.4.2/library/ast.html#abstract-grammar
# -- ASDL's six builtin types are identifier, int, string, bytes, object, >>> singleton <<< NEW

# Deprecated since version 2.6: The compiler package has been removed in Python 3.   WAAAH!! WTF! egal -> breaks a lot!!
#
import ast
import json
import os
from ast import *
# import yaml
# map = yaml.load(file(filename))

# def print(x):
#     import builtins
#     builtins.print(x)

# pip install ast2json
import ast2json

source=os.path.realpath(__file__)
source='/Users/me/angelos/tests/hi.py'
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

def good_fields(node):
    more=[]
    # if isinstance(node,ast.Print):
    #     more=['values']
    return list(node._fields)+more
    #
    # if isinstance(node,Name):return []
    # if isinstance(node,Num):return []
    # good=[]
    # for f in node._fields:
    #     v=node.__getattribute__(f)
    #     if isinstance(v,str): continue
    #     # if isinstance(v,list): continue
    #     if isinstance(v,expr_context):continue
    #     if isinstance(v,operator):continue
    #     if isinstance(v,cmpop):continue
    #     # if isinstance(v,Name):continue
    #     # if isinstance(v,Num):continue
    #     good.append(f)
    # return good

yet_visited={}
class Visitor(NodeVisitor):
    def generic_visit(self, node):
        tag = type(node).__name__
        if (isinstance(node,ast.Print) or tag=='Print'):
            pass
        if node in yet_visited:
            return
        yet_visited[node]=True

        if isinstance(node,str) or isinstance(node,int):
            print node
            return
        if isinstance(node,expr_context):return
        # if isinstance(node,operator):return
        # if isinstance(node,cmpop):return
        # help(node)
        attribs=""#+" ".join(dir(node))

        goodfields=good_fields(node)

        for f in dir(node):
            if str(f).startswith("_"): continue
            # if str(f)==("col_offset"): continue
            # if str(f)==("lineno"): continue
            a=node.__getattribute__(f)
            if a is None:continue
            if isinstance(a,stmt):continue # later through fields
            if isinstance(a,expr):continue
            if isinstance(a,list):continue
            if isinstance(a,Num):a=a.n
            if isinstance(a,Name):a=a.id
            if isinstance(a,expr_context):a=type(a).__name__
            if isinstance(a,operator):a=type(a).__name__
            if isinstance(a,cmpop):a=type(a).__name__
            yet_visited[a]=True
            attribs=attribs+" %s='%s'"%(f,a)



        # for a in node._attributes:
        #     attribs=attribs+" %s='%s'"%(a,node.__getattribute__(a))
        # for f in node._fields:
        #     a=node.__getattribute__(f)
        #     # if not (isinstance(a,str) or isinstance(a,Num)): continue
        #     if isinstance(a,Num):a=a.n
        #     attribs=attribs+" %s='%s'"%(f,a)
        # print node.body
        print "<%s%s>"%(tag,attribs)
        # if len(goodfields)==0 and not isinstance(node,ast.Module):
        #     print "/>"
        #     return
        # else:
        #     print ">"


        for f in goodfields:
            a=node.__getattribute__(f)
            if isinstance(a,list):continue
            if isinstance(a,expr_context):continue
            if a is None or a in yet_visited:
                continue #ja?
            print "<%s>"%(str(f))
            self.generic_visit(a)
            print "</%s>"%(str(f))

        for f in goodfields:#
            if str(f).startswith("_"): continue
            # if str(f).startswith("body"): continue
            a=node.__getattribute__(f)
            if not isinstance(a,list):continue
            if len(a)==0:continue
            print "<%s>"%(str(f))
            for x in a:
                self.generic_visit(x)
            print "</%s>"%(str(f))

        NodeVisitor.generic_visit(self, node)#??
        print "</%s>"%(tag)


# j=json.dumps(ast.__dict__);
# j=json.dumps(ast);
# print(j)


Visitor().visit(my_ast)
code=compile(my_ast, 'file', 'exec')
# z=exec(code)
# print(z)
# print(exec(code))#, glob, loc)

class RewriteName(NodeTransformer):

    def visit_Name(self, node):
        return copy_location(Subscript(
            value=Name(id='data', ctx=Load()),
            slice=Index(value=Str(s=node.id)),
            ctx=node.ctx
        ), node)
