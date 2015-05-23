@parser.real()
$use_tree = False
$verbose = False
require_relative('../parser_test_helper')


class NumberTest:
    include(ParserTestHelper)

    def test_type1():
        puts(parse('class of 1'))
        assert_equals(@result, Fixnum)
        parse('class of 3.3')
        assert(@result==(Float))

    def test_type2():
        assert('3.2 is a Numeric')
        assert('3.2 is a Float')
        assert('3.2 is a float')
        assert('3.2 is a real')
        assert('3.2 is a float number')
        assert('3.2 is a real number')

    def test_type3():
        assert('3 is a Number')
        assert('3 is a Fixnum')
        assert('3 is a Numeric')
        assert('3 is a Integer')

    def test_english_number_types():
        assert('3.2 is a number')
        assert('3.2 is a real number')
        assert('3.2 is a real')
        assert('3.2 is a float')
        assert('3.2 is a float number')
        assert('3 is a number')
        assert('3 is a integer')
        assert('3 is an integer')

    def _test_int_methods():
        parse('invert 3')
        assert(@result==('1/3'))

    def test_parse_float():
        init('5.0')
        x = @parser.real()
        parse('20/5.0')
        assert_equals(result, 4)

    def current():pass