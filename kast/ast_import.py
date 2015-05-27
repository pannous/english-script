# -*- coding: utf-8 -*-

# https://github.com/tkf/sexpdata S-expression parser for Python

# https://github.com/dmw/pyxser/blob/master/src/pyxser_serializer.c
# import ast
# from ast import *
import os
import xml.etree.ElementTree as Xml
import re
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
    elif(v.startswith("[") and tag!="Call" and tag!="Assign"): # too much suggar??
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
    if id=="" or id==None:
        return Str(s='')
    if id in const_map:
        id=const_map[id]
    if(tag=="Call"):
        if id in call_map:
            id=call_map[id]
    if id.startswith("@@"):
        return Attribute(Name('_global', Load()), id[2:], ctx)
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
        if(isinstance(arg,Name)):return arg
        return name(arg.s.replace("../","").replace(".rb",".py"))
    def to_plain(arg):
        p=re.sub(".*\/","",arg.id)
        return re.sub("\..*","",p)
    names=map(to_name,files)
    try:
        for file in names:
            parse_file(file.id)
    except Exception as e:
        print(e)
    # return Import(names=names)
    modules = ",".join(map(to_plain, names))
    return ImportFrom(module=modules,names=[alias('*',None)],level=0)


def flatList(l):
    if not isinstance(l,list):return [l]
    if len(l)==0: return l
    if len(l)==1 and isinstance(l[0],list): return l[0]
    return l


def to_s(x):
    if isinstance(x, Xml.Element):
        if 'name' in x.attrib: return x.attrib['name']
        else: return str(x)+"_TODO" # TODO
    if isinstance(x,Str):return "'"+x.s+"'"
    if isinstance(x,Num):return x.n
    if isinstance(x,Name):return x.id
    return x

