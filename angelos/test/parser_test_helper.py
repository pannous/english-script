global parser
parser=EnglishParser()

ENV={'APPLE':True}
methods={}
functions={}
variables={}
variableValues={}
variableTypes={}
def bigger_than(a,b):
    return a>b
def less_than(a,b):
    return a<b
def kind(x):
    type(x)
def body(param):
    pass
def root(param):
    pass
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
    pass
def parse_tree():
    pass
def puts(x):
    print(x)
def assert_result_emitted(a,b,bla=None):
        pass
def assert_result_is(a,b,bla=None):
    pass
def parse_file(x):
    pass
def assert_equals(a,b,bla=None):
    pass

def assert_equal(a,b,bla=None):
    pass

def do_assert(a,bla=None):
    pass

def skip():
    pass

def assert_has_error(x):
    pass

def assert_has_no_error(x):
    pass

def sleep(s):
    pass

def parse():
    raise "NOOO"

def init():
    raise "NOOO"

def result():
    raise "NOOO"

def equals(a,b):
    return a==b

def name(x):
    return x

class ParserBaseTest():
    def __getattr__(self, name):
     # ruby method_missing !!!
        if name in dir(parser):
            method = getattr(parser, name) # NOT __getattribute__(name)!!!!
            if callable(method):
                return method()
            else:
                return parser.__getattribute__(name)
        else: raise "NO SUCH ATTRIBUTE "+name
    # return lambda value: self.all().filter(field, value)

  def parse(self,str):
    return parser.parse(str)

class Function:
    pass
class Argument:
    pass
class Variable:
    pass
class Quote:
    pass
class File:
    @classmethod
    def open(x):return open(x)
    @classmethod
    def read(x):return open(x)
    @classmethod
    def ls(mypath):
        import os
        return os.listdir(mypath)
class Encoding:
    pass