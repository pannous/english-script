# -*- coding: utf-8 -*-

# https://github.com/tkf/sexpdata S-expression parser for Python

# https://github.com/dmw/pyxser/blob/master/src/pyxser_serializer.c
# import ast
# from ast import *
import os
import xml.etree.ElementTree as Xml
import yaml
import kast
from kast import *
from kast_util import *
from transforms.kast_rewriter import *

call_map=xml =yaml.load(open("call-map.yml"))
const_map=xml =yaml.load(open("const-map.yml"))

global modules
global classes
modules=[]
classes={}

# global methods

# from xml.dom.minidom import parse
# file=open("test.xast")
# xml=parse(file)
# print xml.toxml()

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


def parseString(a, v,tag=None):
    if not v: return None
    # if(a=='name'):return v
    # if(isinstance(v,Na)
    v=v.strip()
    if(v.isdigit()):v=Num(int(v)) #todo: float!
    elif(v.startswith("[")): # too much suggar??
        args=v[1:-1].replace(","," ").split(" ")
        v=[]
        for arg in args:
            if(arg.isdigit()):v.append(Num(int(arg)))
            else:v.append(name(id=arg,ctx=Load()))
    elif(v.startswith("'")):
        v=Str(v[1:-1])
    elif(a!='id'):
        ctx=Load()
        if a=='func' or a=='value' or a=='values':
            ctx=Load()
        if a=='target':
            ctx=Store()
        v=name(id=v,ctx=ctx,tag=tag)
    return v


def name(id,ctx=Load(),tag=None):
    if id in const_map:
        id=const_map[id]
    if(tag=="Call"):
        if id in call_map:
            id=call_map[id]
    if id[0]=="@":
        return Attribute(Name('self', Load()), id[1:], ctx)
    elif id[0]=="$":
        return Attribute(Name('_global', Load()), id[1:], ctx)
    else:
        return Name(id=id, ctx=ctx)

global inClass
inClass=False


def self():
    Name(id='self',ctx=Load())


def do_import(files): # require,require_relative, import, ...
    def to_name(arg):
        return name(arg.s.replace("../","").replace(".rb",".py"))
    names=map(to_name,files)
    for file in files:
        parse_file(file.s)
    # return Import(names=names)
    return ImportFrom(module=names[0],names=[alias('*',None)],level=0)

def build(node,parent=None):
    global xmlns,inClass
    tag=node.tag.replace(xmlns,"")
    if(tag=="name"):
        return node.text # Name(id=node.text)
    elif(tag=="num"):
        return Num(n=int(node.text))
    elif(tag=="Num"):
        return Num(n=int(node.attrib["value"]))
    elif(tag=="If"):
        test = build(node._children[0])
        body = [build(n) for n in node._children[1:]]
        return If(test=test,body=body,orelse=[])
    elif(tag=="True"):
        return name('True') #WTF
    elif(tag=="False"):
        return name('False') #WTF
    elif(tag=="Str"):
        if(hasattr(node,'value')): return Str(s=node.attrib['value'])
        else:return Str(s=node.text)
    # elif(tag=="Call" and parent=="Assign"):
    #     tag="Variable" #VCall in ruby
    elif(tag=="Const"):
        return name(node.attrib['name'])
    elif(tag=="Variable" or tag=="variable"):
        return name(node.attrib['name'])# todo: CALL if in block!
        # return Name(id=node.attrib['value'], ctx=Load()) #WTF
    if not tag in kast.types:
        print("UNKNOWN tag %s"%(tag))
        if(len(node.getchildren())==0):return
    construct= kast.types[tag]
    elem=construct()
    # 'data'
    if(tag=="Call"):
        print("debug Call!")
    if(tag=="Class"):
        inClass=True
    #     print("debug Class!")
    # if(tag=="Method"): # FunctionDef
    #     print("debug Method!")


    attribs=node.attrib
    for a in attribs:
        v=attribs[a]
        if(a=='lineno' or a=='col_offset'):v=int(v)
        if(a=='n'):v=int(v)
        if(v=='True'):v=True
        if(v=='False'):v=False
        if(v=='Load'):v=Load()
        if(v=='Store'):v=Store()
        if(isinstance(v,str) and tag!="Method"):
            v=parseString(a,v,tag)
        if a.endswith("s") and not isinstance(v,list):v=[v]
        elem.__setattr__(a,v)

    children=node.getchildren()
    # expect=elem._fields # [x for x in dir(elem) if not x.startswith("_")]
    body=[]
    # if(isinstance(node,Name)):
    #     print("KL")
    # if children==[] and node.text and node.text.strip()!="": #// too late!
    #     val=parseString(tag, node.text)
    #     elem.__setattr__(tag, val)
    #     if(len(expect)==1):
    #         elem=construct(val)
    for c in children:
        babies=c.getchildren() # look ahead
        childName=c.tag.replace(xmlns,"").lower()
        if(childName=="block"):
            childName="body"
        if(childName=="const"):
            if tag=="Class":
                childName="bases"
                child=[name(c.attrib['name'])]
            else:
                child=name(c.attrib['name'])
        elif(childName=="name"):
            if "name" in c.attrib:
                child=c.attrib['name']
                # child=parseString(childName,c.attrib['name'])
            else:
                child=c.text
        elif(childName=="variable"):
            if tag=="Call":
                childName="object"
            child=name(c.attrib['name'])
        elif(childName=="num"):
            child=Num(n=int(c.text))
        elif(childName=="true"):
            childName="value"
            child=name('True')
        elif(childName=="false"):
            childName="value"
            child=name('False')
        elif(childName=="nil"):
            childName="value"
            child=name('None')
        elif(childName=="str"):
            childName="value"
            if(hasattr(c,'value')):
                child=name(c.attrib['value']) # Name(id=c.attrib['value'], ctx=Load()) #WTF
            else:
                child=name(id=c.text, ctx=Load())
        elif not childName in kast.types: #i.e.: body=...
            if babies==[] and c.text and c.text.strip()!="":
                child=parseString(childName, c.text)
            elif len(babies)==1 and not childName in ['args','body','values']:#
                child=build(babies[0],tag)  # <<<<<<<<<<<<<<<<
            else:
                child=[build(n,tag) for n in babies] # <<<<<<<
        else:
            child=build(c,tag) # <<<<<<
            if(isinstance(child,list)):
                body=child
            else:
                body.append(child)
        if isinstance(elem,FunctionDef) and childName!="body":
            if(childName=='args'):
                for a in child:
                    elem.args.append(a)
            else: body.append(child)
        else:
            elem.__setattr__(childName, child)
    if len(body)>0:
        elem.body=body
    attribs=dir(elem)
    if not 'lineno' in attribs:
        elem.lineno=0 #hack
    if not 'col_offset' in attribs:
        elem.col_offset=0 #hack
    if(tag=="Call"):
        if get_func_name(elem.func)=='import':
            return do_import(elem.args)
    if(tag=="Class"):
        inClass=False
        classes[elem.name]=elem
    return elem


