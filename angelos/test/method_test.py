import _global
from parser_test_helper import *


class MethodTest(ParserBaseTest):
    

    def test_result(self):
        parse('alias show puts;show 3')
        assert_equals(result(), '3')
        parse('how to test:show 3;ok')
        assert(bigger_than(0, len(methods(), )))
        assert_equals(body(methods['test'], ), 'show 3;')
        parse('test')
        assert_equals(result(), '3')