import _global
_global.use_tree = False
_global.verbose = False
from parser_test_helper import *


class StringTest(ParserBaseTest):


    def test_string_methods(self):
        parse("invert 'hi'")
        assert_equals(self.result, 'ih')

    def test_nth_word(self):
        assert("3rd word in 'hi my friend !!!' is 'friend'")
        assert("3rd word in 'hi my friend !!!' is 'friend'")

    def _test_advanced_string_methods(self):
        parse("x='hi' inverted")
        assert(self.result.equals('ih'))
        assert(equals('ih', self.variableValues['x']))

    def _test_select_character(self):
        assert("first character of 'hi' is 'h'")
        assert("second character of 'hi' is 'i'")
        assert("last character of 'hi' is 'i'")

    def _test_select_word(self):
        assert("first word of 'hi you' is 'hi'")
        assert("second word of 'hi you' is 'you'")
        assert("last word of 'hi you' is 'you'")

    def test_gerunds(self):
        init('gerunding')
        x = self.parser.gerund()
        init('gerunded')
        x = self.parser.postjective()
        x

    def test_concatenation(self):
        self.parser.do_interpret()
        parse("x is 'Hi'; y is 'World';z is x plus y")
        assert_equals(variables['z'], 'HiWorld')

    def test_concatenation_b(self):
        init("x is 'hi'")
        self.parser.setter()
        assert(equals('hi', variables['x']))
        init("x + ' world'")
        r = self.parser.algebra()
        assert_equals(r, 'hi world')
        parse("x + ' world'")
        assert_equals(result(), 'hi world')
        parse("y is ' world'")
        parse('z is x + y')
        assert_equals(variables['z'], 'hi world')
        parse("y is ' you'\n       z is x + y")
        assert_equals(variables['z'], 'hi you')

    def test_concatenation_b(self):
        init("x is 'hi'")
        self.parser.setter()
        assert(equals('hi', variables['x']))
        init("x + ' world'")
        r = self.parser.algebra()
        assert_equals(r, 'hi world')
        parse("x + ' world'")
        assert_equals(result(), 'hi world')
        parse("y is ' world'")
        parse('z is x + y')
        assert_equals(variables['z'], 'hi world')

    def test_concatenation_c(self):
        parse("x is 'hi'")
        parse("y is ' you'")
        parse('z is x + y')
        assert_equals(variables['z'], 'hi you')

    def test_newline_statements(self):
        parse("x is 'hi';\n           z='ho'")
        assert_equals(variables['z'], 'ho')

    def test_concatenation_c3(self):
        parse("x is 'hi'")
        parse("y is ' you';z is x + y")
        assert_equals(variables['z'], 'hi you')

    def DONT_test_concatenation_by_and(self):
        parse('z = x and y')
        assert(equals('hi world', variables['z']))
        assert("x and y == 'hi world'")
        parse("z is x and ' ' and y")
        assert('type of z is string or list')

    def dont_test_list_concatenation(self):
        init("'hi' ' ' 'world'")
        z = self.parser.expressions()
        assert_equals(z, 'hi world')
        variables['x'] = ['hi', ]
        variables['y'] = ['world', ]
        init("z=x ' ' y")
        z = self.parser.setter()
        assert_equals(z, 'hi world')
        parse("x is 'hi'; y is 'world';z is x ' ' y")
        assert('type of z is string or type of z is list')
        assert('type of z is string or list')
        assert_equals(variables['z'], 'hi world')
        assert("z is 'hi world' OR z is 'hi',' ','world'")

    def test_concatenation2(self):
        parse("x is 'hi'; y = ' world'")
        assert_equals(parse('x + y'), 'hi world')
        assert("x plus y == 'hi world'")

    def test_concatenation2b(self):
        assert_equals(parse("'hi'+ ' '+'world'"), 'hi world')
        assert_result_is("'hi'+ ' '+'world'", "'hi world'")
        parse("x is 'hi'; y is 'world';z is x plus ' ' plus y")
        assert_equals(variables['z'], 'hi world')
        assert("z is 'hi world'")

    def test_type(self):
        parse("x='hi'")
        assert_result_is('type of x', str)
        assert('type of x is string')

    def test_type3(self):
        parse("x be 'hello world';")
        assert('x is a string')
        assert('type of x is string')
        assert('class of x is string')
        assert('kind of x is string')
        parse('y= class of x')
        assert(equals(Quote, variables['y']))
        assert('y is string')
        parse('y is type of x')
        assert('y is string')

    def test_type1(self):
        init("class of 'hi'")
        self.parser.evaluate_property()
        assert_equals(result(), Quote)
        init("class of 'hi'")
        self.parser.expressions()
        assert_equals(result(), Quote)
        parse("class of 'hi'")
        assert_equals(result(), Quote)

    def test_type2(self):
        parse("x='hi';\n      class of x")
        parse("x='hi';class of x")
        assert_equals(result(), Quote)

    def test_result(self):
        parse("x be 'hello world';show x;x; class of x")
        assert('type of x is string')
        assert('class of x is string')
        parse('y is type of x')
        assert('y is string')