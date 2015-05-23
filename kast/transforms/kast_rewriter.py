__author__ = 'me'
from ast import *

class Rewriter(NodeTransformer):
    def visit_Name(self, node):
        if node.id.startswith("@"):
            return copy_location(Attribute(value=Name(id='self',ctx=Load()),attr=node.id,ctx=Load()), node)

def get_name(method):
   return method.name

def get_func_name(method):
    if isinstance(method,Name):
       return method.id
    else:
       print("Attribute "+str(method))

global names
class SelfFixer(NodeVisitor):
    def visit_Call(self, node):
        method =get_func_name(node.func)
        if method in names:
            print("self."+method)
            node.func=Attribute(value=Name(id='self',ctx=Load()),attr=method,ctx=Load())

    # def visit_FunctionDef(self,node):
    #     if len(node.body)>0:
    #         last_statement = node.body[-1]
    #         if not isinstance(last_statement,Return):
    #              node.body[-1] =Return(last_statement)

def fix_missing_self(elem):
    global names
    names=map(get_name,[c for c in elem.body if isinstance(c,ClassDef)])
    SelfFixer().visit(elem)
