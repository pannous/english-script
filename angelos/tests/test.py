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
from globals import *
# import test2
# global ho
# ho='ho'
from test2 import test_global2
print(hi)
hi='test'
print(hi)
def test_global():
    hi='test_global'
    print(hi)
    print(ho)
test_global()
print(hi)
print(ho)
# test2.test_global2()
setHo()
test_global2()
print(hi)
print(ho)
# assert hi=='test_global2'
