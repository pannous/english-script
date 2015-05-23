# we are simply imported
# from _pytest.core import * #main, UsageError, _preloadplugins
# from _pytest import core as cmdline
# from _pytest import __version__
# _preloadplugins() # to populate pytest.* namespace so help(pytest) works
# import py.test
import unittest
# import test
# content of test_sample.py
# def func(x):
#     global x
#     def z():
#         global y
#         x=y+1
#     z()
#     return x + 1
from globals import *
# from globals import ho
# from test import ho
print(hi)
hi='test2'

def test_global2():
    global hi,ho
    print("in test_global2: "+hi)
    print(ho)
    hi='test_global2'
