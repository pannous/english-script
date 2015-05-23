$use_tree = False
$verbose = False
require_relative('../parser_test_helper')


class ListTest:
    include(ParserTestHelper)

    def test_type0():
        init('1 , 2 , 3')
        assert_equals(@parser.list(), None)
        init('1,2,3')
        assert_equals(@parser.list(), None)
        init('[1,2,3]')
        assert_equals(@parser.list(), None)
        init('{1,2,3}')
        assert_equals(@parser.list(), None)
        init('1,2 and 3')
        assert_equals(@parser.list(), None)
        init('[1,2 and 3]')
        assert_equals(@parser.list(), None)
        init('{1,2 and 3}')
        assert_equals(@parser.list(), None)

    def test_list_methods():
        parse('invert [1,2,3]')
        assert_equals(result, None)

    def test_error():
        assert_has_error("first item in 'hi,'you' is 'hi'")

    def test_last():
        assert("last item in 'hi','you' is equal to 'you'")

    def test_select2():
        assert("first item in 'hi','you' is 'hi'")
        assert("second item in 'hi','you' is 'you'")
        assert("last item in 'hi','you' is 'you'")

    def test_select3():
        assert_equals(parse("1st word of 'hi','you'"), 'hi')
        assert("1st word of 'hi','you' is 'hi'")
        assert("2nd word of 'hi','you' is 'you'")
        assert("3rd word of 'hi','my','friend' is 'friend'")

    def test_select4():
        assert("first word of 'hi','you' is 'hi'")
        assert("second word of 'hi','you' is 'you'")
        assert("last word of 'hi','you' is 'you'")

    def test_select5():
        skip
        assert('numbers are 1,2,3. second number is 2')
        assert('my friends are a,b and c. my second friend is b')

    def test_select6():
        assert("last character of 'howdy' is 'y'")
        assert("first character of 'howdy' is 'h'")
        assert("second character of 'howdy' is 'o'")

    def test_list_syntax():
        assert('1,2 is [1,2]')
        assert('1,2 is {1,2}')
        assert('1,2 == [1,2]')
        assert('[1,2] is {1,2}')
        assert('1,2 = [1,2]')

    def test_list_syntax2():
        assert('1,2,3 is the same as [1,2,3]')
        assert('1,2 and 3 is the same as [1,2,3]')
        assert('1,2 and 3 are the same as [1,2,3]')
        assert('1,2 and 3 is [1,2,3]')

    def test_concatenation():
        parse('x is 1,2,3;y=4,5,6')
        assert(==(None, value(('x'), None)))
        assert(==(3, count(value(('y'), None), None)))
        init('x + y')
        z = @parser.algebra()
        assert_equals(z.length(), 6)
        z = parse('x + y')
        assert_equals(z.length(), 6)
        assert_equals(result.length(), 6)
        z = parse('x plus y')
        assert_equals(z.length(), 6)

    def test_concatenation_plus():
        parse('x is 1,2;y=3,4')
        z = parse('x plus y')
        assert_equals(z, None)

    def test_concatenation2():
        parse('x is 1,2,3;y=4,5,6')
        parse('x + y')
        assert(==(6, result.length()))
        parse('z is x + y')
        assert_equals(('z'), None)

    def test_concatenation2c():
        parse('x is 1,2\n       y is 3,4\n       z is x + y')
        assert_equals(('z'), None)

    def test_concatenation3():
        ] = variables
        ] = variables
        init('x + y == 1,2,3,4')
        @parser.condition()
        assert('x + y == 1,2,3,4')
        assert_equals(parse('x plus y'), plus(None))
        assert('x plus y == [1,2,3,4]')

    def test_concatenation4():
        assert('1,2 and 3 == 1,2,3')

    def test_type1():
        init('class of 1,2,3')
        @parser.evaluate_property()
        assert_equals(result, Array)
        init('class of [1,2,3]')
        @parser.expressions()
        assert_equals(result, Array)
        skip
        parse('class of 1,2,3')
        assert_equals(result, Array)

    def test_type2():
        parse('x=1,2,3;class of x')
        assert_equals(result, Array)

    def test_type():
        parse('x=1,2,3;')
        assert('type of x is Array')

    def test_type3():
        parse('x be 1,2,3;y= class of x')
        assert(==(Array, ('y')))
        assert_equals(type(('x'), None), Array)
        assert_equals(class(value(('x'), None), None), Array)
        assert_equals(kind(value(('x'), None), None), Array)
        assert_equals(('y'), Array)
        assert('y is a Array')
        assert('y is an Array')
        assert('y is Array')
        assert('Array == class of x')
        assert('class of x is Array')
        assert('kind of x is Array')
        assert('type of x is Array')

    def test_type4():
        ] = variables
        assert('class of x is Array')
        assert('kind of x is Array')
        assert('type of x is Array')

    def test_length():
        ] = variables
        assert('length of xs is 3')
        assert('size of xs is 3')
        assert('count of xs is 3')

    def test_map():
        assert_equals(parse('square [1,2,3]'), None)
        assert_equals(parse('square [1,2 and 3]'), None)

    def test_map2():
        assert('square of 1,2 and 3 == 1,4,9')
        assert_equals(parse('square 1,2,3'), None)
        assert_equals(parse('square 1,2 and 3'), None)

    def test_map22():
        assert_result_is('square 1,2 and 3', None)
        assert('square of [1,2 and 3] equals 1,4,9')
        parse('assert square of [1,2 and 3] equals 1,4,9')
        skip
        assert('square 1,2 and 3 == 1,4,9')

    def test_map3():
        skip
        assert('square every number in 1,2,3 ==1,4,9')
        assert('add one to every number in 1,2,3 ==2,3,4')
        assert("square every number in 1,'a',3 ==1,9")

    def test_hasht():
        init('{1,2,3}')
        assert_equals(@parser.list(), None)
        init('{a:1,b:2,c:3}')
        assert_equals(@parser.json_hash(), None)