def build(node,parent=None):
    global xmlns,inClass
    tag=node.tag.replace(xmlns,"")
    children = node.getchildren()
    _name_ = None
    if 'name' in node.attrib: _name_= node.attrib['name']
    if(tag=="name"):
        return node.text # Name(id=node.text)
    elif(tag=="num"):
        return Num(n=int(node.text))
    elif(tag=="Num"):
        return Num(n=int(node.attrib["value"]))
    elif(tag=="If"):
        test = build(children[0])
        body = [build(children[1])]
        if len(children)>2:
            orelse=flatList(build(children[2]))
        else:
            orelse=[]
        return If(test=test,body=body,orelse=orelse)
    elif(tag=="True"):
        return name('True') #WTF
    elif(tag=="False"):
        return name('False') #WTF
    elif(tag=="Nil"):
        return name('None') #WTF
    elif(tag=="String"):
        xs=map(build, children)
        def bin_add(a,b):
            return BinOp(a, Add(),b)
        xss=reduce(bin_add, xs[1:], xs[0]) # nice, Karsten++
        return xss
    elif(tag=="Str"):
        if(hasattr(node,'value')): return Str(s=node.attrib['value'])
        else:return Str(s=node.text)
    # elif(tag=="Call" and parent=="Assign"):
    #     tag="Variable" #VCall in ruby
    elif(tag=="Argument"):
        if(len(children)>0):
            return build(children[0])
        return name(_name_)
    elif tag=="Call" and _name_=='[]':
        value=name(to_s(children[0]))
        _slice=map(build,children[1].getchildren())
        _slice=to_s(_slice[0])
        return Subscript(value=value,slice=_slice,ctx=Load())
    elif tag=="Assign":
        if not _name_ : return map(build,children) # ruby lamda etc
        # if parent=="For":
        #     return name(_name_)
        if _name_[-1]=='=': _name_=_name_[0:-1] # ruby a.b=c name:'b='
        value = build(children[0])
        if _name_ =='[]':
            value=name(children[0].attrib['name'])
            _slice=build(children[1].getchildren()[0]) # RUBY WTF
            value2=map(build,children[1].getchildren()[1:])
            return Assign(targets=[Subscript(value=value,slice=_slice,ctx=Load())],value=value2)
        if len(children)==2:
            value2 =map( build,children[1].getchildren())
            if len(value2)==1: value2=value2[0]
            return Assign(targets=[Attribute(attr=_name_,value=value)],value=value2)
        return Assign(targets=[name(_name_)],value=value)
    elif(tag=="Const"):
        return name(_name_)
    elif(tag=="Variable" or tag=="variable"):
        return name(_name_)# todo: CALL if in block!
        # return Name(id=node.attrib['value'], ctx=Load()) #WTF
    elif tag=="Body":
        return map(build, children)
    elif(tag=='Arguments'): # not AST node
        args=map(build, children)
        return arguments(args=args,defaults=[],vararg=None,kwarg=None)
    elif(tag=='Array'): # not AST node
        args=map(build, children)
        return List(elts=args,ctx=Load())
    elif tag=="Alias":
        return Assign(targets=[build(children[0])],value=build(children[1]))
    elif tag=="Args":
        return map(build, children)
    elif tag=="Or":
        return Or(body=map(build, children))
    elif tag=="And":
        return And(body=map(build, children))

    elif tag=="Block":
        return map(build, children)
    elif(tag=='Hash'): # not AST node
        args=map(build, children)
        a=args[0].elts
        hash=dict(zip(a[0::2], a[1::2])) # nice
        return Dict(keys=hash.keys(),values=hash.values())


    if not tag in kast.types:
        print("UNKNOWN tag %s"%(tag))
        if(len(children)==0):return
    construct= kast.types[tag]
    if callable(construct):
        elem=construct()
    else:elem=construct

    # 'data'
    if(tag=="Call"):
        pass #debug
    if(tag=="Class"):
        inClass=True
    elif(tag=='Arguments'):
        pass
    elif tag=="Self":
        return elem
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
        if(isinstance(v,str) and not isinstance(elem,Name)) and tag!="Method" :
            v=parseString(a,v,tag)
        if a.endswith("s") and not isinstance(v,list):v=[v]
        elem.__setattr__(a,v)

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
                childName="object"
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
            if 'value' in c.attrib:
                child=Num(n=int(c.attrib['value']))
            else:
                child=Num(n=int(c.text))
        # elif childName=="default":
        #     child=build(c)
        elif(childName=="true"):
            childName="value"
            child=name('True')
        elif(childName=="false"):
            childName="value"
            child=name('False')
        elif(childName=="nil"):
            childName="value"
            child=name('None')
        # elif(childName=="array"):
        #     body.append(child)
        elif(childName=="str"): # NAME!!?? REALLY??
            childName="value"
            if(hasattr(c,'value')):
                child=Str(c.attrib['value']) # Name(id=c.attrib['value'], ctx=Load()) #WTF
            else:
                child=Str(id=c.text)
        elif not childName in kast.types: #i.e.: body=...
            if babies==[] and c.text and c.text.strip()!="":
                child=parseString(childName, c.text)
            elif len(babies)==1 and not childName in ['args','body','values']:#
                child=build(babies[0],tag)  # <<<<<<<<<<<<<<<<
            else:
                child=[build(n,tag) for n in babies] # <<<<<<<
            if childName in ["array"]: body.append(child)
        else:
            child=build(c,tag) # <<<<<<
            if(isinstance(child,list)):
                body=child
            else:
                if not tag=="For": # ...
                    body.append(child)
        if isinstance(elem,FunctionDef) and childName!="body":
            if(childName=='args'):
                for a in child:
                    # elem.args.append(a)
                    elem.args.args.append(a)
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
        if isinstance(elem,ClassDef):
            classes[elem.name]=elem
    elif tag=="Super":
        elem.func=name('super')
    elif tag=="For":
        elem.target=elem.target.targets[0]
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
    # my_ast.body.insert(0,ImportFrom(module='parser_test_helper',names=[alias('*',None)],level=0)) #asname=None

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
