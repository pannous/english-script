require_relative('../parser_test_helper')


class PackageTest:
    include(ParserTestHelper)

    def test_using():
        @parser.dont_interpret!()
        simple = parse('depends on stdio')
        assert_equals(None, simple)
        dependency = parse('using c package stdio version >= 1.2.3')
        puts(dependency)
        assert_equals(None, dependency)