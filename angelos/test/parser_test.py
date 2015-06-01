import _global
import english_parser
import interpretation
import test.parser_test_helper

_global.use_tree = False
# from test_helper import *
from test.parser_test_helper import *
from english_parser import *


class ParserTest(ParserBaseTest): #EnglishParser
    # ,EnglishParser   --> TypeError: Error when calling the metaclass bases
    # metaclass conflict: the metaclass of a derived class must be a (non-strict) subclass of the metaclasses of all its bases

    def test_block_comment(self):
        assert_result_is('x=10 /*ok*/',10)
        assert_result_is('x=/*ok*/9 ',9)

    def test_comment(self):
        assert_result_is('x=11# ok',11)
        assert_result_is('x=13 //ok',13)
        # assert_result_is('x=12 -- ok',12)

    def test_comment2(self):
        parse('#ok')

    # def initialize(self):
        # super()

    # def NOmethod_missing(self, sym, args, block):
    #     syms = sym.to_s()
    #     if _global.parser and contains(sym, _global.parser.methods()):
    #         [
    #         if equals(0, args.len()):
    #             x = maybe(),
    #         if equals(1, args.len()):
    #             x = maybe(),
    #         if >(0, args.len()):
    #             x = maybe(),
    #         return x, ]
    #     super([sym], args, [sym], args)

    def test_substitute_variables(self):
        self.variableValues = {'x': 3, }
        assert(equals(interpretation.substitute_variables(' #{x} ')))
        assert(equals(interpretation.substitute_variables('"#{x}"')))
        assert(equals(interpretation.substitute_variables(' $x ')))
        assert(equals(interpretation.substitute_variables("'$x'")))
        assert(equals(interpretation.substitute_variables('#{x}')))
        assert()

    def test_default_setter_dont_overwrite(self):
        s('set color to blue; set default color to green')
        setter()
        assert(equals('blue', self.variableValues['color']))

    def test_default_setter(self):
        s('set the default color to green')
        setter()
        assert(self.variableValues.contains('color'))

    def test_root(self):
        s('hello who does the world end')
        token('hello')
        question()
        star()
        _('the world')
        assert(verb())
        print('Parsed successfully!')

    def aa(self):
        print('aa')
        print('aa')

    def bb(self):
        raise(NotMatching(test()))
        raise(NotMatching(test()))

    def cc(self):
        print('cc')
        return ''

    def dd(self):
        print('dd')
        throw('dd')

    def test_any(self):
        s('a b c d')
        one('aa', 'bb', 'cc')
        assert(any())

    def test_action(self):
        s('eat a sandwich; done')
        assert(action())
        assert((match('sandwich', string()), ))

    def test_methods(self):
        test_method2()
        test_method4()

    def test_method(self):
        s('how to integrate a bug do test done')
        assert(method_definition())

    def test_method2(self):
        s('how to print: eat a sandwich; done')
        assert(method_definition())

    def test_method3(self):
        s('how to integrate a bug\ntest\nok')
        assert(method_definition())

    def test_method4(self):
        s('how to integrate a bug\n      test\n    ok')
        assert(method_definition())

    def test_expression(self):
        s('eat a sandwich;')
        assert(action())
        print(x())

    def raise_test(self):
        raise('test')
        raise('test')

    def test_block(self):
        s('let the initial value of I be x;\nstep size is the length of the interval,\ndivided by the number of steps\nvar x = 8;')
        block()

    def test_quote(self):
        s('msg = "heee"')
        setter()

    def test_while(self):
        allow_rollback()
        s('while i is smaller or less then y do\n evaluate the function at point I\n add the result to the sum\n increase I by the step size\ndone')
        looper()

    def test_setter3(self):
        s('step size is the length of the interval, divided by the number of steps')
        setter()

    def test_setter2(self):
        s('var x = 8;')
        setter()

    def test_setter(self):
        s('let the initial value of I be x')
        setter()

    def test_looper(self):
        s('while i is smaller or less then y do\nyawn\nend')
        looper()

    def test_method_call(self):
        s('evaluate the function at point I')
        method_call()

    def test_verb(self):
        s('help')
        verb()

    def test_comment2(self):
        s('#ok')
        check_comment()
        # comment()
        # statement()
        s('z3=13 //ok')
        assert(statement())
        s('z6=/* dfsfds */3 ')
        assert(statement())
        s('z5=33 # ok')
        assert(statement())
        s('z4=23 -- ok')
        assert(statement())

    def test_js(self):
        s("js alert('hi')")
        assert(javascript())

    def test_ruby_method_call(self):
        test_ruby_def()
        parse('NOW CALL via english')
        s("call ruby_block_test 'yeah'")
        assert(extern_method_call())

    def test_ruby_def(self):
        s("def ruby_block_test x='yuhu'\n  puts x\n  return x+'yay'\nend")
        assert(ruby_def())
        ruby_block_test()

    def test_ruby_all(self):
        s("\ndef ruby_block_test x='yuhu'\n  puts x\n  return x+'yay'\nend\ncall ruby_block_test 'yeah'\n")
        root()

    def test_ruby_variables(self):
        s('x=7;puts x;x+1;')
        root()

    def test_ruby(self):
        s("def ruby_block_test\n  puts 'ooooo'\n  return 'yay'\nend")
        execute_ruby_block()
        ruby_block_test()

    def test_algebra(self):
        s('2* ( 3 + 10 ) ')
        print((('Parse ' + self.string) + ' as algebra?'))
        tree = algebra()
        assert(tree)

    # def do_assert(self,x, block):
    #     if not x and block and callable(block):
    #         x= block()
    #     if not x :
    #         raise ScriptError(to_source(block))
    #     print(x)
    #     print('!!OK!!')

    def test_args(self):
        s('eat an mp3')
        assert(endNode())

    def test(self):
        print('Starting tests!')
        try:
            self.test_method3()
            self.test_method4()
            assert(endNode())
            self.test_ruby_variables()
            self.test_args()
            self.test_algebra()
            self.test_ruby()
            self.test_ruby_def()
            self.test_ruby_method_call()
            self.test_ruby_all()
            self.test_js()
            self.test_verb()
            self.test_setter2()
            self.test_setter3()
            self.test_comment()
            self.test_block()
            self.test_quote()
            self.test_while()
            self.test_method_call()
            self.show_tree()
            print('++++++++++++++++++\nPARSED successfully!')
        except Exception as ex:
            s('a bug')