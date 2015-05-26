import _global
_global.use_tree = False
from parser_test_helper import *


class TypeTest(ParserBaseTest):


    def test_typed_variable(self):
        parse('Int i=7')
        assert_equals(variableTypes('i'), int)

    def test_typed_variable2(self):
        parse('int i=7')
        assert_equals(variableTypes('i'), 'Integer')

    def test_auto_typed_variable(self):
        parse('i=7')
        assert_equals(variableTypes('i'), 'Fixnum')

    def test_type1(self):
        init('class of 1,2,3')
        self.parser.evaluate_property()
        assert_equals(result(), list)
        init('class of [1,2,3]')
        self.parser.expressions()
        assert_equals(result(), list)
        skip()
        parse('class of 1,2,3')
        assert_equals(result(), list)

    def test_type2(self):
        parse('x=1,2,3;class of x')
        assert_equals(result(), list)

    def test_type(self):
        parse('x=1,2,3;')
        assert('type of x is Array')

    def test_type3(self):
        parse('x be 1,2,3;y= class of x')
        assert(equals(list, variables['y']))
        assert_equals(type(variables['x'], ), list)
        assert_equals(type(variableValues['x'], ), list)
        assert_equals(kind(variableValues['x'], ), list)
        assert_equals(variableValues['y'], list)
        assert('y is a Array')
        assert('y is an Array')
        assert('y is Array')
        assert('Array == class of x')
        assert('class of x is Array')
        assert('kind of x is Array')
        assert('type of x is Array')

    def test_type4(self):
        variables['x'] = [[1, 2, 3], ]
        assert('class of x is Array')
        assert('kind of x is Array')
        assert('type of x is Array')

    def test_type_cast(self):
        assert_result_is('2.3', None)
        parse('int z=2.3 as int')
        assert_equals(result(), 2)

    def test_no_type_cast(self):
        assert_equals(type(parse('2.3 as int'), ), int)
        assert_equals(type(parse('2.3'), ), float)