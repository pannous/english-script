from unittest import TestCase
from parser import Parser
__author__ = 'me'


class TestParser(TestCase):
    p=Parser()
    _p=Parser
    global p,_p
    def fun(self):
        pass

    global fun

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


    def test_something(self):
        self.assertEqual(True, False)
        self.fail()

    def test_parse(self):
        self.assertIsInstance(p,Parser)
        self.assertRaises(Exception,p.parse)

    def test_parse(self):
        self.assertIsInstance(self.p,Parser)
        self.assertRaises(Exception,self.p.parse)
        self.assertRaises(Exception,self._p.parse)
