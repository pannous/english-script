__author__ = 'me'

from power_parser import *
from english_parser import *

def root(self):
    pass


class Parser(object):

    # @property
    def parse(self,code):
        return parse(code).result
        # return root(self)
        # return self.root()

