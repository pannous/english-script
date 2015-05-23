# https://docs.python.org/release/2.7.2/library/ast.html#abstract-grammar
# https://docs.python.org/release/3.4.2/library/ast.html#abstract-grammar
# -- ASDL's six builtin types are identifier, int, string, bytes, object, >>> singleton <<< NEW

# Deprecated since version 2.6: The compiler package has been removed in Python 3.   WAAAH!! WTF! egal -> breaks a lot!!

import ast
import json
import os
from ast import *

# todo: consider re-implementing with the visitor pattern, see astor.codegen
class Ignore:
    pass

def good_fields(node):
    all=[]
    for f in node._fields:
        if not hasattr(node,f):
            print("MISSING attribute %s in %s !!!"%(f,node))
            continue
        else:
            all.append(f)
    return all

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

yet_visited={} # maps 'are' global!!
global indent
indent=0


def args(params):
    attributes=""
    for f in dir(params):
        if str(f).startswith("_"): continue
        if str(f)=="body":
            continue
        a=params.__getattribute__(f)
        if isinstance(a,list):a="["+" ".join(map(str,a))+"]"
        if isinstance(a,dict):a=str(a)
        a=map_attribute(f,a)
        if a is Ignore: continue
        # if not a: continue
        attributes=attributes+" %s='%s'"%(f,a)
    # yet_visited[params]=True
    return attributes


def map_attribute(f, a):
    if callable(a):return Ignore
    # if isinstance(a,AST):return Ignore # no: Num, Name
    if isinstance(a,stmt):return Ignore # later through fields
    if isinstance(a,expr):return Ignore
    if isinstance(a,list):return Ignore
    if isinstance(a,Num):a=a.n
    if isinstance(a,Name):a=a.id
    if isinstance(a,expr_context):a=type(a).__name__
    if isinstance(a,operator):a=type(a).__name__
    if isinstance(a,cmpop):a=type(a).__name__
    yet_visited[a]=True
    return a


class Visitor(NodeVisitor):
    # def visit_arguments(self, node):
    #     print("Y")

    def generic_visit(self, node):
        if not node:
            print("ERROR node is None!!")
            return
        global indent
        tag = type(node).__name__
        if (isinstance(node,ast.Print) or tag=='Print'):
            pass
        if isinstance(node,list):
            raise "MUST NOT BE LIST: "+str(node)
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
        attributes=""#+" ".join(dir(node))

        goodfields=good_fields(node)

        for f in dir(node):
            if str(f).startswith("_"): continue
            if str(f)=="body": continue
            # if str(f)=="args": continue
            # if str(f)==("col_offset"): continue
            # if str(f)==("lineno"): continue
            if not hasattr(node,f):
                print("WARNING: MISSING Attribute: %s in %s !!"%(f,node))
                continue
            a=node.__getattribute__(f)
            if isinstance(a,arguments):
                params=args(a)
                if a is Ignore:continue
                yet_visited[a]=True
                attributes=attributes+params
                continue
            a=map_attribute(f,a)
            if a is Ignore:continue
            attributes=attributes+" %s='%s'"%(f,a)
            yet_visited[a]=True
            if f in goodfields:
                goodfields.remove(f)



        # for a in node._attributes:
        #     attribs=attribs+" %s='%s'"%(a,node.__getattribute__(a))
        # for f in node._fields:
        #     a=node.__getattribute__(f)
        #     # if not (isinstance(a,str) or isinstance(a,Num)): continue
        #     if isinstance(a,Num):a=a.n
        #     attribs=attribs+" %s='%s'"%(f,a)
        # print node.body
        print "\t"*indent+ "<%s%s"%(tag,attributes),
        if len(goodfields)==0:# and not isinstance(node,ast.Module):
            print "/>"
            return
        else:
            print ">"

        indent=indent+1
        for f in goodfields:
            if str(f).startswith("_"): continue
            a=node.__getattribute__(f)
            if isinstance(a,expr_context):continue
            if not isinstance(a,list):
                if a in yet_visited:continue
                a=[a]
            if len(a)==0:continue
            print "\t"*(indent)+"<%s>"%(str(f))
            for x in a:
                if x in yet_visited: continue
                if not x:
                    print("WARNING: None in list!")
                    continue
                indent=indent+1
                self.generic_visit(x)
                indent=indent-1
            print "\t"*(indent)+"</%s>"%(str(f))

        NodeVisitor.generic_visit(self, node)#??
        indent=indent-1
        print "\t"*indent+"</%s>"%(tag)


# j=json.dumps(ast.__dict__);
# j=json.dumps(ast);
# print(j)


class RewriteName(NodeTransformer):

    def visit_Name(self, node):
        return copy_location(Subscript(
            value=Name(id='data', ctx=Load()),
            slice=Index(value=Str(s=node.id)),
            ctx=node.ctx
        ), node)


def dump_xml(my_ast):
    Visitor().visit(my_ast)

if __name__ == '__main__':
    import tests.test_ast_writer