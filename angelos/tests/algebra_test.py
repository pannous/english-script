$use_tree = True
$use_tree = False
require_relative('../parser_test_helper')


class AlgebraTest:
    include(ParserTestHelper)

    def test_algebra1():
        assert_result_is(u'two minus 1\xbd', None)
        assert_result_is('3 minus one', 2)
        init(u'4\xbd')
        assert_equals(@parser.fraction(), None)
        init(u'4\xbd+3\xbd')
        @parser.do_interpret!()
        assert_equals(@parser.algebra(), 8)
        assert_result_is(u'4\xbd+3\xbd', '8')

    def test_algebra_NOW():
        skip('test_algebra_NOW, DONT SKIP!')
        assert_result_is('1+(3/4)', u'1\xbe')
        assert_result_is('1+3/4.0', u'1\xbe')
        assert_result_is('1.0+3/4.0', u'1\xbe')

    def test_algebra():
        ok = parse('2*(3+10)')
        puts(None)
        assert_equals(ok, 26)
        skip
        assert(@current_node.!=(None))
        full_value = @current_node.full_value()
        val = eval(full_value)
        assert_equals(val, 26)
        val = @current_node.eval_node(@variableValues)
        assert_equals(val, 26)