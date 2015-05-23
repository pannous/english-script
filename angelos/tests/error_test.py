$use_tree = False
$verbose = False
require_relative('../parser_test_helper')


class ErrorTest:
    include(ParserTestHelper)

    def test_type():
        assert_has_error('x=1,2,y;')

    def test_variable_type_safety_errors2():
        assert_has_no_error("char i='c'")
        assert_has_no_error("char i;i='c'")

    def test_variable_type_safety_errors():
        assert_has_no_error('an integer i;i=3')
        assert_has_no_error('int i=3')
        assert_has_no_error('int i;i=3')
        assert_has_error('const i=1;i=2')
        assert_has_error('string i=3')
        assert_has_error("int i='hi'")
        assert_has_error("integer i='hi'")
        assert_has_error("an integer i;i='hi'")
        assert_has_error("const i=1;i='hi'")
        assert_has_error("const i='hi';i='ho'")

    def test_assert_has_error():pass

    def test_type3():
        assert_has_error('x be 1,2,3y= class of x')

    def test_map():
        assert_has_error('square 1,2 andy 3')

    def test_x():
        parse('x')

    def test_endNode_as():
        init('as')
         None 

    def test_rollback():
        assert_has_error('if 1>0 then else')

    def test_endNode():
        assert_has_error('of')

    def test_list_concatenation_unknownVariable():
        ] = variables
        ] = variables
        assert_has_error("z=x ' ' w")
        skip
        assert("z=x ' ' y")
        assert_has_error("z=x ' ' y")
        assert_has_no_error("z=x ' ' y")