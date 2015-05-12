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
hi=4
print(hi)
def test_global():
    global hi,ho
    hi=5
    ho=6

def test_global2():
    print(ho)
test_global()
test_global2()
print(hi)
assert hi==5

the_expression=1
def subnode(param={}):
    print(param)
# subnode(statement= the_expression)
subnode({'statement':the_expression})

#
# def test_answer():
#     assert func(3) == 5

# test_answer()

def do_test(self):
    dir(self)

do_test()
