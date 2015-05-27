import _global
_global.use_tree = False
_global.verbose = False
from parser_test_helper import *


class HashTest(ParserBaseTest):
    

    # def test_hash_symbol_invariance_extension(self):
    #     a = {'a': 1, }
    #     assert_equals(a['a'], a[:a])
    #     h = parse('{"SuperSecret" : "kSecValueRef"}')
    #     assert_equals(h['SuperSecret'], 'kSecValueRef')

    def test_json_data(self):
        init('{a{b:"b";c:"c"}}')
        self.parser.json_hash()

    def test_invariances(self):
        assert_result_is('{a:"b"}', {'a': 'b', })
        assert_result_is('{a:"b"}', {'a': 'b', })

    def test_invariances2(self):
        assert_equals(parse('{a{b:"b",c:"c"}}'), {'a': {'c': 'c', 'b': 'b', }, })
        assert_equals(parse('{a{b:"b";c:"c"}}'), {'a': {'b': 'b', 'c': 'c', }, })
        assert_equals(parse('{a:"b"}'), parse('{"a":"b"}'))
        assert_equals(parse('{:a => "b"}'), {'a': 'b', })
        assert_equals(parse('{a:{b:"b";c:"c"}}'), {'a': {'b': 'b', 'c': 'c', }, })

    def test_immediate_hash(self):
        assert_equals(parse('a{b:"b",c:"c"}'), {'a': {'b': 'b', 'c': 'c', }, })
        skip('test_immediate_hash NO, because of blocks!')
        assert_equals(parse('a:{b:"b",c:"c"}'), {'a': {'b': 'b', 'c': 'c', }, })