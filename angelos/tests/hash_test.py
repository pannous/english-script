$use_tree = False
$verbose = False
require_relative('../parser_test_helper')


class HashTest:
    include(ParserTestHelper)

    def test_hash_symbol_invariance_extension():
        a = None
        assert_equals((None), ('lhs'))
        h = parse('{"SuperSecret" : "kSecValueRef"}')
        assert_equals(('SuperSecret'), 'kSecValueRef')

    def test_json_data():
        init('{a{b:"b";c:"c"}}')
        @parser.json_hash()

    def test_invariances():
        assert_result_is('{a:"b"}', None)

    def test_invariances2():
        assert_equals(parse('{a{b:"b",c:"c"}}'), None)
        assert_equals(parse('{a{b:"b";c:"c"}}'), None)
        assert_equals(parse('{a:"b"}'), parse('{"a":"b"}'))
        assert_equals(parse('{:a => "b"}'), None)
        assert_equals(parse('{a:{b:"b";c:"c"}}'), None)

    def test_immediate_hash():
        assert_equals(parse('a{b:"b",c:"c"}'), None)
        skip('test_immediate_hash NO, because of blocks!')
        assert_equals(parse('a:{b:"b",c:"c"}'), None)