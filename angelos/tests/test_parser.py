from unittest import TestCase
from parser import Parser
# from core.parser import Parser
# from core import parser
# from core import power_parser
# from core import *
__author__ = 'me'


class TestParser(TestCase):
    global p,_p
    p=Parser()
    _p=Parser
    global fun

    def fun(self):
        pass


    def setUp(self):
        # p=Parser() # CANT BE ASSIGNED without double global
        global p
        p=Parser() # CAN BE ASSIGNED!!!
        self._p=_p # generator
        self.p=p   # instance!
        # self._p=Parser # generator
        # self.p=Parser()#  fresh  instance!

    @classmethod
    def setUpClass(cls):
        pass # reserved for expensive environment one time set up

    def test_globals(self):
        self.assertIsInstance(p,Parser)

    def test_globals2(self):
        self.assertEquals(p,self.p)


    def test_parse(self):
        six=p.parse("3+3")
        print(six)
        assert six==6

    def test_parser(self):
        self.assertIsInstance(p,Parser)
        self.assertRaises(Exception,p.parse)

    def test_parser1(self):
        self.assertIsInstance(self.p,Parser)
        self.assertRaises(Exception,self.p.parse)
        self.assertRaises(Exception,self._p.parse)
