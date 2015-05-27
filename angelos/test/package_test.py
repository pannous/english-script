import _global
from parser_test_helper import *


class PackageTest(ParserBaseTest):
    

    def test_using(self):
        self.parser.dont_interpret()
        simple = parse('depends on stdio')
        assert_equals({'dependency': {'package': 'stdio', 'type': False, 'version': False, }, }, simple)
        dependency = parse('using c package stdio version >= 1.2.3')
        print(dependency)
        assert_equals({'dependency': {'package': 'stdio', 'type': 'c', 'version': '>= 1.2.3', }, }, dependency)