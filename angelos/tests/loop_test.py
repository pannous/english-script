$use_tree = False
require_relative('../parser_test_helper')


class LoopTest:
    include(ParserTestHelper)

    def _test_forever():
        init('beep forever')
        loops
        parse('beep forever')

    def test_while_return():
        assert_equals(parse('c=0;while c<1:c++;beep;done'), 'beeped')

    def test_while_loop():
        parse('c=0;while c<3:c++;beep;done')
        assert(==(3, ('c')))

    def test_expressions():
        parse('counter=1')
        assert(==(1, ('counter')))
        parse('counter++')
        assert(==(2, ('counter')))
        parse('counter+=1')
        assert(==(3, ('counter')))
        parse('counter=counter+counter')
        counter = ('counter')
        assert(counter==(6))

    def test_repeat():
        parse('counter =0; repeat three times: increase the counter; okay')
        assert('counter=3')
        assert_equals(('counter'), 3)

    def test_repeat3():
        assert_result_is('counter =0; repeat three times: counter=counter+1; okay', 3)
        assert_result_is('counter =0; repeat while counter < 3: counter=counter+1; okay', 3)

    def test_repeat1():
        parse('counter =0; repeat three times: counter+=1; okay')
        assert('counter =3')
        parse('counter =0; repeat three times: counter++; okay')
        counter = ('counter')
        assert('counter =3')
        assert(counter==(3))

    def _test_forever():
        @parser.s('beep forever')
        @parser.loops()