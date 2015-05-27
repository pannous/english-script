import _global
_global.use_tree = False
from parser_test_helper import *


class ObserverTest(ParserBaseTest):
    

    def _test_every_date1(self):
        parse('every 1 seconds { say "Ja!" }')
        parse('every 2 seconds do say "OK"')
        sleep(10000)

    def _test_every_date(self):
        parse('every 1 seconds do say "OK"')
        parse('beep every three seconds')
        parse('every two seconds puts "YAY"')
        parse('every minute puts "HURRAY"')
        parse('every five seconds do say "OK"')
        sleep(10000)

    def test_whenever(self):
        parse('beep whenever x is 5')
        parse('beep once x is 5')
        parse('once x is 5 do beep')
        parse('once x is 5 beep ')
        parse('x is 5')

    def test_whenever_2(self):
        skip('test this later')
        parse('whenever the clock shows five seconds do beep')
        assert(self.result.equals('1/3'))