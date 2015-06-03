import _global

_global.use_tree = False
from parser_test_helper import *
# from extensions import *


class FunctionTest(ParserBaseTest):

    def test_fibonacci(self):
        dir = 'programs/'
        code = read(dir + ('fibonacci.e'))
        code = fix_encoding(code)
        p(code)
        print(parse(code))
        fib = functions['fibonacci']
        print(fib)
        assert (equals('number', fib.args[0].name))  # name(args[0], )))
        f10 = fib.call(10)
        print(f10)
        assert_equals(f10, 55)
        assert_equals(parse('fibonacci of 10'), 55)
        print(parse('assert fibonacci of 10 is 55'))

    def test_identity(self):
        dir = 'programs/'
        code = read(dir + ('identity.e'))
        code = fix_encoding(code)
        p(code)
        print(parse(code))
        identity = functions['identity']
        assert (equals('x', identity.args[0].name))
        print(identity)
        print(identity.call(5))
        assert (equals(5, identity.call(5)))
        print(parse('identity(5)'))
        assert ('identity(5) is 5')

    def test_programs(self):
        dir = 'programs/'
        for file in File.ls(dir):
            code = read(File.open(dir + (file), 'rb', {'encoding': 'UTF-8', 'binary': True, }))
            code = fix_encoding(code)
            p(code)
            print(parse(code))
            fib = functions['fibonacci']
            print(fib)
            print(fib.call(5))
            parse('fibonacci(5)')

    def test_basic_syntax(self):
        assert_result_is("print 'hi'", 'nill')
        assert_result_is("print 'hi'", 'nill')

    def test_complex_syntax(self):
        init('here is how to define a method: done')
        init('here is how to define a method: done')

    def test_block(self):
        variables['x'] = Variable(name='x',value=1)
        variables['y'] = Variable(name='x',value=2)
        z = parse('x+y;')
        assert_equals(len(self.parser.variables()), 2)
        assert_equals(z, 3)

    def test_params(self):
        parse('how to increase x by y: x+y;')
        g = functions['increase']
        args = [Argument({'name': 'x', 'preposition': None, 'position': 1, }),
                Argument({'preposition': 'by', 'name': 'y', 'position': 2, })]
        f = Function({'body': 'x+y;', 'name': 'increase', 'arguments': args, })
        assert_equal(f, g)
        assert_equals(self.parser.call_function(f, {'x': 1, 'y': 2, }), 3)

    def test_function_object(self):
        parse('how to increase a number x by y: x+y;')
        g = functions['increase']
        arg1 = Argument({'type': 'number', 'position': 1, 'name': 'x', 'preposition': None, })
        arg2 = Argument({'name': 'y', 'preposition': 'by', 'position': 2, })
        f = Function({'arguments': arg2, 'name': 'increase', 'body': 'x+y;', 'object': arg1, })
        assert_equal(f, g)
        assert_equals(self.parser.call_function(f, {'x': 1, 'y': 2, }), 3)

    def test_blue_yay(self):
        assert_result_is("def test{puts 'yay'};test", 'yay')
        assert_result_is("def test{puts 'yay'};test", 'yay')

    def test_class_method(self):
        parse('how to list all numbers smaller x: [1..x]')
        g = functions['list']
        f = Function({'body': '[1..x]', 'name': 'list'})  # , 'arguments': arg2(), 'object': arg1(), })
        assert_equal(f, g)
        assert_equals(self.parser.call_function(f, 4), [1, 2, 3])

    def test_simple_parameters(self):
        parse("puts 'hi'")
        parse("puts 'hi'")

    def test_to_do_something(self):
        pass

    def test_svg(self):
        skip()
        parse('svg <circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/>')
        parse('what is that')

    def test_java_style(self):
        parse('1.add(0)')
        parse('1.add(0)')

    def test_dot(self):
        parse("x='hi'")
        assert_result_is('reverse of x', 'ih')
        assert_result_is('x.reverse', 'ih')
        assert_result_is('reverse x', 'ih')

    def test_rubyThing(self):
        parse('Math.hypot(3,3)')
        parse('Math.sqrt 8')
        parse('Math.sqrt( 8 )')
        parse('Math.ancestors')

    def test_x_name(self):
        variables['x'] = Variable(name='x',value=7)
        init('x')
        assert_equals(name(self.parser.nod(), ), 'x')

    def test_add_to_zero(self):
        parse('counter is zero; repeat three times: increase counter by 1; done repeating;')
        assert_equals(variables['counter'], 3)

    def test_var_check(self):
        variables['counter'] =Variable(name='counter',value=3)
        assert ('the counter is 3')

    def test_array_arg(self):
        assert_equals(parse('rest of [1,2,3]'), [2, 3])
        assert_equals(parse('rest of [1,2,3]'), [2, 3])

    def test_array_index(self):
        assert_equals(parse('x=[1,2,3];x[2]'), 3)
        assert_equals(parse('x=[1,2,3];x[2]=0;x'), [1, 2, 0])

    def test_natural_array_index(self):
        parse('x=[1,2,3]')
        assert_equals(parse('second element in [1,2,3]'), 2)
        assert_equals(parse('third element in x'), 3)
        assert_equals(parse('set third element in x to 8'), 8)
        assert_equals(parse('x'), [1, 2, 8])

    def test_array_arg(self):
        assert_equals(parse('rest of [1,2,3]'), [2, 3])
        assert_equals(parse('rest of [1,2,3]'), [2, 3])

    def test_add_time(self):
        pass

    def test_add(self):
        parse('counter is one; repeat three times: increase counter; done repeating;')
        assert_equals(variables['counter'], 4)

    def _test_svg_dom(self):
        init('<svg><circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/></svg>')
        # print(svg(self.parser.interpretation(), ))
        parse('circle.color=green')
        assert_equals('circle.color', 'green')

    def test_incr(self):
        assert ('increase 1 == 2')
        assert ('increase 1 by 1 == 2')
        assert ('x=1; x+1 == 2')
        assert ('x=1; ++x == 2')
        # assert ('1++ == 2')
