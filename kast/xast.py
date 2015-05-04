# https://github.com/dmw/pyxser/blob/master/src/pyxser_serializer.c
import kast
from kast import *

import xml.etree.ElementTree as ET
# from lxml import etree
# parser = etree.XMLParser(dtd_validation=True)
# doc = etree.parse(xast_file)
# xmlschema = etree.XMLSchema(etree.parse("kast.xsd"))
# xmlschema.validate(doc)

# xast_file='test.xast'
xast_file='test.xast'
xast_file='test_full.xast'
# ast_file='demo.pyast'
xast_file='test.kast.xml'
schema_file='kast.xsd'

tree = ET.parse(xast_file)
root = tree.getroot()

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
        elem.__setattr__(a,v)

    children=node.getchildren()
    for c in children:
        if not c.tag in kast.types: #i.e.: body=...
            babies=c.getchildren()
            if len(babies)==1 and not c.tag in ['args','body','values']:#
                elem.__setattr__(c.tag,build(babies[0]))
            else:
                elem.__setattr__(c.tag,[build(n) for n in babies])
        else:
            elem.body=build(c)
        # slot=c.tag
        # elem.slot=build(c)


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


def load(file):
    return open(file,'rb').read()
    # return "\n".join(open(file).readlines())


my_ast=eval(load('../demo.kast'))
my_ast2=Module(body=[
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

# GOOD: Module(body=[For(target=Name(id='i', ctx=Store(), lineno=1, col_offset=4), iter=Call(func=Name(id='range', ctx=Load(), lineno=1, col_offset=9), args=[Num(n=10, lineno=1, col_offset=15)], keywords=[], starargs=None, kwargs=None, lineno=1, col_offset=9), body=[Print(dest=None, values=[Name(id='i', ctx=Load(), lineno=1, col_offset=26)], nl=True, lineno=1, col_offset=20)], orelse=[], lineno=1, col_offset=0)])
# BAAD: Module(body=[For(target=Name(id='i', ctx=Store(), lineno=1, col_offset=4), iter=Call(func=Name(id='range', ctx=Load(), lineno=1, col_offset=9), args=[Num(n=10, lineno=1, col_offset=15)], keywords=[], starargs=None, kwargs=None, lineno=1, col_offset=9), body=[Print(dest=None, values=Name(id='i', ctx=Load(), lineno=1, col_offset=26), nl=True, lineno=1, col_offset=20)], orelse=[], lineno=1, col_offset=0)])


my_ast=ast.fix_missing_locations(my_ast)

x=ast.dump(my_ast, annotate_fields=True, include_attributes=True)
print(x)
import codegen
print(codegen.to_source(my_ast))

code=compile(my_ast, xast_file, 'exec')#flags=None, dont_inherit=None
# TypeError: required field 'lineno' missing from stmt
# no, what you actually mean is "tuple is not a statement" LOL WTF ;)

exec(code)

