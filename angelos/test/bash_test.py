import _global
_global.use_tree = _global.emit
_global.use_tree = False
from parser_test_helper import *


class BashTest(ParserBaseTest):
    

    def test_pipe(self):
        parse("bash 'ls -al' | column 1")
        parse("bash 'ls -al' | column 1")