import _global
# _global.use_tree = _global.emit
_global.use_tree = False
from parser_test_helper import *


class ConditionTest(ParserBaseTest):

    def test_eq(self):
        variables['counter'] = 3
        self.do_assert('counter == 3')

    def test_eq1(self):
        variables['counter'] = 3
        self.do_assert('counter == 3')
        self.do_assert('counter = 3')
        init('counter = 3')
        self.parser.condition()
        self.do_assert('counter = 3')
        self.do_assert('counter =3')
        self.do_assert('counter is 3')
        self.do_assert('counter equals 3')


    def test_eq2(self):
        variables['counter'] = 3
        self.do_assert('counter is the same as 3')

    def test_return(self):
        assert_result_is('if 1<2 then 5 else 4', 5)

    def test_return2(self):
        assert_result_is('if(1<2) then 3 else 4', 3)
        assert_result_is('if(3<2) then 3 else 4', 4)
        assert_result_is('if 3<2 then 5 else 4', 4)
        assert_result_is('if 1<2 then false else 4', False)
        # assert_result_is('if 1<2 then false else 4', 'false')

    def test_if_(self):
        assert_result_is('if(1<2) then 3 else 4', 3)
        assert_result_is('if 1<2 then 5 else 4', 5)
        assert_result_is('if 1<2 then true else 4', True)
        assert_result_is('if 1<2 then "True" else 4', True)


    def test_else_(self):
        assert_result_is('if(3<2) then 3 else 4', 4)
        assert_result_is('if 3<2 then 5 else 4', 4)
        assert_result_is('if 3<2 then 5 else False', False)

    def test_if_x_false(self):
        assert_result_is('if 1<2 then false else 4', False)
        # assert_result_is('if 1<2 then false else 4', 'false')

    def dont_test_everything_is_fine(self):
        init('everything is fine;')
        ok = self.parser.block()
        init('everything is fine')
        self.parser.condition()
        self.do_assert('everything is fine')

    def test_list_quantifiers(self):
        check = parse('x is 5; if all 0,1,2 are smaller 3 then increase x')
        assert_equals(check, 6)

    def test_list_quantifiers2(self):
        check = parse('x=2;if all 0,1,2 are smaller 2 then x++')
        assert_equals(check, False)
        check = parse('x=2;if one of 0,1,2 is smaller 3 then x++')
        assert_equals(check, 3)
        check = parse('x=2;if many of 0,1,2 are smaller 3 then x++')
        assert_equals(check, 3)
        check = parse('x=2;if many of 0,1,2 are smaller 1 then x++')
        assert_equals(check, False)
        check = parse('x=2;if none of 0,1,2 is smaller 3 then x++')
        assert_equals(check, False)

    def test_assert(self):
        self.do_assert(parse("assert 3rd word in 'hi my friend' is 'friend'"))
        self.do_assert(parse("assert 3rd word in 'hi my friend' is 'friend'"))
        assert_result_is("assert 3rd word in 'hi my friend' is 'friend'", True)


    def test_and(self):
        self.do_assert(parse('x=2;if x is smaller 3 and x is bigger 1 then true'))
        self.do_assert(parse('x=2;if x is smaller 3 and x is bigger 1 then true else false'))
        assert_result_is('x=2;if x is smaller 3 and x is bigger 1 then true else false', True)


    def test_and1(self):
        self.do_assert(parse('x=2;if x is smaller 3 but not x is smaller 1 then true'))
        self.do_assert(parse('x=2;if x is smaller 3 but not x is smaller 1 then true'))

    def test_and2(self):
        self.do_assert(parse('x=2;if x is smaller 3 and x is bigger 3 then "DONT REACH" else true'))
        self.do_assert(parse('x=2;if x is smaller 3 and x is bigger 3 then "DONT REACH" else true'))

    def test_and22(self):
        assert_result_is('x=2;if x is smaller 3 and x is bigger 1 then 4 else 5', 4)
        assert_result_is('x=2;if x is smaller 3 and x is bigger 1 then 4 else 5', 4)

    def test_and3(self):
        assert_result_is('if 1 is smaller 3 and 1 is bigger 3 then 4 else 5', 5)

    def test_and4(self):
        assert_result_is('x=2;if x is smaller 3 and x is bigger 3 then 4 else 5', 5)
        assert_result_is('x=2;if x is smaller 3 and x is bigger 3 then 4 else 5', 5)

    def test_no_rollback(self):
        assert_has_error('x=2;if x is smaller 3 and x is bigger 1 then for end')
        assert_has_error('x=2;if x is smaller 3 and x is bigger 1 then for end')

    def test_it(self):
        assert_result_is('x=3', 3)
        assert_result_is('x=3;4', 4)
        assert_result_is('x=3;x', 3)
        assert_result_is('x=3;it', 3)
        assert_result_is('x=3;it*2', 6)
        assert_result_is('3;it*2', 6)
        assert_result_is('2*it', 12)
        assert_result_is('it*2', 24)
        assert_result_is('6;that*2', 12)
        assert_result_is('6;2*result', 12)

    def test_if_it_result(self):
        assert_result_is('x=1+2', 3)
        self.do_assert('x=1+2;if it is 3 then true')
        self.do_assert('x=1+2;if it is 3 then true else 0')

    def test_or(self):
        self.do_assert(parse('x=2;if x is smaller 1 or x is bigger 1 then true'))
        self.do_assert(parse('x=2;if x is smaller 1 or x is bigger 1 then true'))

    def test_either_or(self):
        self.do_assert(parse('x=2;if either x is smaller 1 or x is bigger 1 then true'))
        self.do_assert(parse('x=2;if either x is smaller 1 or x is bigger 1 then true'))

    def test_else(self):
        assert_equals(parse('if 1 then false else 2'), False)
        assert_equals(parse('if 1 then false else 2'), False)

    def test_if_smaller(self):
        parse('x=2;if x is smaller 3 then x++')
        assert_equals(variables['x'], 3)
        parse('x=2;if x is smaller three then x++')
        assert_equals(variables['x'], 3)
        parse('x=2;if x is smaller three then x++')
        assert_equals(variables['x'], 3)
        parse('x=2;if x is smaller than three then x++')
        assert_equals(variables['x'], 3)
        parse('x=2;if x is smaller than three x++')
        assert_equals(variables['x'], 3)

    def test_if_return(self):
        assert_equals(parse('if 1>0 then beep'), 'beeped')
        assert_equals(parse('if 1>0 then beep else 0'), 'beeped')

    def test_if_return2(self):
        assert_equals(parse('return 1 if 1'), 1)
        assert_equals(parse('return 1 if 1'), 1)

    def assert_c_ok(self):
        variables['c'] = [0, ]
        z = parse('if c>-1 then beep;')
        assert_equals(z, 'beeped')
        z = parse('c++;if c>1 then beep;')
        assert_equals(z, False)
        self.parser.do_interpret()
        z = parse('c++;if c>1 then beep;')
        assert_equals(z, 'beeped')
        init('c++')
        self.parser.do_interpret()
        c2 = self.parser.block()
        assert_equals(c2, 3)
        assert_equals(variables['c'], 3)

    def test_if_in_loop(self):
        assert_equals(parse('c=0;while c<3:c++;if c>1 then beep;done'), 'beep')
        assert_equals(parse('c=0;while c<3:c++;if c>1 then beep;done'), 'beep')

    def test_comparisons(self):
        init('two is bigger than zero')
        ok = self.parser.condition()
        assert_equals(ok, True)

    def test_if_then(self):
        init('if 1>0 then: beep;')
        self.parser.if_then()
        parse('if 1>0 then: beep;')
        assert_equals(self.result, 'beeped')
        parse('if 1>0 then beep')
        assert_equals(self.result, 'beeped')
        parse('if 1>0 then: beep')
        assert_equals(self.result, 'beeped')
        parse('if 1>0 then: beep;end')
        assert_equals(self.result, 'beeped')

    def test_if_then2(self):
        parse('if 1>0\n beep\nend')
        assert_equals(self.result, 'beeped')
        parse('if 1>0 beep')
        assert_equals(self.result, 'beeped')
        parse('if two is bigger than zero then beep')
        assert_equals(self.result, 'beeped')

    def test_root(self):
        parse('1==1')
        parse('1==1')

    def test_complicated(self):
        parse('x is 2; if all 0,2,4 are smaller 5 then increase x; assert x equals 3')
        assert(self.result==True)
    #
    # def test_complicated2(self):
    #     parse('x is 2; if 0,2,4 are all smaller 5 then increase x; assert x equals 3')
    #     assert(self.result==True)
    #
    # def test_complicated3(self):
    #     parse('x is 2; if 0,2,4 are smaller 5 then increase x; assert x equals 3')
    #     assert(self.result==True)
