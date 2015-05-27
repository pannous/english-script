import _global
_global.use_tree = False
_global.verbose = False
from parser_test_helper import *

class ErrorTest(ParserBaseTest):

    def test_type(self):
        assert_has_error('x=1,2,y;')
        assert_has_error('x=1,2,y;')

    def test_variable_type_safety_errors2(self):
        assert_has_no_error("char i='c'")
        assert_has_no_error("char i;i='c'")

    def test_variable_type_safety_errors(self):
        assert_has_no_error('an integer i;i=3')
        assert_has_no_error('int i=3')
        assert_has_no_error('int i;i=3')
        assert_has_error('const i=1;i=2')
        assert_has_error('string i=3')
        assert_has_error("int i='hi'")
        assert_has_error("integer i='hi'")
        assert_has_error("an integer i;i='hi'")
        assert_has_error("const i=1;i='hi'")
        assert_has_error("const i='hi';i='ho'")

    def test_assert_has_error(self):
        try:
                assert_has_no_error('dfsafdsa ewdfsa}{P}{P;@#%')
        except:
            p("OK")

    def test_type3(self):
        assert_has_error('x be 1,2,3y= class of x')
        assert_has_error('x be 1,2,3y= class of x')

    def test_map(self):
        assert_has_error('square 1,2 andy 3')
        assert_has_error('square 1,2 andy 3')

    def test_x(self):
        parse('x')
        parse('x')

    def test_endNode_as(self):
        init('as')
        try:
            self.parser.arg()
        except: assert_has_error("as")

    def test_rollback(self):
        assert_has_error('if 1>0 then else')
        assert_has_error('if 1>0 then else')

    def test_endNode(self):
        assert_has_error('of')
        assert_has_error('of')

    def test_list_concatenation_unknownVariable(self):
        variables['x'] = ['hi', ]
        variables['y'] = ['world', ]
        assert_has_error("z=x ' ' w")
        skip()
        assert("z=x ' ' y")
        assert_has_error("z=x ' ' y")
        assert_has_no_error("z=x ' ' y")