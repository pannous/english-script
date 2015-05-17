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

def good_fields(node):
    # if not node: return []
    more=[]
    all=list(node._fields)+more
    # if isinstance(node,ast.Print):
    #     more=['values']
    return all
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
global indent
indent=0
class Visitor(NodeVisitor):
    def generic_visit(self, node):
        if not node:
            print("ERROR node is None!!")
            return
        global indent
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
            if callable(a):continue
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
        print "\t"*indent+ "<%s%s>"%(tag,attribs)
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
            print "\t"*indent+"<%s>"%(str(f))
            indent=indent+1
            self.generic_visit(a)
            indent=indent-1
            print "\t"*indent+"</%s>"%(str(f))

        for f in goodfields:#
            if str(f).startswith("_"): continue
            # if str(f).startswith("body"): continue
            a=node.__getattribute__(f)
            if not isinstance(a,list):continue
            if len(a)==0:continue
            print "\t"*indent+"<%s>"%(str(f))
            for x in a:
                if not x:
                    print("WARNING: None in list!")
                    continue
                indent=indent+1
                self.generic_visit(x)
                indent=indent-1
            print "\t"*indent+"</%s>"%(str(f))

        indent=indent+1
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