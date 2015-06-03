import unittest
import angle
import english_parser
import power_parser
import test._global
from test import _global
import the

global parser
from nodes import *
from extensions import *

parser = english_parser#.EnglishParser()

ENV = {'APPLE': True}
methods = {}
functions = {}
# variables = {}
variableValues = {}
variableTypes = {}
emit=False

def contains(a,b):
    return a in b or b in a

def bigger_than(a, b):
    return a > b


def less_than(a, b):
    return a < b


def kind(x):
    type(x)


def body(param):
    english_parser.rooty()


def root(param):
    english_parser.rooty()



def interpretation():
    pass


def fix_encoding(x):
    return x


def read(x):
    return open(x) or x.read()


def count(x):
    len(x)


def p(x):
    print(x)


def last_result():
    return the.result


def parse_tree():
    pass


def puts(x):
    print(x)


def assert_result_emitted(a, b, bla=None):
    pass
    # emit(


def assert_result_is(a, b, bla=None):
    x=parse(a)
    if bla:
        assert x==b, "%s %s SOULD EQUAL %s BUT WAS %s"%(bla,a,b,x)
    else:
        assert x==b, "%s SOULD EQUAL %s BUT WAS %s"%(a,b,x)


def parse_file(x):
    english_parser.parse(x)


def assert_equals(a, b, bla=None):
    assert a==b, "%s SHOULD BE %s   %s"%(a,b,bla)


def assert_equal(a, b, bla=None):
    assert a==b, "%s SHOULD BE %s   %s"%(a,b,bla)

#
# def do_assert(a, bla=None):
#     assert a

class SkippingTest(Exception):
    pass

def skip(me=0):
    raise SkippingTest()


def assert_has_error(x):
    try:
        x()
    except:
        print("OK, error")


def assert_has_no_error(x):
    parse(x)


def sleep(s):
    pass


def parse(s):
    r= english_parser.parse(s).result
    variables.update(the.variables)
    return r


def init(str):
    english_parser.init(str)
    # parser.init(str)


def result():
    raise the.result


def equals(a, b):
    return a == b


def name(x):
    return x


def copy_variables():
    global variableValues
    variable_keys = variables.keys()
    for name in variable_keys:
        v_ = variables[name]
        the.variableValues.update(variables)
        the.variables[name]=Variable(name=name,value=v_)#,type=type(variables[v]))
        variableValues.update(variables)
        variables[name]=Variable(name=name,value=v_)#,type=type(variables[v]))


