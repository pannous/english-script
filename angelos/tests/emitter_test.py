$use_tree = True
$verbose = False
require_relative('../parser_test_helper')
require_relative('../../src/core/emitters/c-emitter')


class EmitterTest:

    def init():
        $use_tree = True

    def initialize():
        $use_tree = True
    include(ParserTestHelper)

    def last_result():
        (<kast.Name object at 0x10cea1090>, x.split('\n'))

    def assert_result_emitted():
        assert_equals(last_result(parse_tree(x, True)), r)

    def test_js_emitter():
        if $use_tree.!():
            skip
        assert_result_emitted('x=5;increase x', 6)

    def test_int_setter():
        if $use_tree.!():
            skip
        assert_result_emitted('x=5;puts x', 5)

    def test_type_cast():
        assert_result_is('2.3', None)
        parse('int z=2.3 as int')
        assert_equals(result, 2)

    def test_printf():
        $use_tree = True
        @parser.dont_interpret!()
        parse("printf 'hello world'", False)
        interpretation =  or 
        @parser.full_tree()
        result = emit(interpretation, None, NativeCEmitter)
        assert_equals(result, 'hello world')

    def test_printf_1():
        assert_result_emitted("printf 'hello world'", 'hello world')

    def test_function_call():
        assert_result_emitted('i=7;i minus one', 6)

    def test_function():
        assert_result_emitted("def test{puts 'yay'};test", 'yay')

    def test_function2():
        parse_file('examples/factorial.e')
        assert_result_emitted('factorial 6', 5040)

    def test_array():
        assert_result_emitted('xs=[1,4,7];invert xs', None)

    def test_setter():
        $use_tree = True
        @parser.dont_interpret!()
        parse("x='ho';puts x")
        interpretation =  or 
        @parser.show_tree()
        emit(interpretation, None, NativeCEmitter)