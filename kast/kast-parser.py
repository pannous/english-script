# https://github.com/dmw/pyxser/blob/master/src/pyxser_serializer.c
# import ast
# from ast import *
import xml.etree.ElementTree as ET
import kast
from kast import *

# from xml.dom.minidom import parse
# file=open("test.xast")
# xml=parse(file)
# print xml.toxml()

file='test.kast.xml'
schema_file='kast.xsd'
# xast_file='test.pyast.xml'
# xast_file='test_mini.pyast.xml'
xast_file='test_full.pyast.xml'
# xast_file='test.xast'
# xast_file='test.kast.xml'
# ast_file='demo.pyast'
tree = ET.parse(xast_file)
root = tree.getroot()


def parseString(a, v):
    if(v.isdigit()):v=Num(int(v)) #todo: float!
    elif(v.startswith("[")): # too much suggar??
        args=v[1:-1].replace(","," ").split(" ")
        v=[]
        for arg in args:
            if(arg.isdigit()):v.append(Num(int(arg)))
            else:v.append(Name(id=arg,ctx=Load()))
    elif(v.startswith("'")):
        v=Str(v[1:-1])
    elif(a!='id'):
        ctx=Load()
        if a=='func' or a=='value' or a=='values':
            ctx=Load()
        if a=='target':
            ctx=Store()
        v=Name(id=v,ctx=ctx)
    return v


def build(node):
    tag=node.tag
    construct= kast.types[tag]
    elem=construct()
    # 'data'
    attribs=node.attrib
    for a in attribs:
        v=attribs[a]
        if(a=='lineno' or a=='col_offset'):v=int(v)
        if(a=='n'):v=int(v)
        if(v=='True'):v=True
        if(v=='False'):v=False
        if(v=='Load'):v=Load()
        if(v=='Store'):v=Store()
        if(isinstance(v,str)):
            v=parseString(a,v)
        if a.endswith("s") and not isinstance(v,list):v=[v]
        elem.__setattr__(a,v)

    children=node.getchildren()
    body=[]
    for c in children:
        if not c.tag in kast.types: #i.e.: body=...
            babies=c.getchildren()
            if len(babies)==1 and not c.tag in ['args','body','values']:#
                elem.__setattr__(c.tag,build(babies[0]))
            else:
                elem.__setattr__(c.tag,[build(n) for n in babies])
        else:
            child=build(c)
            if(isinstance(child,list)):
                body=child
            else:
                body.append(child)
    if len(body)>0:
        elem.body=body
    attribs=dir(elem)
    if not 'keywords' in attribs:
        elem.keywords=[] #hack
    # if not 'values'  in attribs:
    #     elem.values=[] #
    if not 'starargs' in attribs:
        elem.starargs=None #hack
    if not 'kwargs' in attribs:
        elem.kwargs=None #hack
    if not 'dest' in attribs:
        elem.dest=None #hack
    if not 'orelse' in attribs:
        elem.orelse=[] #hack
    if not 'lineno' in attribs:
        elem.lineno=0 #hack
    if not 'col_offset' in attribs:
        elem.col_offset=0 #hack
    return elem

my_ast=build(root)
if not isinstance(my_ast,Module):
    if(isinstance(my_ast,list)):
        my_ast=Module(body=my_ast)
    else:
        my_ast=Module(body=[my_ast])


# correct: Module(body=[For(target=Name(id='i', ctx=Store(), lineno=1, col_offset=4), iter=Call(func=Name(id='range', ctx=Load(), lineno=1, col_offset=9), args=[Num(n=10, lineno=1, col_offset=15)], keywords=[], starargs=None, kwargs=None, lineno=1, col_offset=9), body=[Print(dest=None, values=[Name(id='i', ctx=Load(), lineno=1, col_offset=26)], nl=True, lineno=1, col_offset=20)], orelse=[], lineno=1, col_offset=0)])
# broken!: Module(body=[For(target=Name(id='i', ctx=Store(), lineno=0, col_offset=0), iter=Call(func=Name(id='range', ctx=Load(), lineno=0, col_offset=0), args=[Num(n='10', lineno=0, col_offset=0)], keywords=[], starargs=None, kwargs=None, lineno=0, col_offset=0), body=[Print(dest=None, values=[Name(id='i', ctx=Load(), lineno=0, col_offset=0)], nl=True, lineno=0, col_offset=0)], orelse=[], lineno=0, col_offset=0)])
def load(file):
    return open(file,'rb').read()
    # return "\n".join(open(file).readlines())

my_ast=ast.fix_missing_locations(my_ast)

x=ast.dump(my_ast, annotate_fields=True, include_attributes=True)
print(x)
import codegen
print(codegen.to_source(my_ast))

code=compile(my_ast, xast_file, 'exec')#flags=None, dont_inherit=None
# TypeError: required field 'lineno' missing from stmt
# no, what you actually mean is "tuple is not a statement" LOL WTF ;)

exec(code)