class ParserBaseTest(unittest.TestCase):

    global p,_p,parser,_parser
    parser=p= english_parser#.EnglishParser() # Module, lol hack
    _parser=_p= english_parser#.EnglishParser
        # p=Parser() # CANT BE ASSIGNED without double global
        # global p
        # p=Parser() # CAN BE ASSIGNED!!!
        # self._p=_p # generator
        # self.p=p   # instance!
        # self._p=Parser # generator
        # self.p=Parser()#  fresh  instance!

    parser=property(lambda :p,0)

    def setUp(self):
        the._verbose=True # False
        if not angle.use_tree:
            self.parser.do_interpret()

    @classmethod
    def setUpClass(cls):
        pass # reserved for expensive environment one time set up

    def test_true(self):
        assert True
    # def test_globals(self):
    #     self.assertIsInstance(p,Parser)

    def __getattr__(self, name):
        if name=='parser':
            return p
        # ruby method_missing !!!
        if name in dir(parser):
            method = getattr(parser, name)  # NOT __getattribute__(name)!!!!
            if callable(method):
                return method()
            else:
                return parser.__getattribute__(name)
        else:
            raise Exception( "NO SUCH ATTRIBUTE " + name)

    # return lambda value: self.all().filter(field, value)

    def parse(self, str):
        return parser.parse(str).result


    def initialize(self, args):
        if ENV['TEST_SUITE']:
            _global.verbose = False
        if _global.raking:
            _global.emit = False
        self.parser = english_parser.EnglishParser()
        super(args)

    def assert_has_no_error(self, x):
        parse(x)
        print(x+(' parses OK'))

    def assert_has_error(self, x, block):
        try:
                parse(x)
                raise "SHOULD THROW"
        except Exception as e:
            puts("OK")


    def assert_result_is(self, x, r):
        assert_equals(parse(x), parse(r))
        assert_equals(parse(x), parse(r))

    def assert_equals(self, a, b):
        if ((a.equals(b) or equals(b.to_s(), a.to_s())) or equals(+('"', +(b.to_s())), a.to_s())):
            print((((('TEST PASSED! ' + self.parser.original_string()) + '    ') + a) + ' == ') + b)
        else:
            # print(filter_stack(caller()))
            assert(a==b, ((a + ' should equal ') + b))
        if ((a.equals(b) or equals(b.to_s(), a.to_s())) or equals(+('"', +(b.to_s())), a.to_s())):
            print(((((('TEST PASSED! ' + self.parser.original_string()) + '    ') + a) + ' == ') + b))
        else:
            # print(filter_stack(caller()))
            assert(a==b, ((a + ' should equal ') + b))
    # alias_method('original_assert', 'assert')

    def do_assert(self, x,msg=None, block=None):
        copy_variables()
        if not msg: msg=x
        ok=False
        if x == True:
            print('TEST PASSED! ' + str(msg))
            return True
        if callable(msg):
            msg = msg.call()
        if block:
            msg = (msg or self.parser.to_source(block))
        if x==False and block:
            x = block()
        if x==False:
            assert False, ((x + ' NOT PASSING: ') +str(  msg))
        if isinstance(x,str):
            print(('Testing ' + x))
            init(x)
            if emit:
                self.parser.dont_interpret()
            ok = self.parser.condition()
            if emit:
                ok = parser.emit(None, ok),
            if ok==False:
                assert False, 'NOT PASSING: ' + str( msg)
        print 'TEST PASSED!  ' + str( msg) + ' \t VALUE '+str(ok)

    # def NOmethod_missing(self, sym, args, block):
    #     syms = sym.to_s()
    #     if self.parser and contains(sym, self.parser.methods()):
    #         [
    #         if equals(0, args.len()):
    #             x = maybe(),
    #         if equals(1, args.len()):
    #             x = maybe(),
    #         if bigger_than(0, args.len()):
    #             x = maybe(),
    #         return x, ]
    #     super([sym], args, [sym], args)

    def init(self, string):
        self.parser.allow_rollback((-1))
        self.parser.init(string)

    def variables(self):
        self.parser.variables()

    def variableValues(self):
        self.parser.variableValues()

    def functions(self):
        self.parser.methods()

    def methods(self):
        self.parser.methods()

    def interpretation(self):
        self.parser.interpretation()

    def result(self):
        self.parser.result()

    def parse_file(self, file):
        parse(IO.read(file))

    def parse_tree(self, x):
        if isinstance(x,str):
            return x
        self.parser.dont_interpret()
        interpretation = self.parser.parse(x)
        self.parser.full_tree()
        if _global.emit:
            return parser.emit(interpretation, interpretation.root())
        else:
            return interpretation.evaluate()

    # def emit(self, interpretation, root):
    #     from c-emitter import *
    #     emit(interpretation, {'run': True, }, NativeCEmitter())

    def parse(self, x):
        if interpret:
            self.parser.do_interpret()
        if (isinstance(x,str), ):
            return x
        if _global.emit:
            self.result = parse_tree(x)
        else:
            self.result = self.parser.parse(x)
            self.result = result(self.parser.interpretation(), )
        self.variables = variables(self.parser.interpretation(), )
        self.variableValues = self.variables.map_values()
        if self.result.equals('false'):
            self.result = False
        if self.result.equals('true'):
            self.result = True
        self.result

    def variableTypes(self, v):
        type(variables[v], )
        type(variables[v], )

    # def verbose(self):
    #     if _global.raking:
    #         return None
    #     self.parser.verbose = True

# class Function:
#     pass
# class Argument:
#     pass
# class Variable:
#     pass
# class Quote:
#     pass
