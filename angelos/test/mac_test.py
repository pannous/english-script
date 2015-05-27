import _global
_global.use_tree = False
from parser_test_helper import *


class MacTest(ParserBaseTest):
    

    def test_mail(self):
        pass

    def test_applescript(self):
        if (ENV['APPLE'], ):
            skip()
        parse('Tell application "Finder" to open home')

    def test_files(self):
        if (ENV['APPLE'], ):
            skip()
        variables['x'] = ['/Users/me', ]
        variables['my home folder'] = ['/Users/me', ]
        assert('/Users/me == x')
        assert('my home folder == /Users/me')
        assert('my home folder == x')

    def test_files3(self):
        if (ENV['APPLE'], ):
            skip()
        skip()
        init('my home folder = Dir.home')
        self.parser.setter()
        init('my home folder == /Users/me')
        self.parser.condition()
        init('/Users/me/.bashrc ok')
        p = self.parser.linuxPath()
        init('Dir.home')
        r = self.parser.rubyThing()
        parse('x := /Users/me ')
        assert('my home folder == /Users/me')
        assert('/Users/me == x')
        assert('my home folder == x')

    def test_variable_transitivity(self):
        if (ENV['APPLE'], ):
            skip()
        parse('my home folder = Dir.home ')
        parse('xs= my home folder ')
        assert('xs = /Users/me')

    def test_contains_file(self):
        if (ENV['APPLE'], ):
            skip()
        parse('xs= all files in Dir.home')
        p(variables['xs'])
        assert('xs contains .bashrc')
        parse('xs= Dir.home')
        assert('xs contains .bashrc')
        parse('xs=/Users/me')
        assert('xs contains .bashrc')
        parse('my home folder = Dir.home')
        parse('my home folder is Dir.home')
        p(variables())
        p(variableValues())
        assert()

    def test_contains_file2(self):
        if (ENV['APPLE'], ):
            skip()
        parse('my home folder = Dir.home')
        parse('xs = my home folder ')
        parse('xs = files in my home folder ')
        assert('xs contains .bashrc')
        skip()
        parse('xs = all files in my home folder ')
        parse('xs shall be all files in my home folder ')