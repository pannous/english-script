import _global
_global.use_tree = False
from parser_test_helper import *


class FutureTest:
    

    def dont_yet_test_false_returns(self):
        assert_result_is('if 1<2 then false else 4', 'false')
        assert_result_is('if 1<2 then false else 4', False)

    def test_if_statement(self):
        init('if x is smaller than three then everything is fine;')
        self.parser.if_then()
        assert_equals(variables['everything'], 'fine')
        parse('x=2;if x is smaller than three then everything is good;')
        print(variables['everything'])
        assert_equals(variables['everything'], 'good')

    def test_repeat_until(self):
        parse('repeat until x>4: x++')
        assert_equals(variables['x'], 5)

    def test_try_until(self):
        parse('try until x>4: x++')
        assert_equals(variables['x'], 5)
        parse('try while x<4: x++')
        assert_equals(variables['x'], 4)
        parse('try x++ until x>4')
        assert_equals(variables['x'], 5)
        parse('try x++ while x<4')
        assert_equals(variables['x'], 4)
        parse('increase x until x>4')
        assert_equals(variables['x'], 5)

    def test_property_setter(self):
        parse('new circle;circle.color=green')
        assert_equals('circle.color', 'green')

    def test_local_variables_changed_by_subblocks(self):
        parse('x=2;def test\nx=1\nend\ntest')
        init('x=2 or x=1')
        assert(self.parser.condition_tree())
        assert('x=2')
        parse('x=1;x=2;')
        assert('x=2')
        parse('x=1;while x<2 do x=2;')
        assert('x=2')

    def test_loops(self):
        parse('beep three times')
        parse('repeat three times: beep; okay')
        parse('repeat three times: beep')

    def test_action_n_times(self):
        parse("2 times say 'hello'")
        parse("say 'hello' 2 times")
        parse("puts 'hello' 2 times")