import _global
from parser_test_helper import *


class VariableTest(ParserBaseTest):


    def test_a_setter_article_vs_variable(self):
        parse('a=green')
        assert_equals(variables['a'], 'green')
        parse('a dog=green')
        assert_equals(variables['dog'], 'green')

    def test_variableTypes(self):
        init('an integer i')
        self.parser.variable()

    def test_variable_type_safety(self):
        parse('int i=3')
        parse('an integer i;i=3')
        parse('int i;i=3')
        parse("char i='c'")
        parse("char i;i='c'")
        assert_has_error('string i=3')
        assert_has_error("int i='hi'")
        assert_has_error("integer i='hi'")
        assert_has_error("an integer i;i='hi'")
        assert_has_error('const i=1;i=2')
        assert_has_error("const i=1;i='hi'")
        assert_has_error("const i='hi';i='ho'")

    def test_var_condition_unmodified(self):
        variables['counter'] = [Variable({'name': 'counter', 'value': 3, }), ]
        init('counter=2')
        assert(equals(self.parser.condition()))
        assert('counter=3')

    def test_vars(self):
        variables['counter'] = [Variable({'name': 'counter', 'value': 3, }), ]
        parse('counter =2')
        assert_equals(variables['counter'], 2)
        assert_equals(variables['counter'], 2)