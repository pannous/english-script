# -*- coding: utf-8 -*-
# def _ß(): #NOPE :(
#     print('h')
#
# _ß()
from pprint import pprint

import inspect
import token
import traceback

# >>> dir(inspect)
# ['ArgInfo', 'ArgSpec', 'Arguments', 'Attribute', 'BlockFinder', 'CO_GENERATOR', 'CO_NESTED', 'CO_NEWLOCALS', 'CO_NOFREE', 'CO_OPTIMIZED', 'CO_VARARGS', 'CO_VARKEYWORDS', 'EndOfBlock', 'ModuleInfo', 'TPFLAGS_IS_ABSTRACT', 'Traceback', '__author__', '__builtins__', '__date__', '__doc__', '__file__', '__name__', '__package__', '_filesbymodname', '_searchbases', 'attrgetter', 'classify_class_attrs', 'cleandoc', 'currentframe', 'dis', 'findsource', 'formatargspec', 'formatargvalues', 'getabsfile', 'getargs', 'getargspec', 'getargvalues', 'getblock', 'getcallargs', 'getclasstree', 'getcomments', 'getdoc', 'getfile', 'getframeinfo', 'getinnerframes', 'getlineno', 'getmembers', 'getmodule', 'getmoduleinfo', 'getmodulename', 'getmro', 'getouterframes', 'getsource', 'getsourcefile', 'getsourcelines', 'imp', 'indentsize', 'isabstract', 'isbuiltin', 'isclass', 'iscode', 'isdatadescriptor', 'isframe', 'isfunction', 'isgenerator', 'isgeneratorfunction', 'isgetsetdescriptor', 'ismemberdescriptor', 'ismethod', 'ismethoddescriptor', 'ismodule', 'isroutine', 'istraceback', 'joinseq', 'linecache', 'modulesbyfile', 'namedtuple', 'os', 're', 'stack', 'string', 'strseq', 'sys', 'tokenize', 'trace', 'types', 'walktree']

# import t_vars.x
# from t_vars import x #needs no global !
import unittest


class Tokenizer(unittest.TestCase):

    def test_tokenize(self):
        # to do it yourself also see: https://github.com/davidmcclure/tokenizer/blob/master/tokenizer.py ?
        # builtin: https://docs.python.org/3/library/tokenize.html#module-tokenize
        from tokenize import tokenize, untokenize, NUMBER, STRING, NAME, OP
        from io import BytesIO
        s="to kick a bug:   run(away)!!\n/3.4?>3 # ['ArgInfo', 'ArgSpec', 'Arguments', 'Attribute',"
        tokenize(BytesIO(s.encode('utf-8')).readline,self.tokeneater) # tokenize the string

    global lastLine
    lastLine=""
    def tokeneater(self,ttype, tokenn, srow_scol, erow_ecol, line):
        global lastLine
        srow, scol = srow_scol
        erow, ecol = erow_ecol # tuple
        if lastLine!= line :
            print line
            lastLine=line
        print "%d,%d-%d,%d:\t%d=%s\t%s" % \
            (srow, scol, erow, ecol,ttype, token.tok_name[ttype], repr(tokenn))
        token.INDENT # not available here :(
        token.DEDENT #!!
         # for toknum, tokval, _, _, _  in g:
         #    print(toknum,tokval)

# The exact token type names can be displayed using the -e option:
# $ python -m tokenize -e hello.py
# 0,0-0,0:            ENCODING       'utf-8'
# 1,0-1,3:            NAME           'def'
# 1,4-1,13:           NAME           'say_hello'
# 1,13-1,14:          LPAR           '('
# 1,14-1,15:          RPAR           ')'
# 1,15-1,16:          COLON          ':'


class IgnoreException(Exception):
    pass

class PythonTest(unittest.TestCase):

    def do_raise(self):
        try:
            1/0
        except PythonTest as e:
            pass #ignore

    def inbetween(self):

        try:
            self.do_raise()
        except IgnoreException  as e:
            raise e

    def test_exception_fallthrough(self):
        try:
            # self.do_raise()
            self.inbetween()
        except Exception as e:
            print(e)
            # traceback.print_stack() # backtrace
            raise e #loses old stack!!!

            # print(e.args)
            # help(e)
            # pass #ignore




class GlobalTest():
    global _p,p #like static class variables  @@p in ruby
    p='global var on class init' #overwritten by __init__

    def fun(self):
        pass # no LOL

    def yo(self):
        global x
        x=7
        print(x)
        def yay():
            global x
            x=8 #still needs global

        yay()
        print(x)

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

    def test_all(self):
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
        # quit()

    # from Foo import p
    # print(p)
    # print(p) # NO -> OK

    def ma(x):
        print(x)

    ma(x=9)
    # ma(y=9) NO

    # try: help('modules')
    # except: pass
    def a(self):
        return 7

    def b(self):
        return self.c()

    def c(self):
        return self.a()

    # print(b())
    # quit()

    class t():
        # lines
        def lines(self):pass
    #
    # t.lines.x=7
    # print(t.lines.x)# WOW the hack!

def interrogate(item):
    """Print useful information about item."""
    if hasattr(item, '__name__'):
     print( "NAME:    ", item.__name__)
    if hasattr(item, '__class__'):
     print("CLASS:   ", item.__class__.__name__)
    print ("ID:      ", id(item))
    print ("TYPE:    ", type(item))
    print ("VALUE:   ", repr(item))
    print ("CALLABLE: ", callable(item))
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

class forbiddenfruitExtendBuiltinsTest():
    def test(self):
        # quit()
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