xmlns=""

def parse_file(fileName):
    global xmlns,folder
    if(not isinstance(fileName,file)):
        fileName=findFile(fileName)
        _file=open(fileName)
    else:
        _file=fileName
        fileName=_file.name
        # folder=_file.name
    if fileName.endswith("rb"):
        kastFile=fileName.replace(".rb",".kast")
        os.system('ruby2kast.rb '+fileName +' > '+ kastFile) # /tmp/
        return parse_file(kastFile)
    elif fileName.endswith("py"):
        # contents=_file.readlines()
        file_ast=compile(_file.read(), fileName, 'exec',ast.PyCF_ONLY_AST) # AAAAHHH!!!
        for clazz in file_ast.body:
            if isinstance(clazz,ClassDef):
                classes[clazz.name]=clazz
        return file_ast
    elif fileName.endswith("yml"):
        from cStringIO import StringIO
        xml =yml2xml(StringIO(),yaml.load(_file)).getvalue()
        fileName = xml # StringIO 'file' ;)
        print(xml)
        root = Xml.fromstring(xml)
    else:
        tree = Xml.parse(fileName)
        root = tree.getroot()

    import re
    if "}" in xmlns:
        xmlns=re.sub("\}.*","}",root.tag)
    # if xmlns!=root.tag: xmlns=xmlns[1:-1]

    my_ast=build(root) # <<<<<<<<<<<< BUILD AST !!!
    # Rewriter().visit(my_ast)
    if not isinstance(my_ast,Module):
        if(isinstance(my_ast,list)):
            my_ast=Module(body=my_ast)
        else:
            my_ast=Module(body=[my_ast])
    my_ast.body.insert(0,Import([name('_global')]))
    # alias
    my_ast.body.insert(0,ImportFrom(module='parser_test_helper',names=[alias('*',None)],level=0)) #asname=None

    my_ast=ast.fix_missing_locations(my_ast)
    modules.append(my_ast)
    for clazz in classes.values():
        fix_missing_self(clazz)

    # x=ast.dump(my_ast, annotate_fields=True, include_attributes=True)
    # x=ast.dump(my_ast, annotate_fields=False, include_attributes=False)
    # print("\n".join(x.split("),")))

    return my_ast

def parse_files(kast_files):
    for f in kast_files:
        parse_file(f)
    for clazz in classes.values():
        fix_missing_self(clazz)
    return modules


# export?
def emit_pyc(code,fileName='output.pyc'):
    import marshal
    import py_compile
    import time
    with open(fileName, 'wb') as fc:
        fc.write('\0\0\0\0')
        py_compile.wr_long(fc, long(time.time()))
        marshal.dump(code, fc)
        fc.flush()
        fc.seek(0, 0)
        fc.write(py_compile.MAGIC)

# correct: Module(body=[For(target=Name(id='i', ctx=Store(), lineno=1, col_offset=4), iter=Call(func=Name(id='range', ctx=Load(), lineno=1, col_offset=9), args=[Num(n=10, lineno=1, col_offset=15)], keywords=[], starargs=None, kwargs=None, lineno=1, col_offset=9), body=[Print(dest=None, values=[Name(id='i', ctx=Load(), lineno=1, col_offset=26)], nl=True, lineno=1, col_offset=20)], orelse=[], lineno=1, col_offset=0)])
# broken!: Module(body=[For(target=Name(id='i', ctx=Store(), lineno=0, col_offset=0), iter=Call(func=Name(id='range', ctx=Load(), lineno=0, col_offset=0), args=[Num(n='10', lineno=0, col_offset=0)], keywords=[], starargs=None, kwargs=None, lineno=0, col_offset=0), body=[Print(dest=None, values=[Name(id='i', ctx=Load(), lineno=0, col_offset=0)], nl=True, lineno=0, col_offset=0)], orelse=[], lineno=0, col_offset=0)])


if __name__ == '__main__':
    import tests.kast_import
