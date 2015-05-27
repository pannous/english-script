import _global
_global.use_tree = False
_global.verbose = False
from parser_test_helper import *


class ListTest(ParserBaseTest):
    

    def test_type0(self):
        init('1 , 2 , 3')
        assert_equals(self.parser.list(), [1, 2, 3])
        init('1,2,3')
        assert_equals(self.parser.list(), [1, 2, 3])
        init('[1,2,3]')
        assert_equals(self.parser.list(), [1, 2, 3])
        init('{1,2,3}')
        assert_equals(self.parser.list(), [1, 2, 3])
        init('1,2 and 3')
        assert_equals(self.parser.list(), [1, 2, 3])
        init('[1,2 and 3]')
        assert_equals(self.parser.list(), [1, 2, 3])
        init('{1,2 and 3}')
        assert_equals(self.parser.list(), [1, 2, 3])

    def test_list_methods(self):
        parse('invert [1,2,3]')
        assert_equals(result(), [3, 2, 1])

    def test_error(self):
        assert_has_error("first item in 'hi,'you' is 'hi'")
        assert_has_error("first item in 'hi,'you' is 'hi'")

    def test_last(self):
        assert("last item in 'hi','you' is equal to 'you'")
        assert("last item in 'hi','you' is equal to 'you'")

    def test_select2(self):
        assert("first item in 'hi','you' is 'hi'")
        assert("second item in 'hi','you' is 'you'")
        assert("last item in 'hi','you' is 'you'")

    def test_select3(self):
        assert_equals(parse("1st word of 'hi','you'"), 'hi')
        assert("1st word of 'hi','you' is 'hi'")
        assert("2nd word of 'hi','you' is 'you'")
        assert("3rd word of 'hi','my','friend' is 'friend'")

    def test_select4(self):
        assert("first word of 'hi','you' is 'hi'")
        assert("second word of 'hi','you' is 'you'")
        assert("last word of 'hi','you' is 'you'")

    def test_select5(self):
        skip()
        assert('numbers are 1,2,3. second number is 2')
        assert('my friends are a,b and c. my second friend is b')

    def test_select6(self):
        assert("last character of 'howdy' is 'y'")
        assert("first character of 'howdy' is 'h'")
        assert("second character of 'howdy' is 'o'")

    def test_list_syntax(self):
        assert('1,2 is [1,2]')
        assert('1,2 is {1,2}')
        assert('1,2 == [1,2]')
        assert('[1,2] is {1,2}')
        assert('1,2 = [1,2]')

    def test_list_syntax2(self):
        assert('1,2,3 is the same as [1,2,3]')
        assert('1,2 and 3 is the same as [1,2,3]')
        assert('1,2 and 3 are the same as [1,2,3]')
        assert('1,2 and 3 is [1,2,3]')

    def test_concatenation(self):
        parse('x is 1,2,3;y=4,5,6')
        assert(equals([1, 2, 3], value(variables['x'], )))
        assert(equals(3, len(value(variables['y'], ), )))
        init('x + y')
        z = self.parser.algebra()
        assert_equals(z.length(), 6)
        z = parse('x + y')
        assert_equals(z.length(), 6)
        assert_equals(length(result(), ), 6)
        z = parse('x plus y')
        assert_equals(z.length(), 6)

    def test_concatenation_plus(self):
        parse('x is 1,2;y=3,4')
        z = parse('x plus y')
        assert_equals(z, [1, 2, 3, 4])

    def test_concatenation2(self):
        parse('x is 1,2,3;y=4,5,6')
        parse('x + y')
        assert(equals(6, length(result(), )))
        parse('z is x + y')
        assert_equals(variables['z'], [1, 2, 3, 4, 5, 6])

    def test_concatenation2c(self):
        parse('x is 1,2\n       y is 3,4\n       z is x + y')
        assert_equals(variables['z'], [1, 2, 3, 4])

    def test_concatenation3(self):
        variables['x'] = [[1, 2], ]
        variables['y'] = [[3, 4], ]
        init('x + y == 1,2,3,4')
        self.parser.condition()
        assert('x + y == 1,2,3,4')
        assert_equals(parse('x plus y'), plus([3, 4]))
        assert('x plus y == [1,2,3,4]')

    def test_concatenation4(self):
        assert('1,2 and 3 == 1,2,3')
        assert('1,2 and 3 == 1,2,3')

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
        assert_equals(type(value(variables['x'], ), ), list)
        assert_equals(kind(value(variables['x'], ), ), list)
        assert_equals(variables['y'], list)
        assert('y is a Array')
        assert('y is an Array')
        assert('y is Array')
        assert('Array == class of x')
        assert('class of x is Array')
        assert('kind of x is Array')
        assert('type of x is Array')

    def test_type4(self):
        variables['x'] = [Variable({'name': 'x', 'value': [1, 2, 3], }), ]
        assert('class of x is Array')
        assert('kind of x is Array')
        assert('type of x is Array')

    def test_length(self):
        variables['xs'] = [Variable({'value': [1, 2, 3], 'name': 'xs', }), ]
        assert('length of xs is 3')
        assert('size of xs is 3')
        assert('count of xs is 3')

    def test_map(self):
        assert_equals(parse('square [1,2,3]'), [1, 4, 9])
        assert_equals(parse('square [1,2 and 3]'), [1, 4, 9])

    def test_map2(self):
        assert('square of 1,2 and 3 == 1,4,9')
        assert_equals(parse('square 1,2,3'), [1, 4, 9])
        assert_equals(parse('square 1,2 and 3'), [1, 4, 9])

    def test_map22(self):
        assert_result_is('square 1,2 and 3', [1, 4, 9])
        assert('square of [1,2 and 3] equals 1,4,9')
        parse('assert square of [1,2 and 3] equals 1,4,9')
        skip()
        assert('square 1,2 and 3 == 1,4,9')

    def test_map3(self):
        skip()
        assert('square every number in 1,2,3 ==1,4,9')
        assert('add one to every number in 1,2,3 ==2,3,4')
        assert("square every number in 1,'a',3 ==1,9")

    def test_hasht(self):
        init('{1,2,3}')
        assert_equals(self.parser.list(), [1, 2, 3])
        init('{a:1,b:2,c:3}')
        assert_equals(self.parser.json_hash(), {'b': 2, 'a': 1, 'c': 3, })