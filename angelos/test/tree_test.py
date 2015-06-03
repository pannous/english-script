import angle
from parser_test_helper import *
angle.use_tree=True

class TreeTest(ParserBaseTest):

    def test_algebra1(self):
        assert_result_is('3 minus one', 2)
        init(u'4\xbd')
        assert_equals(self.parser.fraction(), None)
        init(u'4\xbd+3\xbd')
        self.parser.do_interpret()
        assert_equals(self.parser.algebra(), 8)
        assert_result_is(u'4\xbd+3\xbd', '8')

    def test_method4(self):
        init('how to integrate a bug\n      test\n    ok')
        assert(self.parser.method_definition())

    def _test_block(self):
        init('let the initial value of I be x;\n\n      step size is the length of the interval,\n      divided by the number of steps\n\n      var x = 8;')
        self.parser.block()

    def _test_while(self):
        self.variableValues['i'] = [0, ]
        self.variableValues['y'] = [5, ]
        parse('while i is smaller or less then y do\n        increase i by 4;\n      done')
        assert_equals(self.variableValues['i'], 8)

    def _test_while2(self):
        init('while i is smaller or less then y do\n evaluate the function at point I\n add the result to the sum\n increase I by the step size\ndone')
        self.parser.looper()

    def _test_setter3(self):
        init('step size is the length of the interval, divided by the number of steps')
        self.parser.setter()

    def test_looper(self):
        skip()
        parse('i=1;y=2;')
        init('while i is smaller or equal y do\ni++\nend')
        self.parser.loops()
        init('while i is smaller or equal than y do\ni++\nend')
        self.parser.loops()

    def test_then_typo(self):
        skip()
        parse('while i is smaller or equal y then do\nyawn\nend')
        skip()
        parse('while i is smaller or equal then y do\nyawn\nend')

    def test_method_call(self):
        skip()
        init('evaluate the function at point I')

    def test_algebra_NOW(self):
        skip('test_algebra_NOW, DONT SKIP!')
        assert_result_is('1+3/4.0', u'1\xbe')
        assert_result_is('1.0+3/4.0', u'1\xbe')

    def test_algebra(self):
        init('2*(3+10)')
        ok = self.parser.algebra()
        print((('Parsed input as ' + ok) + '!'))
        assert_equals(ok, 26)
        if _global.use_tree==False:
            skip()
        current_node = root(interpretation(), )
        full_value = current_node.full_value()
        val = eval(full_value)
        assert_equals(val, 26)
        val = current_node.eval_node()
        assert_equals(val, 26)