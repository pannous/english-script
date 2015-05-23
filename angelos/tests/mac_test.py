$use_tree = False
require_relative('../parser_test_helper')


class MacTest:
    include(ParserTestHelper)

    def test_mail():pass

    def test_applescript():
        if !(ENV, None):
            skip
        parse('Tell application "Finder" to open home')

    def test_files():
        if !(ENV, None):
            skip
        ] = variables
        ] = variables
        assert('/Users/me == x')
        assert('my home folder == /Users/me')
        assert('my home folder == x')

    def test_files3():
        if !(ENV, None):
            skip
        skip
        init('my home folder = Dir.home')
        @parser.setter()
        init('my home folder == /Users/me')
        @parser.condition()
        init('/Users/me/.bashrc ok')
        p = @parser.linuxPath()
        init('Dir.home')
        r = @parser.rubyThing()
        parse('x := /Users/me ')
        assert('my home folder == /Users/me')
        assert('/Users/me == x')
        assert('my home folder == x')

    def test_variable_transitivity():
        if !(ENV, None):
            skip
        parse('my home folder = Dir.home ')
        parse('xs= my home folder ')
        assert('xs = /Users/me')

    def test_contains_file():
        if !(ENV, None):
            skip
        parse('xs= all files in Dir.home')
        p(('xs'))
        assert('xs contains .bashrc')
        parse('xs= Dir.home')
        assert('xs contains .bashrc')
        parse('xs=/Users/me')
        assert('xs contains .bashrc')
        parse('my home folder = Dir.home')
        parse('my home folder is Dir.home')
        p(variables)
        p(variableValues)
        assert()

    def test_contains_file2():
        if !(ENV, None):
            skip
        parse('my home folder = Dir.home')
        parse('xs = my home folder ')
        parse('xs = files in my home folder ')
        assert('xs contains .bashrc')
        skip
        parse('xs = all files in my home folder ')
        parse('xs shall be all files in my home folder ')