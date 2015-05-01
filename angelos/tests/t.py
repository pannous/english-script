# -*- coding: utf-8 -*-
# def _ß(): #NOPE :(
#     print('h')
#
# _ß()
from pprint import pprint

import inspect
# >>> dir(inspect)
# ['ArgInfo', 'ArgSpec', 'Arguments', 'Attribute', 'BlockFinder', 'CO_GENERATOR', 'CO_NESTED', 'CO_NEWLOCALS', 'CO_NOFREE', 'CO_OPTIMIZED', 'CO_VARARGS', 'CO_VARKEYWORDS', 'EndOfBlock', 'ModuleInfo', 'TPFLAGS_IS_ABSTRACT', 'Traceback', '__author__', '__builtins__', '__date__', '__doc__', '__file__', '__name__', '__package__', '_filesbymodname', '_searchbases', 'attrgetter', 'classify_class_attrs', 'cleandoc', 'currentframe', 'dis', 'findsource', 'formatargspec', 'formatargvalues', 'getabsfile', 'getargs', 'getargspec', 'getargvalues', 'getblock', 'getcallargs', 'getclasstree', 'getcomments', 'getdoc', 'getfile', 'getframeinfo', 'getinnerframes', 'getlineno', 'getmembers', 'getmodule', 'getmoduleinfo', 'getmodulename', 'getmro', 'getouterframes', 'getsource', 'getsourcefile', 'getsourcelines', 'imp', 'indentsize', 'isabstract', 'isbuiltin', 'isclass', 'iscode', 'isdatadescriptor', 'isframe', 'isfunction', 'isgenerator', 'isgeneratorfunction', 'isgetsetdescriptor', 'ismemberdescriptor', 'ismethod', 'ismethoddescriptor', 'ismodule', 'isroutine', 'istraceback', 'joinseq', 'linecache', 'modulesbyfile', 'namedtuple', 'os', 're', 'stack', 'string', 'strseq', 'sys', 'tokenize', 'trace', 'types', 'walktree']

# import t_vars.x
from t_vars import x #needs no global !
print(x)
def yay():
    global x
    x=8 #still needs global

yay()
print(x)


class Foo():
    global _p,p #like static class variables  @@p in ruby
    p='global var on class init' #overwritten by __init__

    def fun(self):
        pass # no LOL
    #
    # global fun
    # def fun(self):
    #     print("NAH")
    # global fun #SyntaxWarning: name 'fun' is assigned to before global declaration
    #

    def global_p(self):
        return p

    def instance_p(self):
        return self.p

    def pp(x): # name self->x egal!!
        return p

    def __init__(self):
        global p
        p='global var'
        self.p='instance self'   # instance!

    def setP(self, param):
        global p
        p=param
        self.p=param


Foo.p='class attribute' # HAS NO EFFECT ON INNER p !!!!!!!!!
foo = Foo()
print(Foo.p) #class attribute
print(foo.p) #instance self
print(foo.global_p())# global var
print(foo.instance_p()) #instance self
foo.p='instance var override'
print(foo.p)
print(foo.global_p())
print(foo.instance_p())
print(Foo.global_p(0)) # Call instance methods as if they we are class functions!!!
foo2 = Foo()
foo2.setP('set globally')
print(foo.global_p())
quit()

# from Foo import p
# print(p)
# print(p) # NO -> OK

def ma(x):
    print(x)

ma(x=9)
# ma(y=9) NO

# try: help('modules')
# except: pass
def a():
    return 7

def b():
    return c()

def c():
    return a()

print(b())
quit()

class t():
    # lines
    def lines(self):pass

t.lines.x=7
print(t.lines.x)# WOW the hack!

def interrogate(item):
    """Print useful information about item."""
    if hasattr(item, '__name__'):
     print( "NAME:    ", item.__name__)
    if hasattr(item, '__class__'):
     print("CLASS:   ", item.__class__.__name__)
    print ("ID:      ", id(item))
    print ("TYPE:    ", type(item))
    print ("VALUE:   ", repr(item))
    print ("CALLABLE: ", end='')
    if callable(item):
     print("Yes")
    else:
     print("No")
    if hasattr(item, '__doc__'):
        doc = getattr(item, '__doc__')
        if(doc):
            doc = doc.strip()   # Remove leading/trailing whitespace.
            firstline = doc.split('\n')[0]
            print("DOC:     ", firstline)


def inspect(item):
    interrogate(item)
    all={}
    for attr in dir(item):
        m=getattr(item,attr)
        if callable(m):
            try:m=m()
            except:'so?'
        all[attr]=m
    print(all)
    return all

class Pointer(int):
    def __str__(self):
        return '2'

print(Pointer(1))
assert str(Pointer(1))=='2'
# assert Pointer(1)=='2' # NO!
# try:
#     assert Pointer(1)=='2'
# except AssertionError as e:
#     # print(inspect.getsourcelines(e))
#     print(e.__cause__)
#     print(e.__context__)
    # pprint(inspect(e))
    # line=e.__traceback__.tb_lineno
    # print(inspect.getfile(e))
    # inspect.getsourcelines(
    # from dill.source import getsource
    # pprint(inspect(e.__traceback__.tb_frame))

    # help(e)

quit()
x='hi'
# y=type(x)
# y.z=7 #TypeError: can't set attributes of built-in/extension type
from forbiddenfruit import curse,reverse
# Since Forbidden Fruit is fundamentally dependent on the C API,
# this library won't work on other python implementations,
# such as Jython, PyPy, etc. I might add support for PyPy in the future,

def words_of_wisdom(self):
    return self * "blah "

# print(words_of_wisdom)
# print(type(words_of_wisdom))
# print(classmethod(words_of_wisdom))
curse(str, "z", 7)
print(x.z) # YAY !!! retroactively gifts attribute to all instances
reverse(str, "z")
print(x.z) # NOO:( don't work!!
a="dfs"
print(a.z) # NOO:(



curse(int, "words_of_wisdom", words_of_wisdom)
assert (2).words_of_wisdom() == "blah blah "
reverse(int, "words_of_wisdom")
# assert (3).words_of_wisdom() != "blah blah blah " #NOO
assert (2).words_of_wisdom() != "blah blah "

curse(str, "hello", classmethod(lambda x:'blah'))
assert str.hello() == "blah"

# print('ok'.upper())
# reverse(str, "upper")
# print('nooooooo'.upper()) # AttributeError: 'str' object has no attribute 'upper' OR C_R_A_S_H if cached by calling before!!!
