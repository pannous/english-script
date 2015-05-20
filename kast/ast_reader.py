# -*- coding: utf-8 -*-

# https://github.com/tkf/sexpdata S-expression parser for Python

# https://github.com/dmw/pyxser/blob/master/src/pyxser_serializer.c
# import ast
# from ast import *
from kast import *
import io
import xml.etree.ElementTree as Xml
import kast

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


def parseString(a, v):
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
        return node.text # Name(id=node.text)
    elif(tag=="num"):
        return Num(n=int(node.text))
    elif(tag=="If"):
        test = build(node._children[0])
        body = [build(n) for n in node._children[1:]]
        return If(test=test,body=body,orelse=[])
    elif(tag=="True"):
        return Name(id='True', ctx=Load()) #WTF
    elif(tag=="False"):
        return Name(id='False', ctx=Load()) #WTF
    elif(tag=="Str"):
        if(hasattr(node,'value')): return Str(s=node.attrib['value'])
        else:return Str(s=node.text)
    elif(tag=="Const"):
        return Name(id=node.attrib['name'],ctx=Load())
    elif(tag=="Variable" or tag=="variable"):
        return Name(id=node.attrib['name'],ctx=Load())# todo: CALL if in block!
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
        print("debug Class!")
    if(tag=="Method"): # FunctionDef
        print("debug Method!")

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
            v=parseString(a,v)
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
            else:
                child=Name(id=c.attrib['name'], ctx=Load())
        elif(childName=="name"):
            if "name" in c.attrib:
                child=c.attrib['name']
                # child=parseString(childName,c.attrib['name'])
            else:
                child=c.text
        elif(childName=="variable"):
            if tag=="Call":
                childName="object"
                child=c.attrib['name']
            else:
                child=Name(id=c.attrib['name'], ctx=Load())
        elif(childName=="num"):
            child=Num(n=int(c.text))
        elif(childName=="true"):
            childName="value"
            child=Name(id='True', ctx=Load()) #WTF
        elif(childName=="false"):
            childName="value"
            child=Name(id='False', ctx=Load()) #WTF
        elif(childName=="nil"):
            childName="value"
            child=Name(id='None', ctx=Load()) #WTF
        elif(childName=="str"):
            childName="value"
            if(hasattr(c,'value')):
                child=Name(id=c.attrib['value'], ctx=Load()) #WTF
            else:
                child=Name(id=c.text, ctx=Load())
        elif(childName=="num"):
            child=Num(n=int(c.text))
        elif not childName in kast.types: #i.e.: body=...
            if babies==[] and c.text and c.text.strip()!="":
                child=parseString(childName, c.text)
            elif len(babies)==1 and not childName in ['args','body','values']:#
                child=build(babies[0])
            else:
                child=[build(n) for n in babies]
                # print("Got block")
                # print(child)
        else:
            child=build(c)
            if(isinstance(child,list)):
                body=child
            else:
                body.append(child)
        if isinstance(elem,FunctionDef) and childName!="body":
            # if(child==[]):return elem # default []
            elem.args.__setattr__(childName, child)
        else:
            elem.__setattr__(childName, child)
    if len(body)>0:
        elem.body=body
    attribs=dir(elem)
    if not 'lineno' in attribs:
        elem.lineno=0 #hack
    if not 'col_offset' in attribs:
        elem.col_offset=0 #hack
    return elem

xmlns=""
def parse_file(kast_file):
    global xmlns
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
    if "}" in xmlns:
        xmlns=re.sub("\}.*","}",root.tag)
    # if xmlns!=root.tag: xmlns=xmlns[1:-1]

    my_ast=build(root)
    if not isinstance(my_ast,Module):
        if(isinstance(my_ast,list)):
            my_ast=Module(body=my_ast)
        else:
            my_ast=Module(body=[my_ast])

    my_ast=ast.fix_missing_locations(my_ast)
    # x=ast.dump(my_ast, annotate_fields=True, include_attributes=True)
    x=ast.dump(my_ast, annotate_fields=False, include_attributes=False)
    print("\n".join(x.split("),")))

    return my_ast


# correct: Module(body=[For(target=Name(id='i', ctx=Store(), lineno=1, col_offset=4), iter=Call(func=Name(id='range', ctx=Load(), lineno=1, col_offset=9), args=[Num(n=10, lineno=1, col_offset=15)], keywords=[], starargs=None, kwargs=None, lineno=1, col_offset=9), body=[Print(dest=None, values=[Name(id='i', ctx=Load(), lineno=1, col_offset=26)], nl=True, lineno=1, col_offset=20)], orelse=[], lineno=1, col_offset=0)])
# broken!: Module(body=[For(target=Name(id='i', ctx=Store(), lineno=0, col_offset=0), iter=Call(func=Name(id='range', ctx=Load(), lineno=0, col_offset=0), args=[Num(n='10', lineno=0, col_offset=0)], keywords=[], starargs=None, kwargs=None, lineno=0, col_offset=0), body=[Print(dest=None, values=[Name(id='i', ctx=Load(), lineno=0, col_offset=0)], nl=True, lineno=0, col_offset=0)], orelse=[], lineno=0, col_offset=0)])
def load(file):
    return open(file,'rb').read()
    # return "\n".join(open(file).readlines())




if __name__ == '__main__':
    import tests.kast_import
