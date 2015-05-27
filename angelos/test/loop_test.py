import _global
_global.use_tree = False
from parser_test_helper import *


class LoopTest(ParserBaseTest):
    

    def _test_forever(self):
        init('beep forever')
        loops()
        parse('beep forever')

    def test_while_return(self):
        assert_equals(parse('c=0;while c<1:c++;beep;done'), 'beeped')
        assert_equals(parse('c=0;while c<1:c++;beep;done'), 'beeped')

    def test_while_loop(self):
        parse('c=0;while c<3:c++;beep;done')
        assert(equals(3, variables['c']))

    def test_expressions(self):
        parse('counter=1')
        assert(equals(1, self.variableValues['counter']))
        parse('counter++')
        assert(equals(2, self.variableValues['counter']))
        parse('counter+=1')
        assert(equals(3, self.variableValues['counter']))
        parse('counter=counter+counter')
        counter = self.variableValues['counter']
        assert(counter.equals(6))

    def test_repeat(self):
        parse('counter =0; repeat three times: increase the counter; okay')
        assert('counter=3')
        assert_equals(self.variableValues['counter'], 3)

    def test_repeat3(self):
        assert_result_is('counter =0; repeat three times: counter=counter+1; okay', 3)
        assert_result_is('counter =0; repeat while counter < 3: counter=counter+1; okay', 3)

    def test_repeat1(self):
        parse('counter =0; repeat three times: counter+=1; okay')
        assert('counter =3')
        parse('counter =0; repeat three times: counter++; okay')
        counter = self.variableValues['counter']
        assert('counter =3')
        assert(counter.equals(3))

    def _test_forever(self):
        self.parser.s('beep forever')
        self.parser.loops()