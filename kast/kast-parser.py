# -*- coding: utf-8 -*-

# https://github.com/tkf/sexpdata S-expression parser for Python

# https://github.com/dmw/pyxser/blob/master/src/pyxser_serializer.c
# import ast
# from ast import *
import io
import xml.etree.ElementTree as Xml
import kast
from kast import *

# from xml.dom.minidom import parse
# file=open("test.xast")
# xml=parse(file)
# print xml.toxml()

# schema_file='kast.xsd'
# kast_file='test.pyast.xml'
kast_file='test_mini.pyast.xml'
# kast_file='test_full.pyast.xml'
# kast_file='test.xast'
# kast_file='test.kast.xml'
kast_file='kast.yml'
# pyast_file='demo.pyast'

def yml2xml(builder, body, tabs=0):
    if(tabs==0 and len(body)>1): builder.write( "<module xmlns='http://angle-lang.org'>\n")
    if isinstance(body,list):
        builder.write(str(body))
        return
    for elem in body:
        k=elem
        v=body[k]
        val=isinstance(v,int)
        val=val or isinstance(v,float)
        val=val or isinstance(v,str)
        val=val or isinstance(v,bool)
        if val:
            builder.write( "\t"*tabs+"<%s>%s</%s>\n"%(k,v,k))
        else:
            builder.write( "\t"*tabs+"<%s>\n"%k)
            yml2xml(builder, v, tabs+1)
            builder.write("\t"*tabs+"</%s>\n"%k)
    if (tabs==0 and len(body)>1): builder.write("</module>")
    return builder

file=open(kast_file)
if kast_file.endswith("yml"):
    import yaml
    from cStringIO import StringIO
    xml =yml2xml(StringIO(),yaml.load(file)).getvalue()
    kast_file = xml # StringIO 'file' ;)
    print(xml)
    root = Xml.fromstring(xml)
else:
    tree = Xml.parse(kast_file)
    root = tree.getroot()
import re
xmlns=re.sub("\}.*","}",root.tag)
# if xmlns!=root.tag: xmlns=xmlns[1:-1]


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
    global xmlns
    tag=node.tag.replace(xmlns,"")
    if(tag=="name"):
        return Name(id=node.text)
    elif(tag=="num"):
        return Num(n=int(node.text))
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
    expect=elem._fields # [x for x in dir(elem) if not x.startswith("_")]
    body=[]
    # if(isinstance(node,Name)):
    #     print("KL")
    # if children==[] and node.text and node.text.strip()!="": #// too late!
    #     val=parseString(tag, node.text)
    #     elem.__setattr__(tag, val)
    #     if(len(expect)==1):
    #         elem=construct(val)
    for c in children:
        childName=c.tag.replace(xmlns,"")
        if(childName=="name"):
            child=parseString(childName,c.text.strip())
        elif(childName=="num"):
            child=Num(n=int(c.text))
        elif not childName in kast.types: #i.e.: body=...
            babies=c.getchildren()
            if babies==[] and c.text and c.text.strip()!="":
                child=parseString(childName, c.text)
            elif len(babies)==1 and not childName in ['args','body','values']:#
                child=build(babies[0])
            else:
                child=[build(n) for n in babies]
        else:
            child=build(c)
            if(isinstance(child,list)):
                body=child
            else:
                body.append(child)
        elem.__setattr__(childName, child)
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

code=compile(my_ast, kast_file, 'exec')#flags=None, dont_inherit=None
# TypeError: required field 'lineno' missing from stmt
# no, what you actually mean is "tuple is not a statement" LOL WTF ;)

exec(code)

