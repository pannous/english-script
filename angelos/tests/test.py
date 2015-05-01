# we are simply imported
# from _pytest.core import * #main, UsageError, _preloadplugins
# from _pytest import core as cmdline
# from _pytest import __version__
# _preloadplugins() # to populate pytest.* namespace so help(pytest) works
# import py.test
import unittest
# content of test_sample.py
# def func(x):
#     global x
#     def z():
#         global y
#         x=y+1
#     z()
#     return x + 1

def test_answer():
    assert func(3) == 5

test_answer()

def do_test(self):
    dir(self)

do_test()
