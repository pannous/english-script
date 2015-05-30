import _global
_global.use_tree = True
_global.use_tree = False
from parser_test_helper import *


class AlgebraTest(ParserBaseTest):
    
    def test_algebra1(self):
        assert_result_is(u'two minus 1\xbd', None)
        assert_result_is('3 minus one', 2)
        init(u'4\xbd')
        assert_equals(self.parser.fraction(), None)
        init(u'4\xbd+3\xbd')
        self.parser.do_interpret()
        assert_equals(self.parser.algebra(), 8)
        assert_result_is(u'4\xbd+3\xbd', '8')

    def test_algebra_NOW(self):
        skip('test_algebra_NOW, DONT SKIP!')
        assert_result_is('1.0+(3/4.0)', 7/4)
        assert_result_is('1.0+3/4.0', 7/4)
        assert_result_is('1+3/4.0', 7/4)
        assert_result_is('1+(3/4)', 7/4)

    def test_algebra(self):
        ok = parse('2*(3+10)')
        print((('Parsed input as ' + str(ok)) + '!'))
        assert_equals(ok, 26)
        # skip()
        # assert(self.current_node!=(None))
        # full_value = self.current_node.full_value()
        # val = eval(full_value)
        # assert_equals(val, 26)
        # val = self.current_node.eval_node(self.variableValues)
        # assert_equals(val, 26)