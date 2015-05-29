import _global
ENV['RAILS_ENV'] = ['test', ]
_global.testing = True
_global.emit = False
from autorun import *
from english-parser import *


class ParserBaseTest:
    from Exceptions import *
    property('variableValues')

    def initialize(self, args):
        if ENV['TEST_SUITE']:
            _global.verbose = False
        if _global.raking:
            _global.emit = False
        self.parser = EnglishParser()
        super(args)

    def assert_has_no_error(self, [None]):
        parse(x)
        print(x+(' parses OK'))

    def assert_has_error(self, [None], block):
        try:
            except:
                parse(x)
                original_assert(+(to_s(self.parser.to_source(block), ), +(' \t', +(x.to_s()))), False)
        except:
            parse(x)
            original_assert(+(to_s(self.parser.to_source(block), ), +(' \t', +(x.to_s()))), False)
        try:
            except:
                parse(x)
                original_assert(+(to_s(self.parser.to_source(block), ), +(' \t', +(x.to_s()))), False)
        except:
            parse(x)
            original_assert(+(to_s(self.parser.to_source(block), ), +(' \t', +(x.to_s()))), False)

    def assert_result_is(self, x, r):
        assert_equals(parse(x), parse(r))
        assert_equals(parse(x), parse(r))

    def assert_equals(self, a, b):
        if ((a.equals(b) or equals(b.to_s(), a.to_s())) or equals(+('"', +(b.to_s())), a.to_s())):
            print(((((('TEST PASSED! ' + self.parser.original_string()) + '    ') + a) + ' == ') + b))
        else:
            print(filter_stack(caller()))
            assert(False, ((a + ' should equal ') + b))
        if ((a.equals(b) or equals(b.to_s(), a.to_s())) or equals(+('"', +(b.to_s())), a.to_s())):
            print(((((('TEST PASSED! ' + self.parser.original_string()) + '    ') + a) + ' == ') + b))
        else:
            print(filter_stack(caller()))
            assert(False, ((a + ' should equal ') + b))
    alias_method('original_assert', 'assert')

    def assert(self, [None, None], block):
        if x.equals(True):
            return print(('\nTEST PASSED! ' + self.parser.original_string()))
        if msg.is_a(Proc):
            msg = msg.call()
        if block:
            msg = (msg or self.parser.to_source(block))
        if x==False and block:
            x = 
        if x==False:
            original_assert(False, ((x + ' NOT PASSING: ') + msg))
        if x.is_a(str):
            [
            try:
                except:
                    print(('Testing ' + x))
                    init(x)
                    if _global.emit:
                        self.parser.dont_interpret()
                    ok = self.parser.condition()
                    if _global.emit:
                        ok = emit(None, ok)
            except:
                print(('Testing ' + x))
                init(x)
                if _global.emit:
                    self.parser.dont_interpret()
                ok = self.parser.condition()
                if _global.emit:
                    ok = emit(None, ok), 
            if ok==False:
                original_assert(False, ((x + ' NOT PASSING: ') + msg)), ]
        print(+(to_s(self.parser.to_source(block), ), (('TEST PASSED!  ' + x) + ' \t')))

    def NOmethod_missing(self, sym, args, block):
        syms = sym.to_s()
        if self.parser and contains(sym, self.parser.methods()):
            [
            if equals(0, args.len()):
                x = maybe(), 
            if equals(1, args.len()):
                x = maybe(), 
            if bigger_than(0, args.len()):
                x = maybe(), 
            return x, ]
        super([sym], args, [sym], args)

    def init(self, string):
        self.parser.allow_rollback((-1))
        self.parser.init(string)

    def variables(self):
        self.parser.variables()
        self.parser.variables()

    def variableValues(self):
        self.parser.variableValues()
        self.parser.variableValues()

    def functions(self):
        self.parser.methods()
        self.parser.methods()

    def methods(self):
        self.parser.methods()
        self.parser.methods()

    def interpretation(self):
        self.parser.interpretation()
        self.parser.interpretation()

    def result(self):
        self.parser.result()
        self.parser.result()

    def parse_file(self, file):
        parse(IO.read(file))
        parse(IO.read(file))

    def parse_tree(self, x, [None]):
        if (x.is_a(str), ):
            return x
        self.parser.dont_interpret()
        interpretation = self.parser.parse(x)
        self.parser.full_tree()
        if emit:
            return emit(interpretation, interpretation.root())
        else:
            return interpretation.evaluate()

    def emit(self, interpretation, root):
        from c-emitter import *
        emit(interpretation, {'run': True, }, NativeCEmitter())

    def parse(self, x, [None]):
        if interpret:
            self.parser.do_interpret()
        if (x.is_a(str), ):
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


    class <_ast.Name object at 0x103ba3210>:
        self
        _test
        print(+(x.to_s()))

    def variableTypes(self, v):
        type(variables[v], )
        type(variables[v], )

    def verbose(self):
        if _global.raking:
            return None
        self.parser.verbose = True