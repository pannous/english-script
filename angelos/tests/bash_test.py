$use_tree = $emit
$use_tree = False
require_relative('../parser_test_helper')


class BashTest:
    include(ParserTestHelper)

    def test_pipe():
        parse("bash 'ls -al' | column 1")