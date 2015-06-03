from __future__ import print_function
import __builtin__
import extensions


global string, last_node, current_value, nodes, depth,rollback_depths,OK
global _verbose,use_wordnet,result,last_result
global tokenstream,current_token,current_type,current_word,current_line
global in_condition,in_pipe,in_args

_verbose =  True # False angel.verbose() and not angel.raking()  # false
very_verbose = _verbose

use_tree=False
use_wordnet=False
in_pipe=False
in_condition=False
in_args = False
interpret=False
did_interpret = False
javascript = ''
context = ''
variables = {}
variableTypes = {}
variableValues = {}  # ={nill: None)
methods = {'beep': extensions.beep,'puts':print_function,'print':print_function,'reverse':extensions.xstr.reverse}  # name->method-node
classes = {'list': extensions.xlist,'Math': extensions.Math}
c_methods = ['printf']
builtin_methods = ['puts', 'print']  # "puts"=>x_puts !!!
core_methods = ['show', 'now', 'yesterday', 'help']  # _try(difference)
# bash_methods=["say"]


string=""
tokenstream=[] # tuple:
token_map={} # directly map tokens to their functions
token_number=0
current_type=0
current_offset=0
current_word=''
current_line=''
current_token=None

lines = []
original_string = ""  # for string_pointer ONLY!!
string = ""
line_number = 0
last_pattern = None


OK = 'OK'
# result = ''
result=None
last_result=None
listeners = []
nodes = []

rollback = []
tree = []
interpret_border = -1
no_rollback_depth = -1
rollback_depths = []
max_depth = 160  # world this method here to resolve the string
negated=False
in_params=0
depth=0
current_node=None
current_value=None
parser=globals()
context=None
throwing=False
def is_number(s):            #isint isnum
  return isinstance(s,int) or isinstance(s,float) or isinstance(s,str) and s.isdigit() # is number isnumeric
debug=False # True

svg = []


def parent_node():
  return None