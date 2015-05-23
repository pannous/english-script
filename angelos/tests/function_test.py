Encoding
Encoding
$use_tree = False
require_relative('../parser_test_helper')
require_relative('../../src/core/extensions.rb')


class FunctionTest:
    include(ParserTestHelper)

    def fix_encoding():
        if String:
            require('iconv')
        if String:
            return text.encode!('UTF-8', 'UTF-8', None)
            ic = Iconv
            return ic.iconv(t)

    def test_fibonacci():
        dir = programs/
        code = File
        code = fix_encoding(code)
        p(code)
        puts(parse(code))
        fib = ('fibonacci')
        puts(fib)
        assert(==('number', name((0, fib.args()), None)))
        f10 = fib.call(10)
        puts(f10)
        assert_equals(f10, 55)
        assert_equals(parse('fibonacci of 10'), 55)
        puts(parse('assert fibonacci of 10 is 55'))

    def test_identity():
        dir = programs/
        code = File
        code = fix_encoding(code)
        p(code)
        puts(parse(code))
        identity = ('identity')
        assert(==('x', name((0, identity.args()), None)))
        puts(identity)
        puts(identity.call(5))
        assert(==(5, identity.call(5)))
        puts(parse('identity(5)'))
        assert('identity(5) is 5')

    def test_programs():
        dir = programs/
        for 
        file = None in File:
            file = None
            File

    def test_basic_syntax():
        assert_result_is("print 'hi'", 'nill')

    def test_complex_syntax():
        init('here is how to define a method: done')

    def test_block():
        ] = variables
        ] = variables
        assert_equals(count(@parser.variables(), None), 2)
        z = parse('x+y;')
        assert_equals(z, 3)

    def test_params():
        parse('how to increase x by y: x+y;')
        g = ('increase')
        args = None
        f = Function
        assert_equal(f, g)
        assert_equals(@parser.call_function(f, None), 3)

    def test_function_object():
        parse('how to increase a number x by y: x+y;')
        g = ('increase')
        arg1 = Argument
        arg2 = Argument
        f = Function
        assert_equal(f, g)
        assert_equals(@parser.call_function(f, None), 3)

    def test_blue_yay():
        assert_result_is("def test{puts 'yay'};test", 'yay')

    def test_class_method():
        parse('how to list all numbers smaller x: [1..x]')
        g = ('list')
        f = Function
        assert_equal(f, g)
        assert_equals(@parser.call_function(f, 4), None)

    def test_simple_parameters():
        parse("puts 'hi'")

    def test_to_do_something():pass

    def test_svg():
        skip
        parse('svg <circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/>')
        parse('what is that')

    def test_java_style():
        parse('1.add(0)')

    def test_dot():
        parse("x='hi'")
        assert_result_is('reverse of x', 'ih')
        assert_result_is('x.reverse', 'ih')
        assert_result_is('reverse x', 'ih')

    def test_rubyThing():
        parse('Math.hypot (3,3)')
        parse('Math.sqrt 8')
        parse('Math.sqrt( 8 )')
        parse('Math.ancestors')

    def test_x_name():
        ] = variables
        init('x')
        assert_equals(name(@parser.nod(), None), 'x')

    def test_add_to_zero():
        parse('counter is zero; repeat three times: increase counter by 1; done repeating;')
        assert_equals(('counter'), 3)

    def test_var_check():
        ] = variables
        assert('the counter is 3')

    def test_array_arg():
        assert_equals(parse('rest of [1,2,3]'), None)

    def test_array_index():
        assert_equals(parse('x=[1,2,3];x[2]'), 3)
        assert_equals(parse('x=[1,2,3];x[2]=0;x'), None)

    def test_natural_array_index():
        parse('x=[1,2,3]')
        assert_equals(parse('second element in [1,2,3]'), 2)
        assert_equals(parse('third element in x'), 3)
        assert_equals(parse('set third element in x to 8'), 8)
        assert_equals(parse('x'), None)

    def test_array_arg():
        assert_equals(parse('rest of [1,2,3]'), None)

    def test_add_time():pass

    def test_add():
        parse('counter is one; repeat three times: increase counter; done repeating;')
        assert_equals(('counter'), 4)

    def _test_svg_dom():
        init('<svg><circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/></svg>')
        puts(svg(@parser.interpretation(), None))
        parse('circle.color=green')
        assert_equals('circle.color', 'green')

    def test_incr():
        assert('increase 1 == 2')