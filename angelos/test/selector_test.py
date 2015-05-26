import _global
_global.use_tree = False
from parser_test_helper import *


class SelectorTest(ParserBaseTest):


    def test_every(self):
        parse('xs= [1,2,3]; increase all xs')
        skip()
        parse('xs= [1,2,3]; show all xs')
        parse('xs= [1,2,3]; show every xs')
        parse('friendly numbers= [1,2,3]; show all friendly numbers')
        parse('friendly numbers= [1,2,3]; show every friendly number')

    def test_selector0(self):
        parse('xs= 2,3,8,9')
        init('xs that are smaller than 7')
        z = self.parser.selectable()
        assert_equals(z, [2, 3])
        z = parse('let z be all xs that are smaller than 7 ')
        assert_equals(z, [2, 3])
        z = parse('let z be xs that are smaller than 7 ')
        assert_equals(z, [2, 3])

    def test_selector1(self):
        parse('xs= 1,2,3')
        init(' xs that are bigger than one')
        z = self.parser.selectable()
        assert_equals(z, [2, 3])
        assert('xs that are bigger than one == [2,3]')

    def test_every_selector(self):
        skip()
        parse('friendly numbers= [1,2,3]; show every friendly number that is bigger than one')
        parse('friendly numbers= [1,2,3]; all friendly numbers which are smaller than three == [1,2]')

    def test_selector3(self):
        skip()
        assert("every number in 1,'a',3 ==1,3")
        assert("all numbers in 1,'a',3 ==1,3")
        assert('all negative numbers in 1,-2,3,-4 ==-2,-4')
        assert('all numbers in 1,-2,3,-4 that are negative == -2,-4')