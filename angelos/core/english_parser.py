#!/usr/bin/env python
# encoding: utf-8
import ast
import tree

# global inside_list
# inside_list=False
# import time
# import traceback
# import sys
# import __builtin__ # class function(object) etc
import inspect
# import kast
from kast import *
import re
import __builtin__
import traceback
import sys
import HelperMethods

import interpretation
# import HelperMethods
from nodes import Function, Argument, Variable, Property, Condition
from nodes import FunctionCall
import power_parser
from power_parser import *
from english_tokens import *
from angle import *
from extensions import *
import token as _token
import the
# from the import the.string
from tree import TreeNode
def parent_node():
    pass
# ## global the.string

class Todo:
    pass

def _try(block):
    return maybe(block)

def _(x):
    return power_parser.token(x)

# class Nil(object):
#     pass
#
# class Nill(Nil):
#     pass

def nill():
    return __(nill_words)


def boolean():
    b = __('True', 'False','true', 'false')
    the.result = (b == 'True' or b=='true') and TRUE or FALSE
    return the.result


def should_not_start_with(words):
    bad = starts_with(words)
    if not bad: return OK
    if bad: info("should_not_match DID match #{bad)")
    if bad: raise ShouldNotMatchKeyword(bad)


def remove_from_list(keywords0, excepty):
    good=list(keywords0)
    for x in excepty:
        if x in good:
            good.remove(x)
    return good

def no_keyword_except(excepty=None):
    if not excepty:
        excepty = []
    bad=remove_from_list( keywords ,excepty)
    return should_not_start_with(bad)


def no_keyword():
    return no_keyword_except([])


def constant():
    return tokens(constants)


def it():
    __(result_words)
    return the.last_result


def value():
    global current_value
    if the.current_type==_token.STRING:
        return quote()
    if the.current_type==_token.NUMBER:
        return number()
    current_value = None
    no_keyword_except(constants + numbers + result_words + nill_words + ['+', '-'])
    the.result = maybe(quote) or \
            maybe(nill) or \
            maybe(number) or \
            maybe(true_variable) or \
            maybe(boolean) or \
            maybe(constant) or \
            maybe(it) or \
            maybe(nod) or \
            raise_not_matching("Not a value")
    if ___('as'):
        typ = typeNameMapped()
        the.result = cast(the.result, typ)
    return the.result

# def maybe(f):
#     _try(f)
#
# def word():
#     pass
#
#
# def ruby_require(dependency):
#     pass
#
#
# def rest_of_line():
#     pass
#
#
# def maybe_token(comparison_words):
#     pass
#
#
# def _(token):
#     token(token)
#
#
# def regex():
#     pass


def __(*tokens0):
    return tokens(tokens0)

def ___(*tokens0):
    return maybe_tokens(tokens0)


    # !!!
    # import TreeBuilder
    # import CoreFunctions
    # import EnglishParserTokens # module
    # import LoopsGrammar # while, as long as, :.
    # import RubyGrammar # def, :.
    # import Betty # convert a.wav to mp3
    # import ExternalLibraries

    # attr_accessor :methods, :result, :last_result, :interpretation, :variables, :variableValues,:variableType #remove the later!


def interpretation():
    import interpretation
    interpretation = interpretation.Interpretation()
    i = interpretation  # Interpretation.new
    i.result = the.result
    i.error_position = error_position()
    # super  # set tree, nodes
    i.javascript = javascript
    i.context = context
    i.methods = the.methods
    i.ruby_methods = builtin_methods
    i.variables = the.variables
    i.svg = svg
    return i

    # beep when it rains
    # listener




    # todo vs checkNewline() ??


def end_expression():
    return checkEndOfLine() or token(';')

def raiseSyntaxError():
    raise SyntaxError("incomprehensible input")

def rooty():
    block()
    # maybe(block) or \
    #  maybe(statement) or \
    #    raiseSyntaxError()# raise_not_matching("")
      # maybe(expressions) and end_expression() or\
      # maybe(condition) or \
      # maybe(context) or \
    return the.result
    # # maybe( ruby_def )or\ # SHOULD BE just as method_definition !!:


def set_context(context):
    context = context

def module():
    __("class package context gem library".split())  # source:
    return set_context(rest_of_line())


def javascript_require(dependency):
    # import bindingsr'js'javascript_auto_libs
    # import javascript_auto_libs
    dependency = dependency.replace(r'.* ', "")  # require javascript bla.js
    return dependency
    # mapped    =$javascript_libs[dependency]
    # if mapped: dependency=mapped
    # javascript.append("javascript_require(): #{dependency));")


def includes(dependency, type, version):
    if re.search(r'\.js$'): return javascript_require(dependency,dependency)
    if type and "javascript script js".split().has(type): return javascript_require(dependency)
    # if not type or "ruby gem".split().has(type): return ruby_require(dependency)

    # #{escape_token t)


def regex(x):
    ## global the.string
    match = re.search(x,the.string)
    match = match or re.search(r'(?im)^\s*%s'%x,the.string)
    if not match: raise NotMatching(x)
    the.string = the.string[match.end():].strip()
    return match

def package_version():
    maybe_token('with')
    c = maybe_token(comparison_words)
    __('v'), 'version'
    c = c or maybe_token(comparison_words)
    subnode({'bigger': c})
    # current_value=
    the.result = c + " " + regex('\d(\.\d)*')[0]
    ___("or later")
    return the.result

    # (:use [native])

#
# def _try(quote):
#     pass

@Starttokens(import_keywords)
def requirements():
    type = ___(require_types)
    __(import_keywords)
    type = type or ___(require_types)
    ___("file script header source src".split())
    ___('gem', 'package', 'library', 'module', 'context')
    type = type or ___(require_types)
    # _try(source) _try(really)
    dependency = _try(quote)
    no_rollback(5)
    # _try(list_of){packages)
    dependency = dependency or word()  # regex "\w+(\/\w*)*(\.\w*)*\.?\*?" # rest_of_line
    version = maybe(package_version)
    if interpreting(): includes(dependency, type, version)  #
    the.result = {'dependency': {'type': type, 'package': dependency, 'version': version}}
    return the.result


@Starttokens(context_keywords)
def context():
    __(context_keywords)
    context = word()
    newlines() # part of block?
    # NL
    block()
    done()  # done context!!!
    return context

# @Starttokens('(')
def bracelet():
    subnode({'brace': _('(')})
    a=algebra()
    subnode({'brace': _(')')})
    return a

@Starttokens(operators)
def operator():
    # if current_type==_token.OP ok
    return tokens(operators)


def algebra():
    # global result
    must_contain_before(args=operators,before=[be_words, ',', ';', ':'])
    stack={}
    stack[0]=the.result= maybe(value) or bracelet()  # any { maybe( value ) or maybe( bracelet ) )
    def lamb():
        op = operator()  # operator KEYWORD!?! ==> the.string="" BUG     4 and 5 == TROUBLE!!!
        if not op == 'and': no_rollback()
        y = maybe(value) or bracelet()
        if interpreting():  # and not angel.use_tree:
            if op == "/":  # 3'4==0 ? NOT WITH US!!:
                y=float(y)
            try:
                stack[0]=the.result = do_send(stack[0], op, y or the.result)
            except SyntaxError as e:
                error(e)
            # except Exception as e:
            #     raise e
        return the.result or True
    the.result=star(lamb)
#         if angel.use_tree and not interpreting():
#             return parent_node()
#         # the.result=result
#         if angel.use_tree and interpret:
#             tree = parent_node()
#             if tree: the.result = tree.eval_node(variableValues, the.result)  # except the.result #wasteful!!
#         return the.result
    return the.result


def read_block(type=None):
    block = []
    start_block(type)
    while True:
        if _try(lambda: end_block(type)): break
        block.append(rest_of_line)
    return subnode(type or {'block': block})

@Starttokens(["<html>"])
def html_block():
    return read_block('html')


@Starttokens(['js','script','javascript'])
def javascript_block():
    block = maybe(read_block('script')) or maybe(read_block('js')) or read_block('javascript')
    javascript.append(block.join(";\n"))
    return block

@Starttokens(['ruby'])
def ruby_block():
    return read_block('ruby')


def special_blocks():
    return _try(html_block) or _try(ruby_block) or javascript_block()

    # or end_expression #end_block #newlines

    # see read_block for RAW blocks! (</EOF> type)
    # EXCLUDING start_block & end_block !!!



def nth_item():  # Also redundant with property evaluation (But okay as a shortcut)):
    set = maybe_token('set')
    n = __(numbers + ['first', 'last', 'middle'])
    n=xstr(n).parse_integer()
    if(n>0):n=n-1  # -1 AppleScript style !!! BUT list[0] !!!
    raiseEnd()
    maybe_tokens(['.','rd','st','nd'])
    type = ___(['item', 'element', 'object', 'word', 'char', 'character']+ type_names)  # noun
    ___('in', 'of')
    l = resolve(_try(true_variable)) or _try(liste) or quote() # or (expression) with parenthesis!!
    if re.search(r'^char',type):
        the.result = "".join(l).__getitem__(n)
        return the.result
    if type in type_names:
        l = l.select(lambda x: isinstance(x,type)) # or x.is_a(type)!
    elif isinstance(l,str):
        l = l.split(" ")
    the.result = l[n] #.__getitem__(n)
    if angle.in_condition:
        return the.result
    if set and _('to'): # or maybe_tokens(be_words): #LATER
        val = endNode()
        l[n] = do_evaluate(val)
    return the.result


def listselector():
    return _try(nth_item) or functionalselector()

    # DANGER: INTERFERES WITH _try(LIST), NAH, NO COMMA: {x > 3)

@Starttokens(['{'])
def functionalselector():
    _('{')
    xs = true_variable()
    crit = selector()
    _('}')
    return filter(xs, crit)

@Starttokens(['[','(','{'])
def liste(check=True):
    global inside_list
    if the.current_word == ',': raise NotMatching()
    if check: must_contain_before([be_words, operators ], ',') #- ['and']
    # +[' '] ???
    start_brace = ___('[', '{', '(')  # only one!
    if not start_brace and inside_list: raise NotMatching('not a deep list')

    # all<<expression(start_brace)
    # angel.verbose=True #debug
    inside_list = True
    first = _try(endNode)
    if not first: inside_list = False
    if not first: raise_not_matching()
    all = [first]
    star(lambda: tokens([',', 'and']) and all.append(endNode))
    # all<<expression
    # danger: and as plus! BAD IDEA!!!
    if start_brace == '[': _(']')
    if start_brace == '{': _(')')
    if start_brace == '(': _(')')
    inside_list = False
    current_value = all
    return all

def must_contain_substring(param): # ++ != '+' '+' tokens :(
    current_statement=re.split(';|:|\n',the.current_line[the.current_offset:])[0]
    if not param in current_statement:
        raise_not_matching("must_contain_substring(%s)"%param)


def plusPlus():
    must_contain_substring('++')
    start=pointer()
    pre=maybe_token('+') and token('+')
    v = variable_name()
    pre or _('+') and token('+')
    if not interpreting(): return ast.AugAssign(ast.Name(v.name, ast.Store()), ast.Add(), ast.Num(1))
    the.result = do_evaluate(v, v.type) + 1
    the.variableValues[v.name] = v.value = the.result
    return the.result


def minusMinus():
    must_contain_substring('--')
    pre=maybe_token('-') and token('-')
    v = variable_name()
    pre or _('-') and token('-')
    if not interpreting():
        return ast.AugAssign(ast.Name(v.name, ast.Store()), ast.Sub(), ast.Num(1))
    the.result = do_evaluate(v, v.type) + 1
    variableValues[v] = v.value = the.result
    return the.result


def selfModify():
    return maybe(plusEqual) or maybe(plusPlus) or minusMinus()

#
# @Interpret
@Starttokens(self_modifying_operators)
def plusEqual():
    must_contain(self_modifying_operators)
    v = variable_name()
    mod = ___(self_modifying_operators)
    exp = expression()  # value
    arg = do_evaluate(exp, v.type)
    if not interpreting():
        op=tree.operator_equals(mod)
        return ast.AugAssign(ast.Name(v.name, ast.Store()), op, arg)
    else:
        the.result=interpretation.self_modify(v,mod,arg)
        the.variableValues[v.name] = the.result
        v.value = the.result
        return the.result

@Starttokens('[')
def swift_hash():
    _('[')
    h = {}
    def hashy():
        if len(h) > 0: _(',')
        ___('"', "'")
        key = word()
        ___('"', "'")
        _(':')
        angle.inside_list = True
        h[key] = expression()  # no
        the.result ={key:h[key]}
        return the.result
    star(hashy)
    _(']')
    angle.inside_list = False
    return h


def close_bracket():  # for nice GivingUp):
    return _(')')


def json_hash():
    must_contain(":", "=>", {'before':")"})
    # z=_try(regular_json_hash) or immediate_json_hash RUBY BUG! or and  or  act very differently!
    z = _try(regular_json_hash) or immediate_json_hash()
    return z

    # colon for types not _try(Compatible) puts a:int vs puts {a:int) ? maybe egal
    # careful with blocks!! {puts "s") VS {a:"s")

@Starttokens('{')
def regular_json_hash():
    _('{')
    maybe_token(':') and no_rollback()  # {:a:.) Could also mean list of _try(symbols) Nah
    h = {}

    def lamb():
        if len(h) > 0: ___(';', ',')
        quoted = ___('"', "'")
        key = word()
        if quoted: __('"', "'")
         # Property versus hash !!
        ___('=>', '=') or starts_with("{") or ___('=>', ':')
        inside_list = True
        # h[key] = expression0 # no
        h[the.result] = expression()

    star(lamb)
    # no_rollback()
    close_bracket()
    inside_list = False
    return h

    # _try(expensive)
    # careful with blocks/closures ! map{puts it) VS data{a:"b")


def evaluate_index(args):
    pass


def starts_with_(param):
    return _try(lambda: starts_with(param))


def immediate_json_hash():  # a:{b) OR a{b():c)):
    # must_contain_before ":{", ":"
    w = word()  # expensive
    # _try(lambda:starts_with("={")) and maybe_token('=') or:c)
    starts_with_("{") or _('=>')  # or _(':') disastrous :  BLOCK START!
    no_rollback()
    r = regular_json_hash()
    return {str(the.result): r}  # AH! USEFUL FOR NON-symbols !!!
# todo PYTHONBUG ^^

# def postoperations(context):
#     maybe(

def quick_expression():
    if the.current_word in the.token_map:
        fun = the.token_map[the.current_word]
        the.result = fun()
        if the.current_word in operators or the.current_word in special_chars: # - ';'
            raise_not_matching("quick_expression too simplistic")
        return the.result
    return False

def expression(fallback=None):
    start = pointer()
    the.result = ex = maybe( quick_expression ) or \
                      maybe( algebra ) or \
                      maybe( json_hash ) or \
                      maybe( swift_hash ) or \
                      maybe( evaluate_index ) or \
                      maybe( listselector ) or \
                      maybe( liste ) or \
                      maybe( evaluate_property ) or \
                      maybe( selfModify ) or \
                      maybe( endNode ) or \
                      print_pointer(True) and raise_not_matching("Not an expression")

    # ex=postoperations(ex) or ex
    check_comment()

    if not interpreting():
        if not angle.use_tree:
            return ( start , pointer())
        return the.result

    if ex and interpreting():
        the.last_result = the.result = do_evaluate(ex)
        # TODO PYTHON except SyntaxError:
    if not the.result or the.result == SyntaxError and not ex == SyntaxError:
        pass
        # keep false
    else:
        ex = the.result
    # NEIN! print('hi' etc etc)
    # if the.result.isa(Quote): more=_try(expression0)
    # more=more or _try(quote) #  "bla " 7 " yeah"
    # if more.isa(Quote) except "": more+=_try(expression0)
    # if more: ex+=more
    # subnode (expression: ex)
    if ex==ZERO: ex=0 # HERE ?
    the.result = ex
    return the.result


def piped_actions():
    if the.in_pipe: return False
    must_contain("|")
    the.in_pipe = True
    a = statement()
    token('|')
    no_rollback()
    c = true_method() or bash_action()
    args = star(arg)
    if callable(c): args = [args, Argument(value=a)]  # with owner
    if interpreting():
        the.result=do_send(a, c, args)
        print(the.result)
        return the.result
    else:
        return OK



def statement():
    raiseNewline()  # _try(really) _try(why)
    if checkNewline(): return NEWLINE
    x=  maybe(loops) or \
        maybe(if_then_else) or \
        maybe(action_if) or \
        maybe(once) or \
        maybe(piped_actions) or \
        maybe(declaration) or \
        maybe(setter) or \
        maybe(returns) or \
        maybe(requirements) or \
        maybe(method_definition) or \
        maybe(assert_that) or \
        maybe(breaks) or \
        maybe(constructor) or \
        maybe(action) or \
        maybe(expression) or \
        raise_not_matching("Not a statement")
         # AS RETURN VALUE! DANGER!
    if x:
        the.result = x
    else:
        print "WTF?"
    check_comment()
    return the.result

    # one :action, :if_then ,:once , :looper
    # any{action  or  if_then  or  once  or  looper)

# nice optional return 'as':
# define sum x,y as:
#     x+y
# end
# define the sum of numbers x,y and z as number x+y+z
@Starttokens(method_tokens)
def method_definition():
    # annotations=_try(annotations)
    # modifiers=_try(modifiers)
    tokens(method_tokens)  # how to
    no_rollback()
    name = _try(noun) or verb  # integrate or word
    # obj=maybe( endNode ) # a sine wave  TODO: invariantly get as argument book.close==close(book)
    maybe_token('(')
    args = []
    def lamb():
        # nonlocal arg_nr #  python 3 , for python 2 there's no simple workaround, unfortunately SHOWSTOPPER!!!
        # global arg_nr #  python 3 , for python 2 there's no simple workaround, unfortunately SHOWSTOPPER!!!
        in_params = True
        a = arg(len(args))
        maybe_token(',')
        args.append(a)
    star(lamb)  # over an interval
    return_type = ___('as', 'return', 'returns', 'returning','=','->') and _try(typeNameMapped) #return_type or

    in_params = False
    maybe_token(')')
    allow_rollback  # for
    dont_interpret()
    b = action_or_block  # define z as 7 allowed !!!
    f = Function(name=name, arguments=args, return_type=return_type, body=b)
    # ,modifiers:modifiers, annotations:annotations
    methods[name] = f or parent_node() or b
    # # with args! only in tree mode!!
    return f or name


def raise_not_matching(msg=None):
    raise NotMatching(msg)


def execute(command):
    import os
    os.system(command)
    # NOT: exec(command) !! == eval

@Starttokens('bash')
def bash_action():
    # import bindingsr'shell'bash-commands
    ok = starts_with(['bash'] + bash_commands)
    if not ok: raise_not_matching("no bash commands")
    remove_tokens('execute', 'command', 'commandline', 'run', 'shell', 'shellscript', 'script', 'bash')
    command = maybe(quote)  # danger bash "hi">echo
    command = command or rest_of_line
    subnode({'bash':command})
    # any{ _try(  ) or   statements )
    if interpreting():
        try:
            print('going to execute ' + command)
            the.result = execute(command)
            print('the.result:')
            print(the.result)
            if the.result:
                return the.result.split("\n")
            else:
                return True
        except:
            print('error (e)xecuting bash_action')

    return False

@Starttokens(if_words)
def if_then_else():
    ok=if_then()  # todo :if 1 then False else: 2 => 2 :(: ok      =
    # if ok == False:
    #     ok = FALSE
    o = _try(otherwise) or FALSE
    if ok != "OK" and ok !=False: #and ok !=FALSE:
        the.result=ok
    else:
        the.result=o
    return the.result


def action_if():
    must_contain('if')
    a = action_or_expressions
    _('if')
    c = condition_tree()
    if interpreting():
        if check_condition(c):
            return do_execute_block(a)
        else:
            return OK  # false but block ok!
    return a


def if_then():
    __(if_words)
    no_rollback()  # 100
    c = condition_tree()
    if c == None: raise InternalError("no condition_tree")
    # c=condition()
    maybe_token('then')
    maybe_token(':')
    dont_interpret()  # if not c  else: dont do_execute_block twice!:
    b = expression_or_block()  # action_or_block()
    # o=_try(otherwise)
    # if use_block: b=block
    # if not use_block: b=statement
    # if not use_block: b=action()
    allow_rollback()
    if c==False: return c
    if interpreting():
        if check_condition(c):
            return do_execute_block(b)
        else:
            return OK  # o or  false but block ok!
    return b

@Starttokens(once_words)
def once_trigger():
    __(once_words)
    dont_interpret()
    c = condition()
    no_rollback()
    maybe_token('then')
    use_block = _try(start_block)
    if not use_block: b = action and end_expression
    if use_block: b = block and done
    interpretation.add_trigger(c, b)


def _do():
    return _try(lambda : _('do'))

@Starttokens('do')
def action_once():
    if not _do() and newline: must_contain(once_words)
    no_rollback()
    b = action_or_block()
    # _do=maybe_token('do')
    # dont_interpret()
    # if not _do: b=action()
    # if _do: b=block and _try(done)
    __(once_words)
    c = condition()
    end_expression
    interpretation.add_trigger(c, b)


def once():
    # or  'as soon as' condition \n block 'ok'
    #	 or  'as soon as' condition 'then' action;
    maybe(once_trigger) or action_once


# or  action 'as soon as' condition()

#/*n_times
#	 verb number 'times' preposition nod -> "<verb> <preposition> <nod> for <number> times" 	*/
#r'*	 verb number 'times' preposition nod -> ^(number times (verb preposition nod)) # Tree ~= lisp	*'
def verb_node():
    v = verb
    nod
    if not v in methods: raise UnknownCommandError('no such method: ' + v)
    return v
    #end_expression


def spo():
    # NotImplementedError
    if not use_wordnet: return False
    if not use_wordnet: raise NotMatching("use_wordnet==false")
    s = endNoun
    p = verb
    o = nod
    if interpreting(): return do_send(s, p, o)


def print_variables():
    return ''.join(['%s=%s'%(v,k) for v,k in variables.iteritems()])


@Starttokens(invoke_keywords)
def extern_method_call():
    call = __(invoke_keywords)
    if call: no_rollback()
    ruby_method = ___(builtin_methods + core_methods)
    if not ruby_method: raise UndefinedRubyMethod(word())
    args = rest_of_line
    # args=substitute_variables rest_of_line
    if interpreting():
        try:
            the_call = ruby_method + ' ' + str(the.result)
            # print_variables=variableValues.inject("") ? (lambda x: x==False )={v[1].is_a(the.string) ? '"'+v[1]+'"' : v[1]);"+s )
            the.result = eval(print_variables() + the_call) or ''
            verbose(the_call + '  called successfully with result ' + str(the.result))
            return the.result
        except SyntaxError as e:
            print("\n!!!!!!!!!!!!\n ERROR calling #{the_call)\n!!!!!!!!!!!! #{e)\n ")
        # except Exception as e:
        #     print("\n!!!!!!!!!!!!\n ERROR calling #{the_call)\n!!!!!!!!!!!! #{e)\n ")
        #     import traceback
        #     error(traceback.extract_stack())
        #     print('!!!! ERROR calling ' + the_call)

    checkNewline()
    #raiseEnd
    subnode({'method':ruby_method})  #why not _try(auto})?
    subnode({'args':args})
    current_value = ruby_method
    return current_value
    # return Object.method ruby_method.to_sym
    # return Method_call(ruby_method,args,:ruby)


def is_object_method(m):
    if not str(m) in globals(): return False
    if callable(m) and str(m) in globals():
        return m #'True'
    object_method = globals()[m] #.method(m)
    return object_method # 'True' ;)
    # Object.constants  :IO, :STDIN, :STDOUT, :STDERR :.:Complex, :RUBY_VERSION :.


def has_object(m):
    return str(m) in globals()


def has_args(method, clazz=object, assume=False):
    if method in ['invert', '++', '--']:  # increase by 8:
        return False
    if not callable(method):
        if method in methods:
            method = methods[method]
        # if method in the.methods:
        #     method = the.methods[method]
        if not isinstance(clazz, type):  #lol:
            clazz = type(clazz)
        if method in dir(clazz):
            method = getattr(clazz, method)
    args, varargs, varkw, defaults=inspect.getargspec(method)
    return len(args)+len(defaults)+len(varkw)> 0 or assume


def c_method():
    return tokens(c_methods)


def builtin_method():
    w = word
    if not w: raise_not_matching("no word")
    # if w.title() == w: raise_not_matching("capitalized #{w) no builtin_method")
    m = is_object_method(w)
    # m = m or HelperMethods.method(w)
    return m
    # m ? m.name : None


def true_method():
    no_keyword()
    should_not_start_with(auxiliary_verbs)
    # _try(lambda:tokens(methods.keys+"ed")) sorted files -> sort files ?
    v = maybe_tokens(c_methods) or maybe_tokens(methods.keys) or maybe_tokens(core_methods) or maybe_tokens(builtin_methods) or _try(builtin_method) or _try(verb)
    if not v: raise NotMatching('no method found')
    return v  #.to_s


def strange_eval(obj):
    maybe_token('(')
    args = star(arg)
    _(')')
    the.result = do_evaluate_property(obj,args)
    return the.result
    # conflict with files, 3.4


def thing_dot_method_call():
    must_contain_before(['.'],['='])  # before:.?
    obj = endNode()
    if maybe_token('(') and interpreting(): return strange_eval(obj)
    _('.')
    return method_call(obj)


def method_call(obj=None):
    # _try(ruby_method_call)  or
    return _try(thing_dot_method_call) or generic_method_call(obj)

    # read mail or bla(1) or a.bla(1)  vs ruby_method_call !!


def generic_method_call(obj=None):
    #verb_node
    method =true_method()
    start_brace = ___('(', '{')  # '[', list and closure danger: index)
    # todo  ?merge with _try(liste)
    if start_brace: no_rollback()
    if is_object_method(method):  #todo  not has_object(method) is_class_method:
        obj = obj or object
    else:
        maybe_token('of')
        if angle.in_args: obj = maybe(_try(nod))
        if not angle.in_args: obj = _try(nod) or _try(liste)
        # print(sorted files)
        # if not in_args: obj=maybe( _try(nod)  or  _try(list)  or  expression )

    assume_args = True  # not starts_with("of")  # True    #<< Redundant with property eventilation!
    if has_args(method, obj, assume_args):
        current_value = None
        angle.in_args = True
        args = star(arg)
        if not args: args = obj
        # ___( ',','and')
    else:
        more = maybe_token(',')
        if more: obj = [obj] + liste(False)

    angle.in_args = False
    if start_brace == '(': _(')')
    if start_brace == '[': _(']')
    if start_brace == '{': _(')')
    subnode({'object':obj})
    subnode({'arguments':args})
    if not interpreting(): return FunctionCall(name=method, arguments=args, object=obj)  #parent node!!!
    the.result = do_send(obj, method, args)
    return the.result


def tokens_(tokens0):
    return ___(tokens0)


@Starttokens(bla_words)
def bla():
    return tokens_(bla_words)

@Starttokens('tell')
def applescript():
    _('tell')
    tokens('application', 'app')
    no_rollback()
    app = quote
    the.result = "tell application \"#{app)\""
    if maybe_token('to'):
        the.result += ' to ' + rest_of_line()  # "end tell"
    else:  #Multiline
        while the.string and not the.string.contains('end tell'):
            # #TODO deep blocks! simple 'end' : and not the.string.contains('end')
            the.result += rest_of_line() + "\n"

            # ___ "end tell","end"

    # the.result        +="\ntell application \"#{app)\" to activate" # to front
    # -s o r'path'tor'the'script.scpt
    if interpreting(): the.result = execute("'usr'bin/osascript -ss -e $'#{the.result)'")
    return the.result

@Starttokens('assert')
def assert_that():
    _('assert')
    maybe_token('that')
    # s=statement()
    s=condition()
    if interpreting():
        assert check_condition(s)
    return s


def arguments():
    return star(arg)

def maybe_token(x):
    if x==the.current_word:
        next_token()
        return x
    return False

@Starttokens(['create','new','init'])
def constructor():
    ___('create','init')# define
    the_()
    _('new')
    # clazz=word #allow data
    clazz = class_constant
    do_send(clazz, "__init__", arguments)
    # clazz=Class.new
    # variables[clazz]=
    # clazz(arguments)

@Starttokens(['return','returns'])
def returns():
    __('return','returns')
    the.result = _try(expression)
    the.result

@Starttokens(flow_keywords)
def breaks():
    __(flow_keywords)


#	 or 'say' x=(.*) -> 'bash "say $quote"'
def action():
    start = pointer()
    maybe(bla)
    the.result = maybe(special_blocks) or \
        maybe(applescript) or \
        maybe(bash_action) or \
        maybe(evaluate) or \
        maybe(returns) or \
        maybe(selfModify) or \
        maybe(method_call) or \
        maybe(spo) or \
        raise_not_matching("Not an action")
    #_try( verb_node ) or
    #_try( verb )
    if not interpreting():
        if not angle.use_tree: return (start,pointer())
    return the.result # value or AST


def action_or_block():  # expression_or_block ??):
    if not starts_with([';',':', 'do', '{','begin','start']):
        a = maybe(action)
        if a: return a
    # type=start_block && newline22
    b = block()
    # end_block()
    return b


def expression_or_block():  # action_or_block):
    a = maybe(action) or maybe(expression)
    if a: return a
    b = block()
    return b


def end_block(type=None):
    return done(type)


def done(_type=None):
    if _type and _try(lambda: close_tag(_type)): return OK
    if checkEndOfLine(): return OK
    checkNewline()
    ok = tokens(done_words)
    if _type: token(_type)
    ignore_rest_of_line()
    return ok


# used by done / end_block()
def close_tag(type):
    _('</')
    _(type)
    _('>')
    return type


def call_function(f, args=None):
    if(callable(f)):
        if(args):return f(args)
        else:return f()
    return do_send(f.object, f.name, args or f.arguments)


def do_execute_block(b, args={}):
    if not interpreting(): return
    global variableValues
    if not b: return False
    if b==True: return True
    if isinstance(b, FunctionCall): return call_function(b)
    if callable(b): return call_function(b, args)
    if isinstance(b,ast.AST):
        exec(b) # TODO ARGS???
    if isinstance(b, TreeNode): b = b.content
    if not isinstance(b, str): return b  # OR :. !!!
    block_parser = the# EnglishParser()
    block_parser.variables = variables
    block_parser.variableValues = variableValues
    if not isinstance(args, dict): args = {'arg': args}
    for arg, val in args.iteritems():
        if arg in block_parser.variables:
            v = block_parser.variables[arg]
            # v = v.clone
            v.value = val
            block_parser.variables[str(arg)] = v  # to_sym todo NORM in hash!!!
        else:
            block_parser.variables[str(arg)] = Variable(name=arg, value=val)
    # block_parser.variables+=args
    try:
        the.result = block_parser.parse.result
    except:
        error(traceback.extract_stack())
    variableValues = block_parser.variableValues
    return the.result

def datetime():
    # Complicated stuff!
    # later: 5 secs from now  , _(5pm) == AT 5pm
    must_contain(time_words)
    _kind = tokens(event_kinds)
    no_rollback()
    ___('around', 'about')
    # import chronic_duration
    # WAH! every second  VS  every second hour WTF ! lol
    n = _try(number) or 1  # every [1] second
    _to = maybe(lambda: tokens(['to', 'and']))
    if _to: _to = number()
    _unit = __(time_words)  # +["am"]
    _to = _to or ___('to', 'and')
    if _to: _to = _to or _try(number)
    # return events.Interval(_kind, n, _to, _unit)


def collection():
    return any(lambda:
        maybe(ranger) or
        maybe(true_variable) or
        action_or_expressions()  #of type list !!
        )

@Starttokens('for')
def for_i_in_collection():
    must_contain('for')
    maybe_token('repeat')
    ___('for', 'with')
    maybe_token('all')
    v = variable_name()  # selector() !
    ___('in', 'from')
    c = collection()
    b = action_or_block()
    for i in c:
        v.value=i
        the.result=do_execute_block(b)
    return the.result

#  until_condition ,:while_condition ,:as_long_condition()

def assure_same_type(var, type):
    if var.name in variableTypes:
        oldType = variableTypes[var.name]
    else:
        oldType=None
    # try:
    if oldType and type and not type <= oldType: raise WrongType("#{var.name} has type #{oldType), can't set to #{type)")
    if oldType and var.type and not var.type <= oldType: raise WrongType("#{var.name} has type {oldType), can't set to #{var.type)")
    if type and var.type and not (var.type <= type or var.type >= type): raise WrongType("#{var.name} has type #{var.type), can't set to  #{type)")
    # if type and var.type and not var.type>=type: raise WrongType.new "#{type) #{var.type)"
    var.type = type


def assure_same_type_overwrite(var, val):
    oldType = var.type
    if oldType and not isinstance(val.type, oldType): raise WrongType("#{var) #{val)")
    if var.final and var.value and not val.value == var.value: raise ImmutableVaribale()
    var.value = val


def do_get_class_constant(c):
    # if interpreting(): c = getattr(__module__, c)
    try:
        for module in sys.modules:
            if hasattr(module,c):
                return getattr(module, c)
    except Exception as e:
        print(e)


def class_constant():
    c = word
    return do_get_class_constant(c)
    # if not Object._try(const_defined) c: raise NameError "uninitialized constant #{c)"


def get_obj(o):
    if not o: return False
    eval(o)  # except variables[o]

    # Object.property  or  object.property


def property():
    must_contain_before(".",' ')
    no_rollback()
    owner = class_constant
    owner = get_obj(owner) or variables[true_variable(False)].value  #reference
    _('.')
    properti = word
    return Property(name=properti, owner=owner)

# difference to setter? just public int var const test
def declaration():
    should_not_contain('=')
    # must_contain_before  be_words+['set'],';'
    a = the_()
    mod = maybe_tokens(modifiers)
    type = typeNameMapped()
    ___('var', 'val', 'value of')
    mod = mod or maybe_tokens(modifiers)  # public static :.
    var = _try(property) or variable_name(a)
    assure_same_type(var, type)
    # var.type = var.type or type
    var.final = mod in const
    var.modifier = mod
    return var


@Starttokens(let)
def setter():
    must_contain_before(args= be_words + ['set'],before=['>', '<', '+', '-', '|', '/', '*'])
    _let =___(let)
    if _let:no_rollback()
    a = _try(_the)
    mod = _try(modifier)
    _type = _try(typeNameMapped)
    ___('var', 'val', 'value of')
    mod = mod or _try(modifier)  # public static :.
    var = _try(property) or variable_name(a)
    # _22("always") => pointer()
    setta = ___('to') or be()  # or not_to_be 	contain -> add or create
    # val = _try(adjective) or expressions()
    val = expression()
    allow_rollback()
    if setta == 'are' or setta == 'consist of' or setta == 'consists of': val = [val].flatten()
    if _let: assure_same_type_overwrite(var, val)
    # var.type=var.type or type or type(val) #eval'ed! also x is an integer
    assure_same_type(var, _type or type(val))
    if not var.name in variableValues or mod != 'default' and interpreting():
        the.variableValues[var.name] = val

    var.value = val
    var.final = mod in const
    var.modifier = mod
    if isinstance(var, Property): var.owner.send(var.name + "=", val)  #todo
    # the.result = var
    # the.result = val
    # end_expression via statement!
    # if interpret: return var

    subnode({'var':var})
    subnode({'val':val})
    the.token_map[var.name]=true_variable
    if not interpreting(): return ast.Assign(ast.Name(var.name, ast.Store()),val)

    if interpreting() and val!=0: return val
    return var
    # if angel.use_tree: return parent_node()
    # if not interpret: return old-the.string
    #  or 'to'
    #'initial'?	_try(let) _try(_the) ('initial' or 'var' or 'val' or 'value of')? variable (be or 'to') value


# a=7
# a dog=7
# Int dog=7
# my dog=7
# a green dog=7
# an integer i
def isType(x):
    if isinstance(x, type): return True
    if x in type_names: return True
    return False

    # already existing


def current_node():
    pass


def current_context():
    pass


def variable_name(a=None):
    a = a or maybe_tokens(articles)
    if a != 'a': a = None  #hack for a variable
    typ = _try(typeNameMapped)  # DOESN'T BELONG HERE! EXPENSIVE e.g. int i++
    p = ___(possessive_pronouns)
    # all=p ? [p] : []
    # try:
    no_keyword()
    all = one_or_more(word)
    # except:
    # if a == 'a':
    #     all = [a]
    # else:
    #     raise NotMatching()
    if not all or all[0] == None: raise_not_matching
    name = " ".join(all)
    if not typ and len(all) > 1 and isType(all[0]): name = all[1:-1].join(' ')  #(p ? 0 : 1)
    if p: name = p + ' ' + name
    name = name.strip()
    if name in the.variableValues:
        oldVal = the.variableValues[name]
    else:oldVal=None
    # {variable:{name:name,type:typ,scope:current_node,module:current_context))
    if name in the.variables:
        return the.variables[name]
    # the.result = Variable({name: name, type: typ, _scope: current_node(), module: current_context(), value: oldVal})
    the.result = Variable(name= name, type= typ, scope= current_node(), module= current_context(),value= oldVal)
    the.variables[name] = the.result
    # if p: variables[p+' '+name]=the.result
    return the.result

word_regex=r'^\s*[a-zA-Z]+[\w_]*'
def word(include=[]):
    ## global the.string
    #danger:greedy!!!
    no_keyword_except(include)
    raiseNewline()
    #if not the.string: raise EndOfDocument.new
    #if _try(starts_with) keywords: return false
    # match = re.search(r'^\s*[a-zA-Z]+[\w_]*',the.string)
    match = re.search(word_regex,the.current_word)
    if (match):
        current_value = the.current_word# the.string[:match.end()]
        # the.string = the.string[match.end():].strip()
        next_token()
        return current_value
    raise_not_matching("word")

        #fad35
        #unknown
        # noun

        # NOT SAME AS should_not_start_with!!!


def should_not_contain(words):
    old=the.current_token
    words = flatten(words)
    while not checkEndOfLine():
        for w in words:
            if w==the.current_word:
                            raise ShouldNotMatchKeyword(w)
        next_token()
    set_token(old)
    return OK

def must_not_start_with(words):
    should_not_start_with(words)


def do_cast(x, typ):
    if isinstance(typ, float): return float(x)
    if isinstance(typ, int): return int(x)
    if typ.is_a("int"): return int(x)  #todo!
    if typ == "int": return int(x)
    if typ.is_a("the.string"): return str(x)  #todo!
    return x


def cast(x, typ):
    if interpreting(): return do_cast(x, typ)
    return x


def nod():  #options{generateAmbigWarnings=false)):
    return maybe(number) or \
           maybe(quote) or \
           maybe(true_variable) or \
        the_noun_that()
           # maybe(the_noun_that)  # or
    #_try( variables_that ) # see selectable


def article():
    tokens(articles)


def number_or_word():
    _try(number) or word()


def arg(position=1):
    pre = _try(preposition) or ""  #  might be superfluous if calling"BY":
    _try(article)  #todo use a vs the ?
    a = _try(variable_name)
    if a: return Argument(name=a.name, type=a.type, preposition=pre, position=position)
    type = _try(typeNameMapped)
    v = endNode()
    name = pre + (a and a.name or "")
    return Argument({preposition: pre, name: name, type: type, position: position, value: v})


# BAD after filter, ie numbers [ > 7 ]
# that_are bigger 8
# whose z are nonzero
def compareNode():
    c = comparison()
    if not c: raise NotMatching("NO comparison")
    if c == '=': raise NotMatching('compareNode = not allowed')  #todo Why not / when
    rhs = endNode()  # expression
    return rhs

# @Starttokens('whose')
def whose():
    _('whose')
    endNoun()
    return compareNode()  # is bigger than live


# things that stink
# things that move backwards
# people who move like Chuck
# the input, which has caused problems
#images which only vary horizontally
def that_do():
    global comp
    __('that', 'who', 'which')
    star(adverb)  # only
    comp = verb  # live
    maybe_token('s')  # lives
    s=star(lambda: _try(adverb) or maybe(preposition) or maybe(endNoun))
    return comp


# more easisly
def more_comparative():
    __('more', 'less', 'equally')  # comparison_words
    return adverb()


def as_adverb_as():
    _('as')
    a = adverb()
    _('as')
    return a


def endNode_():
    return maybe(endNode)


# 50% more
# "our burgers have more flavor",
# "our picture is sharper"
# "our picture runs sharper"
def null_comparative():
    verb()
    c = comparative()
    endNode_()
    if c.startswith('more') or c.ends_with('er'):
        return c


#  faster than ever
#  more funny than the funny cat
def than_comparative():
    comparative()
    _('than')
    return maybe(adverb) or endNode()


def comparative():
    c = _try(more_comparative) or adverb
    if c.startswith('more') or _try(lambda: c.ends_with('er')):
        comp = c
    return c


def that_are():
    __('that'), 'which', 'who'
    be()
    # bigger than live
    comp = _try(adjective)
    comp or maybe(compareNode) or gerund()  #  whining
    return comp


# things that I saw yesterday
def that_object_predicate():
    tokens('that', 'which', 'who', 'whom')
    _try(pronoun) or endNoun
    verbium
    s=star(lambda :_try(adverb) or _try(preposition) or _try(endNoun))
    return s


def that():
    filter = maybe(that_do) or maybe(that_are) or whose()
    return filter


def where():
    tokens('where')  # NOT: ,'who','whose','which'
    return condition()


# _try(ambivalent)  delete james from china

# def current_value():
#     TreeBuilder.current_value()


def selector():
    if checkEndOfLine(): return
    x = maybe(compareNode) or \
        maybe(where) or \
        maybe(that) or \
        maybe(token('of') and endNode) or \
        preposition and nod  # friends in africa
    if angle.use_tree:
        return parent_node()
    return x

# preposition nod  # _try(ambivalent)  delete james, from china delete (james from china)

# (who) > run like < rabbits
# contains
def verb_comparison():
    star(adverb)
    comp = verb()  # WEAK !?
    _try(preposition)
    return comp


def comparison():  # WEAK _try(pattern)):
    global comp
    comp = maybe(verb_comparison) or comparation()  # are bigger than
    return comp

def comparation_tree():
    Todo()

# is more or less
# is neither :. nor :.
# are all smaller than :.
# Comparison phrase
def comparation():
    # danger: is, is_a
    eq = ___(be_words)
    maybe_token('all')
    start = pointer()
    ___('either', 'neither')
    _not = ___('not')
    maybe(adverb)  #'quite','nearly','almost','definitely','by any means','without a doubt'
    if (eq):  # is (equal) optional:
        comp = ___(comparison_words)
    else:
        comp = tokens(comparison_words)
        no_rollback()

    if eq: maybe_token('to')
    ___('and', 'or', 'xor', 'nor')
    ___(comparison_words)  # bigger or equal != different to condition_tree True or false
    # comp = comp and pointer() - start or eq
    # if Jens.smaller then ok:
    maybe_token('than')  #, 'then' #_22'then' ;) danger:
    subnode({'comparation':comp})
    return operator(comp or eq)

    return comp or eq


def either_or():
    ___('be', 'is', 'are', 'were')
    tokens('either', 'neither')
    _try(comparation)
    value
    ___('or', 'nor')
    _try(comparation)
    return value


def is_comparator(c):
    ok = c in comparison_words or \
         comparison_words.contains(c - "is ") or \
         comparison_words.contains(c - "are ") or \
         comparison_words.contains(c - "the ") or \
         c in class_words
    return ok


def check_list_condition(quantifier,lhs,comp,rhs):
    global negated
    # if not a.isa(Array): return True
    # see quantifiers
    try:
        count = 0
        comp = comp.strip()
        for item in lhs:
            if is_comparator(comp): the.result = do_compare(item, comp, rhs)
            if not is_comparator(comp): the.result = do_send(item, comp, rhs)
            if not the.result and ['all', 'each', 'every', 'everything', 'the whole'].matches(quantifier): break
            if the.result and ['either', 'one', 'some', 'few', 'any'].contains(quantifier): break
            if the.result and ['no', 'not', 'none', 'nothing'].contains(quantifier):
                negated = not negated
                break

            if the.result: count = count + 1

        min = len(lhs) / 2
        if quantifier == 'most' or quantifier == 'many': the.result = count > min
        if quantifier == 'at least one': the.result = count >= 1
        # todo "at least two","at most two","more than 3","less than 8","all but 8"
        # if not the.result= not the.result
        if not the.result:
            verbose("condition not met #{lhs) #{comp) #{rhs)")

        return the.result
    except Exception as e:
        #debug x #soft message
        error(e)  #exit!
    return False


def check_condition(cond=None, negate=False):
    if cond == None: raise InternalError("NO Condition given!")
    if cond == True or cond == 'True': return True
    if cond == False or cond == 'False': return False
    if not isinstance(cond, (TreeNode, str, Condition)):  return cond
    # cond==None  or
    # if cond==false: return false
    try:
        # else: use state variables todo better!
        if isinstance(cond, Condition):
            lhs=cond.lhs
            rhs=cond.rhs
            comp=cond.comp
        if isinstance(cond, TreeNode):
            lhs = cond['expressions']
            rhs = cond.all('expressions').reject(lambda x: x == False)[-1]
            comp = cond.all('comparation').reject(lambda x: x == False)[-1]
            # comp=cond[:comparation]

        if not comp: return False
        if lhs and isinstance(lhs, str): lhs = lhs.strip()  # None==None ok
        if rhs and isinstance(rhs, str): rhs = rhs.strip()  # " a "=="a" !?!?!? NOOO! _try(why)
        comp = comp.strip()
        if is_comparator(comp):
            the.result = do_compare(lhs, comp, rhs)
        else:
            the.result = do_send(lhs, comp, rhs)

        # if  not the.result and cond:
        #   #if c: a,comp,b= extract_condition c
        #   evals=''
        #   variables.each { |var, val| evals+= "#{var)=#{val);" )
        #   the.result=eval(evals+cond.join(' ')) #dont set the.result here (i.e. while(:.)last_result )
        #
        # if _not: the.result = not the.result
        if negate: the.result = not the.result
        if not the.result:
            verbose("condition not met #{cond) #{lhs) #{comp) #{rhs)")
        return the.result
    except IgnoreException as e:
        #debug x #soft message
        error(e)  #exit!

    return False


def action_or_expressions(fallback=None):
    return maybe(action) or expression(fallback)
    # maybe(expressions(fallback))
    # expressions(fallback)

    # all of 1,2,3
    # all even numbers in [1,2,3,4]
    # one element in 1,2,3


def element_in():
    n=noun()
    __('in'), "of"
    return n


def condition():
    start = pointer()
    brace = maybe_token('(')
    negated = maybe_token('not')
    if negated: brace = brace or maybe_token('(')
    # a=endNode:(
    quantifier = ___(quantifiers)  # vs selector()!
    if quantifier: _try(element_in)
    # angel.in_condition=True
    lhs = action_or_expressions(quantifier)
    _not = False
    comp = use_verb = maybe(verb_comparison)  # run like , contains
    if not use_verb: comp = maybe(comparation)
    # allow_rollback # upto _try(where)?
    if comp: rhs = action_or_expressions(None)
    if brace: _(')')
    negate = (negated or _not) and not (negated and _not)
    subnode({'negate':negate})
    # angel.in_condition=False # WHAT IF raised !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!??????!
    if not comp: return lhs
    # 1,2,3 are smaller 4  VS 1,2,4 in 3
    if isinstance(lhs, list) and not _try(lambda: lhs.respond_to(comp)) and not isinstance(rhs,list):
        quantifier = quantifier or "all"
    # if not comp: return  negate ?  not a : a
    cond=Condition(lhs=lhs,comp=comp,rhs=rhs)
    if interpreting():
        if quantifier:
            if negate:
                return ( not check_list_condition(quantifier))
            else:
                return check_list_condition(quantifier)
        if negate:
            return ( not check_condition(cond))
        else:
            return check_condition(cond)  # None
    else:
        return cond
    # return Condition.new lhs:a,cmp:comp,rhs:b
    # if not angel.use_tree: return start - pointer()
    # if angel.use_tree: return parent_node()

# @Starttokens('(')
def condition_tree(recurse=True):
    brace = maybe_token('(')
    maybe_token('either')  # todo don't match 'either of'!!!
    # negate=maybe_token('neither')
    if brace and recurse: c = condition_tree(False)
    if not brace: c = condition()
    cs=[c] # lamda hack
    def lamb():
        op = __('and', 'or', 'nor', 'xor', 'nand', 'but')
        if recurse: c2 = condition_tree(False)
        if not interpreting(): return current_node  # or angel.use_tree
        if op == 'or': cs[0] = cs[0] or c2
        #if op=='or' RUBY BUG!?!?!: NIL c = c or c2
        # if op=='and'  or  op=='but': c =c and c2
        if op == 'and' or op == 'but': cs[0] = cs[0] and c2
        if op == 'nor': cs[0] = cs[0] and not c2
        return cs[0] or False

    star(lamb)
    if brace: _(')')
    return cs[0]


def otherwise():
    _try(newline)
    must_contain('else', 'otherwise')
    ___('else', 'otherwise')
    # if :. ! _try(OK): else:
    e = expression()
    ___('else', 'otherwise')and newline()
    return e


# todo  I hate to :.
def loveHateTo():
    ___('would', "wouldn't")
    ___('do', 'not', "don't")
    __['want', 'like', 'love', 'hate']
    return _('to')


def gerundium():
    verb
    return token('ing')


def verbium():
    return comparison or verb and adverb  # be or have or


def resolve_netbase(n):
    return n # Todo


def the_noun_that():
    _try(_the)
    n = noun()
    if not n: raise_not_matching("no noun")
    if the.current_word=="that":
        criterium=star(selector) # todo: apply ;)
        if criterium and interpreting():
            n=filter(n,criterium)
        else: n=resolve_netbase(n)
    else:
        if n in the.variables:
            return the.variables[n]
        if n in the.methods:
            return the.methods[n]
        if n in the.classes:
            return the.classes[n]
        raise Exception("Undefined: "+n)
        raise_not_matching("only 'that' filtered nouns for now!")
    return n


#def plural:
#  word #todo
#


def const_defined(c):
    for module in sys.modules:
         for name, obj in inspect.getmembers(sys.modules[module]):
            if inspect.isclass(obj) and name==c:
                return obj
    return False


def classConstDefined():
    try:
        c = word().capitalize()
        if not const_defined(c): raise NotMatching("Not a class Const")# return False
    except IgnoreException:#  (AttributeError,NameError ) as e:
        raise NotMatching()

    if interpreting(): c = do_get_class_constant(c)
    if not c:        raise NotMatching()
    return c


def typeNameMapped():
    x = typeName()
    if x == "int": return int
    return x


def typeName():
    return maybe_tokens(type_names) or classConstDefined()


def gerund():
    ## global the.string
    #'stinking'
    match = re.search(r'^\s*(\w+)ing',the.string)
    if not match: return False
    the.string = the.string[match.end():]
    pr = ___(prepositions)  # wrapped in
    if pr: _try(endNode)
    current_value = match[1]
    return current_value


def postjective():  # 4 squared , 'bla' inverted, buttons pushed in, mail read by James):
    ## global the.string
    match = re.search(r'^\s*(\w+)ed',the.string)
    if not match: return False
    the.string = the.string[match.end():]
    if not checkEndOfLine(): pr = ___(prepositions)  # wrapped in
    if pr and not checkEndOfLine(): _try(endNode)  # silver
    current_value = match[1]
    return current_value

    # TODO: big cleanup!
    # see resolve, eval_string,  do_evaluate, do_evaluate_property, do_s
def do_evaluate_property(x, y):
    # todo: REFLECTION / eval NODE !!!
    if not x: return False
    verbose("do_evaluate_property '+str(x)+' ") + str(y)
    the.result = None  #delete old!
    if x == 'type': x = 'class'  # !!*)($&) NOO
    if isinstance(x, TreeNode): x = x.value_string
    the.result = do_send(y, x, None)  #try 1
    the.result = eval(y + '.' + x)  #try 1
    if isinstance(x, list): x = x.join(' ')
    the.result = eval(y + '.' + x)  #try 2
    y = str(y)  #if _try(y.is_a) Array:
    the.result = eval(y + '.' + x)  #try 3
    if (the.result): return the.result
    all = str(x) + ' of ' + str(y)
    x = x.gsub(' ', ' :')
    try:
        the.result = eval(y + '.' + x)
        if not the.result: the.result = eval("'" + y + "'." + x)
        #if not the.result  except SyntaxError: the.result=eval('"'+y+'".'+x)
        if not the.result: the.result = eval(all)
    except:
        error('')
    return the.result

    # Strange method, see resolve, do_evaluate


def eval_string(x):
    if not x: return None
    if isinstance(x, extensions.File): return x.to_path
    # if isinstance(x, str): return x
    # and x.index(r'')   :. notodo :.  re.search(r'^\'.*[^\/]$',x): return x
    # if _try(x.is_a) Array: x=x.join(" ")
    if isinstance(x, list) and len(x) == 1: return x[0]
    if isinstance(x, list): return x
    # if _try(x.is_a) Array: return x.to_s
    return do_evaluate(x)

    # see resolve eval__try(the.string)??


def do_evaluate(x, type=None):
    if not interpreting(): return x
    try:
        if isinstance(x,ast.AST): exec(x)
        if isinstance(x, list) and len(x) == 1: return do_evaluate(x[0])
        if isinstance(x, list) and len(x) != 1: return x
        if isinstance(x, Variable):
            if not x.name in the.variableValues:
                raise InternalError("variableValues broken")
            return x.value or the.variableValues[x.name]
        if x==ZERO: return 0
        if x==TRUE: return True
        if x==FALSE: return FALSE
        if x==NILL: return None
        if isinstance(x, str) and type and isinstance(type, extensions.Numeric): return float(x)
        if x in the.variableValues: return the.variableValues[x]
        if x == True or x == False: return x
        if isinstance(x, str) and type and type==float: return float(x)
        # if isinstance(x, str) and type and is_a(type,float): return float(x)
        if isinstance(x, TreeNode): return x.eval_node(variableValues)
        if isinstance(x, str) and match_path(x): return resolve(x)
        # :. todo METHOD / Function!
        # if isinstance(x, extensions.Method): return x.call  #Whoot
        if callable(x): return x()  #Whoot
        if isinstance(x, str): return x
        if isinstance(x, str): return eval(x)  #  except x
        return x  # DEFAULT!
    except (TypeError, SyntaxError )as e:
        print("ERROR #{e) in do_evaluate #{x)")
        return x


        # see do_evaluate ! merge


def resolve(x):
    if not x: return x
    if is_dir(x): return extensions.Directory(x)
    if is_file(x): return extensions.File(x)
    if isinstance(x, Variable): return x.value # or ast.Name?
    if interpreting() and variableValues.has_key(x): return variableValues[x.strip]
    return x


def self_modifying(method):
    return method == 'increase' or method == 'decrease' or re.search(r'\!$',method)


#
# def self_modifying(method):
#     EnglishParser.self_modifying(method)  # -lol

def is_math(method):
    return method in ['+','-','/','*']

def do_math(a,op,b):
    a=float(a)
    b=float(b)
    if op=='+': return a+b
    if op=='-': return a-b
    if op=='/': return a/b
    if op=='%': return a%b
    if op=='*': return a*b
    if op=='**':return a**b
    if op=='^': return a^b
    if op=='|': return a|b
    raise Exception("UNKNOWN OPERATOR "+op)

# INTERPRET only,  todo cleanup method + argument matching + concept
def do_send(obj0, method, args0):
    if not interpreting(): return False
    if not method: return False

    # try direct first!
    if isinstance(method,list) and len(method)==1: method=method[0]
    if method in methods:
        # if callable(method):method(args)
        method=methods[method]


    if isinstance(method,Function):
        the.result = do_execute_block(methods[method].body, args0)
        return the.result
    # if callable(method): obj = method.owner no such concept in Python !! only as self parameter

    args = args0


    # obj.map{|x| x.value)
    if isinstance(args, Argument): args = args.name_or_value
    # if isinstance(args, list) and isinstance(args[0], Argument): args = args.map(name_or_value)
    args = eval_string(args)  # except NoMethodError
    if args and isinstance(args, str): args = xstr(args).replace_numerals()

    if (args and isinstance(args,list) and len(args)>0 and args[0] == 'of'): return evaluate_property(args[1],obj0)
    if (method == 'of'): return evaluate_property(args,obj0)
    # if args and _try(obj.respond_to) + " " etc!: args=args.strip()

    method_name = callable(method) and str(method) # what for??
    # if obj.respond_to(method_name):
    # elif  obj._try(respond_to) method_name+'s':
    # if callable(method) and obj: # method.owner:
    #     the.result = method.call(obj,*args)
    #     return the.result
    #
    obj = resolve(obj0)
    the.result = NoMethodError
    if not obj:
        if not args: return method()
        if args: return  method(args)
        the.result = args.send(method)  #except NoMethodError #("#{obj).#{op)")
        if (args[0] == 'of' and has_args(method, obj)): the.result = args[1].send(method)  #except NoMethodError #rest of x
    else:
        if is_math(method_name): the.result = do_math(obj,method_name,args)
        # if not callable(method): method=method(method_name)
        if not has_args(method, obj, False): the.result = method(obj) or NILL
        elif has_args(method, obj, True): the.result = method(obj,args) or NILL

    #todo: call FUNCTIONS!
    # puts object_method.parameters #todo MATCH!

    # => selfModify todo
    if (obj0 or args) and self_modifying(method):
        name = str(obj0 or args)#.to_sym()  #
        the.variables[name].value = the.result  #
        the.variableValues[name] = the.result

    # todo : None OK, error not!
    if the.result == NoMethodError: msg = "ERROR CALLING #{obj).#{method)(): #{args))"
    if the.result == NoMethodError: raise NoMethodError(msg, method, args)
    # raise SyntaxError("ERROR CALLING: NoMethodError")
    return the.result


def do_compare(a, comp, b):
    a = eval_string(a)  # NOT: "a=3; 'a' is 3" !!!!!!!!!!!!!!!!!!!!   Todo ooooooo!!
    b = eval_string(b)
    if isinstance(b, float) and re.search(r'^\+?\-?\.?\d',str(a)) : a = float(a)
    if isinstance(a, float) and re.search(r'^\+?\-?\.?\d',str(b))  : b = float(b)
    if isinstance(b, int)   and re.search(r'^\+?\-?\.?\d',str(a))  : a = int(a)
    if isinstance(a, int)   and re.search(r'^\+?\-?\.?\d',str(b))  : b = int(b)
    if isinstance(comp, str): comp = comp.strip()
    if comp == 'smaller' or comp == 'tinier' or comp == 'comes before' or comp == '<':
        return a < b
    elif comp == 'bigger' or comp == 'larger' or comp == 'greater' or comp == 'comes after' or comp == '>':
        return a > b
    elif comp == 'smaller or equal' or comp == '<=':
        return a <= b
    elif comp == 'bigger or equal' or comp == '>=':
        return a >= b
    elif comp in be_words:
        return a == b
    elif class_words.index(comp):
        return isinstance(a, b)
        # if b.isa(Class): return a.isa(b)
    elif be_words.index(comp) or re.search(r'same',comp):
        return isinstance(a, b) or a.__eq__(b)
    elif comp == 'equal' or comp == 'the same' or comp == 'the same as' or comp == 'the same as' or comp == '=' or comp == '==':
        return a == b  # Redundant
    else:
        try:
            return a.send(comp, b)  # raises!
        except:
            error('ERROR COMPARING ' + str(a) + ' ' + str(comp) + ' ' + str(b))
            return a.send(comp + '?', b)


def filter(liste, criterion):
    global rhs,lhs,comp
    if not criterion: return liste
    mylist = eval_string(liste)
    # if not isinstance(mylist, mylist): mylist = get_iterator(mylist)
    if angle.use_tree:
        method = criterion['comparative'] or criterion['comparison'] or criterion['adjective']
        args = criterion['endNode'] or criterion['endNoun'] or criterion['expressions']
    else:
        method = comp or criterion()
        args = rhs
    mylist.select(lambda i: do_compare(i, method, args))  #REPORT BUGS!!! except False


def selectable():
    must_contain('that', 'whose', 'which')
    ___('every', 'all', 'those')
    xs = resolve(true_variable()) or endNoun()
    s = maybe(selector)  # rhs=xs, lhs implicit! (BAD!)
    if interpreting(): x = filter(xs, s)  # except xs
    return x


def ranger():
    if in_params: return False
    must_contain('to')
    maybe_token('from')
    a = number()
    _('to')
    b = number()
    return range(a, b)  # a:b # (a:b).to_a


# #  or  endNode have adjective  or  endNode attribute  or  endNode verbTo verb # or endNode auxiliary gerundium
def endNode():
    raiseEnd()
        #_try( plural) or
    x =     maybe(liste) or\
            maybe(fileName) or\
            maybe(linuxPath) or\
            maybe(quote) or\
            maybe(lambda: _try(article) and typeNameMapped()) or\
            maybe(evaluate_property) or\
            maybe(selectable) or\
            maybe(true_variable) or\
            maybe(article) and word() or\
            maybe(ranger) or\
            maybe(value) or\
            maybe_token('a') or\
            raise_not_matching("Not an endNode")
    po = maybe(postjective)  # inverted
    if po and interpreting(): x = do_send(x, po, None)
    return x



def endNoun(included=[]):
    _try(article)
    adjs = star(adjective)  #  first second :. included
    obj = maybe(noun(included))
    if not obj:
        if adjs and adjs.join(' ').is_noun:
            return adjs.join(' ')
        else:
            raise NotMatching('no endNoun')

    if angle.use_tree: return obj
    #return adjs.to_s+" "+obj.to_s # hmmm  hmmm   hmmm  W.T.F.!!!!!!!!!!!!!?????
    if adjs and isinstance(adjs, list): adjs = ' ' + adjs.join(' ')
    return str(obj) + str(adjs)  # hmmm hmmm   hmmm  W.T.F.!!!!!!!!!!!!!????? ( == todo )


def any_ruby_line():
    ## global the.string
    line = the.string
    the.string = the.string.gsub(r'.*', '')
    checkNewline()
    return line


def start_block(type=None):
    if type:
        xmls = _('<')
        _(type)
        if xmls: _('>')

    if checkNewline(): return OK
    return ___(start_block_words)

def check_end_of_statement():
    return checkEndOfLine() or the.current_word==";" or maybe_tokens(done_words)

def end_of_statement():
    return checkEndOfLine() or token(';') # consume ";", but DON'T consume done_words here!

def english_to_math(s):
    s = s.replace_numerals
    s = s.replace(' plus ', '+')
    s = s.replace(' minus ', '-')
    s = s.replace(r'(\d+) multiply (\d+)', "\\1 * \\2")
    s = s.replace(r'multiply (\d+) with (\d+)', "\\1 * \\2")
    s = s.replace(r'multiply (\d+) by (\d+)', "\\1 * \\2")
    s = s.replace(r'multiply (\d+) and (\d+)', "\\1 * \\2")
    s = s.replace(r'divide (\d+) with (\d+)', "\\1 / \\2")
    s = s.replace(r'divide (\d+) by (\d+)', "\\1 / \\2")
    s = s.replace(r'divide (\d+) and (\d+)', "\\1 / \\2")
    s = s.replace(' multiplied by ', '*')
    s = s.replace(' times ', '*')
    s = s.replace(' divided by ', '/')
    s = s.replace(' divided ', '/')
    s = s.replace(' with ', '*')
    s = s.replace(' by ', '*')
    s = s.replace(' and ', '+')
    s = s.replace(' multiply ', '*')
    return s


def evaluate_index():
    should_not_start_with('[')
    must_contain('[', ']')
    v = endNode()  # true_variable()
    _('[')
    i = endNode()
    _(']')
    set = maybe_token('=')
    if set: set = expression
    # if interpreting(): the.result=v.send :index,i
    # if interpreting(): the.result=do_send v,:[], i
    # if set and interpreting(): the.result=do_send(v,:[]=, [i, set])
    va = resolve(v)
    if interpreting(): the.result = va.__index__(i)  #old value
    if set and interpreting():
        the.result = va.__index__(i, set)
    if set and isinstance(v, Variable): v.value = va

    # if interpreting(): the.result=do_evaluate "#{v)[#{i)]"
    return the.result


def evaluate_property():
    maybe_token('all')  # list properties (all files in x)
    must_contain_before(['of', 'in', '.'],'(')
    raiseNewline()
    x = endNoun(type_keywords)
    __('of', 'in')
    y = expression()
    if not interpreting(): return parent_node()
    try:  #interpret !:
        the.result = do_evaluate_property(x, y)
    except SyntaxError as e:
        verbose("ERROR do_evaluate_property")
        #if not the.result: the.result=jeannie all
    # except Exception as e:
    #     verbose("ERROR do_evaluate_property")
    #     verbose(e)
    #     error(e)
    #     error(traceback.extract_stack())
        #if not the.result: the.result=jeannie all

    return the.result


def jeannie(request):
    jeannie_api = 'https:r''weannie.pannous.com/_try(api)'
    params = 'login=test-user&out=simple&input='
    #if not current_value: raise "empty evaluation"
    # download(jeannie_api+params+URI.encode(request))


#  those attributes. _try(hacky) do better / don't use
def subnode(attributes={}):
    if not angle.use_tree: return
    if not current_node: return
    def lamb():
        name=attributes['name'] or attributes[0]
        value=attributes['value'] or attributes[1]
        node = TreeNode(name= name, value=value)
        nodes.append(node)
        current_node.nodes.append(node)
        current_value = value

    attributes.each(lamb)

    return attributes  #current_value

@Starttokens(eval_keywords)
def evaluate():
    __(eval_keywords)
    no_rollback()
    the_expression = rest_of_line
    subnode({'statement':the_expression})
    current_value = the_expression
    try:
        the.result = eval(english_to_math(the_expression))  #if not the.result:
    except:
        the.result = jeannie(the_expression)

    subnode({'result':the.result})  #: via automagic})
    current_value = the.result
    return current_value



def svg(x):
    svg.append(x)


#
# def load_history_why(? history_file):
#     histSize = 100
#     try:
#       history_file = File::expand_path(history_file)
#       if File::_try(lambda:exists(history_file))
#         lines = IO::readlines(history_file).collect (lambda line: line.chomp )
#         Readline::HISTORY.push(*lines)
#
#       Kernel::at_exit do
#         lines = Readline::HISTORY.to_a.reverse.uniq.reverse
#         if len(lines) > histSize: lines = lines[-histSize, histSize]
#         File::open(history_file, File::WRONLY|File::CREAT|File::TRUNC) (lambda io: io.print(lines.join("\n") ))
#
#     except Exception as e:
#       print("Error when configuring history: #{e)")
#

def start_shell():
    angle.verbose = False
    print('usage:')
    print("\t./angle 6 plus six")
    print("\t.r'angle examples'test.e")
    print("\t./angle (no args for shell)")
    # parser=EnglishParser()
    # import readline
    # _try(lambda:load_history_why('~/.english_history'))
    # http:r''www.unicode.orgr'charts'PDF/U2980.pdf
    #Readline.readline('⦠ ', True)
    input0 = input()
    while input0:
        # while input = Readline.readline('angle-script⦠ ', True)
        # Readline.write_history_file("~/.english_history")
        # while True
        #   print("> ")
        #   input = STDIN.gets.strip()
        try:
            # interpretation= parser.parse input
            interpretation = parse(input)
            if not interpretation: next
            if angle.use_tree: print(interpretation.tree)
            print(interpretation.result)
        except IgnoreException as e:
            pass

        # except NotMatching as e:
        #   print('Syntax Error')
        # except GivingUp as e:
        #   print('Syntax Error')
        # except Exception as e:
        #     print(e)
        input0 = input()
    print("")
    exit()


def startup():
    ARGV = sys.argv
    # ARGF=sys.argv
    if len(ARGV) == 0: return start_shell()  #and not ARGF:
    all = ARGV.join(' ')
    a = ARGV[0].to_s
    # read from commandline argument or pipe!!
    # all=ARGF.read or File.read(a) except a
    # if isinstance(all,str) and all.endswith(".e"): all=File.read(`pwd`.strip+"/"+a)
    if isinstance(all, str): all = all.split("\n")

    # puts "parsing #{all)"
    for line in all:
        if not line: continue
        try:
            interpretation = parse(line.encode('utf-8'))
            # interpretation=EnglishParser().parse line.encode('utf-8')
            the.result = interpretation.the.result
            if angle.use_tree: print(interpretation.tree)
            if the.result and not not the.result and not the.result == Nil: print(the.result)
        except NotMatching as e:
            print(e)
            print('Syntax Error')
        except GivingUp as e:
            print('Syntax Error')
        except e:
            print(e)
            print(e.backtrace.join("\n"))

    print("")


# def variables:
#   variables
#
#
# def the.result:
#   the.result
#
# $testing=testing or False
# if ARGV and not $testing and not $commands_server: EnglishParser.startup

def verbs():
    return main_verbs  # None #remove:

def be(): tokens(be_words)

def modifier(): tokens(modifiers)

def attribute(): tokens(attributes)

def preposition(): tokens(prepositions)

def pronoun(): tokens(pronouns)

def nonzero(): tokens(nonzero_keywords)


# def # nill=t():tokens(nill_words)
#     return Nill

def wordnet_is_adverb():
    pass


def adverb():
    no_keyword_except(adverbs)
    found_adverb = ___(adverbs)
    if not found_adverb: raise_not_matching("no adverb")
    if not angle.use_wordnet: return found_adverb
    current_value = found_adverb or wordnet_is_adverb()  # call_is_verb
    return current_value


def verb():
    no_keyword_except(remove_from_list(system_verbs ,be_words))
    found_verb = ___(xlist(other_verbs + system_verbs) - be_words - ['do'])  #verbs,
    if not found_verb: raise_not_matching("no verb")
    if not angle.use_wordnet: return found_verb
    current_value = found_verb or wordnet_is_verb()  # call_is_verb
    return current_value


def adjective():
    if not angle.use_wordnet: return tokens(['funny', 'big', 'small', 'good', 'bad'])
    # if not found_verb: raise_not_matching("no verb")
    return wordnet_is_adjective()


def wordnet_is_noun():  # expensive!!!):
    ## global the.string
    if re.search(r'^\d'): raise NotMatching("numbers are not nouns",the.string)
    if re.search(r'^\s*(\w+)'): the_noun = the.string.match(r'^\s*(\w+)',the.string)[1]
    #if not the_noun: return false
    if not the_noun: raise NotMatching("no noun word")
    if not the_noun.is_noun: raise NotMatching("no noun")
    the.string = the.string.strip[len(the_noun):-1]
    return the_noun


def wordnet_is_adjective():  # expensive!!!):
    ### global the.string
    if re.search(r'^\s*(\w+)'): the_adjective =the.string.match(r'^\s*(\w+)',the.string)[1]  #
    if boolean_words.has(the_adjective): raise NotMatching("no boolean adjectives")
    #if not the_adjective: return false
    if not the_adjective: raise NotMatching("no adjective word")
    if not the_adjective.is_adjective: raise NotMatching("no adjective")
    the.string = the.string.strip[len(the_adjective):-1]
    return the_adjective


def wordnet_is_verb():  # expensive!!!):
    ## global the.string
    if re.search(r'^\s*(\w+)'): the_verb = the.string.match(r'^\s*(\w+)',the.string)[1]
    if not the_verb: return False
    if the_verb.synsets('verb'): raise NotMatching("no verb")
    #if not the_verb.is_verb: raise NotMatching.new "no verb"
    the.string = the.string.strip[len(the_verb):-1]
    return the_verb


def call_is_verb():
    ## global the.string
    # eats=>eat todo lifted => lift
    test = re.search(r'^\s*(\w+)_try(s)',the.string)[1]
    if not test: return False
    command = app_path() + "r':'word-lists/is_verb " + test
    #puts command
    found_verb = False # exec(command)
    if not found_verb: raise NotMatching("no verb")
    if found_verb: the.string = the.string.strip[len(found_verb):-1]
    verbose("found_verb " + str(found_verb))
    return found_verb


def call_is_noun():
    ## global the.string
    test = re.search(r'^\s*(\w+)',the.string)[1]
    if not test: return False
    command = app_path() + "r':'word-lists/is_noun " + test
    found_noun = False # exec(command)
    if not found_noun: raise NotMatching("no noun")
    if found_noun == found_noun.upcase: raise NotMatching("B.A.D. acronym noun")
    if found_noun: the.string = the.string.strip[len(found_noun):-1]
    verbose("found_noun " + str(found_noun))
    return found_noun


def quote():
    raiseEnd()
    if the.current_type==_token.STRING:
        the.result = the.current_word[1:-1]
        next_token()
        return the.result
    # global the.result, the.string
    #if checkEnd: return
    # todo :match ".*?"
    if the.current_word == "'":
        the.string = the.string.strip()
        to = the.string[1:-1].index("'")
        the.result = current_value = the.string[1:to];
        the.string = the.string[to + 2:-1].strip()
        return Quote(current_value)
        #return "'"+current_value+"'"

    if the.current_word == '"':
        the.string = the.string.strip()
        to = the.string[1:-1].index('"')
        the.result = current_value = the.string[1:to];
        the.string = the.string[to + 2:-1].strip()
        return Quote(the.result)
        #return '"'+current_value+'"'

    raise NotMatching("quote")
    #if throwing: throw "no quote"
    return False


def true_variable(node=True):
    vars = the.variables.keys()
    if(len(vars)==0):raise NotMatching()
    v = tokens(vars)
    v = the.variables[v]  #why _try(later)
    #if interpret #LATER!: variableValues[v]
    if node and not interpreting(): return ast.Name(v, ast.Load())
    return v
    #for v in the.variables.keys:
    #  if the.string._try(start_with) v:
    #    var=token(v)
    #    return var
    #
    #
    #tokens(the.variables_list # todo: remove (in endNodes, selectors,:.))


def noun(include=[]):
    a = maybe_tokens(articles)
    if not a: should_not_start_with(keywords)
    if not angle.use_wordnet:
        return word(include)
    from nltk.corpus import wordnet as wn
    #if true_variable(): return True
    no_keyword_except(include)
    current_value = wordnet_is_noun()  # expensive!!!
    return current_value
    #current_value=call_is_noun # expensive!!!
    # return tokens(question_words) ??????????????

    # is defined as
    #


def bla():
    return tokens('hey')  #,'here is')

def _the():
    return tokens(articles)


def the_():
    maybe_tokens(articles)

def number_word():
    n=__(numbers)
    return xstr(n).parse_number()  #except NotMatching.new "no number"


def fraction():
    f = maybe(integer) or 0
    m = starts_with(["¼", "½", "¾", "⅓", "⅔", "⅕", "⅖", "⅗", "⅘", "⅙", "⅚", "⅛", "⅜", "⅝", "⅞"])
    if not m:
        # if f==ZERO: return 0 NOT YET!
        if f!=0:
            return f
        raise NotMatching()
    else:
        next_token()
        m = m.parse_number()
    the.result = float(f) + m
    return the.result


def number():
    return _try(real) or _try(fraction) or _try(integer) or _try(number_word) or raise_not_matching("number")

# _try(complex)  or

def integer():
    match = re.search(r'^\s*(-?\d+)',the.string)
    if match:
        current_value = int(match.groups()[0])
        next_token()
        if current_value == 0 :
            current_value = ZERO
        return current_value
    raise NotMatching("no integer")
    #plus{tokens('1','2','3','4','5','6','7','8','9','0'))


def real():
    ## global the.string
    match = re.search(r'^\s*(-?\d*\.\d+)',the.string)
    if match:
        current_value = float(match.groups()[0])
        next_token()
        return current_value
    #return false
    raise NotMatching("no real (unreal)")


def complex():
    s = the.string.strip().replace("i","j") # python!
    match = re.search(r'^(\d+j)', s)  # 3i
    if not match: match = re.search(r'^(\d*\.\d+j)', s)  # 3.3i
    if not match: match = re.search(r'^(\d+\s*\+\s*\d+j)', s)  # 3+3i
    if not match: match = re.search(r'^(\d*\.\d+\s*\+\s*\d*\.\d+j)', s)  # 3+3i
    if match:
        the.current_value = complex(match[0].groups())
        next_token()
        return current_value
    return False


def fileName():
    raiseEnd()
    match = is_file(the.string, False)
    if match:
        path = match[0]
        path = path.gsub(r'^/home', "'Users")
        path = extensions.File(path)
        next_token()
        the.current_value = path
        return path
    return False

def linuxPath():
    raiseEnd()
    match = match_path(the.string)
    if match:
        path = match[0]
        path = path.gsub(r'^/home', "'Users")
        path = extensions.Dir(path)  # except path
        next_token()
        the.current_value = path
        return path
    return False

def loops():
      return maybe( repeat_every_times ) or\
          maybe( repeat_n_times ) or\
          maybe( n_times_action ) or\
          maybe( action_n_times ) or\
          maybe( for_i_in_collection ) or\
          maybe( while_loop ) or\
          maybe( looped_action ) or\
          maybe( looped_action_until ) or\
          maybe( repeat_action_while) or\
          maybe( as_long_condition_block ) or\
          maybe( forever) or\
          raise_not_matching("Not a loop")


# beep every 4 seconds
# every 4 seconds beep
# at 5pm send message to john
# send message to john at 5pm
def repeat_every_times():
    must_contain( time_words)
    dont_interpret() #'cause later
    ___('repeat')
    b=maybe( action )
    interval=datetime
    no_rollback()
    if not b:
      start_block
      dont_interpret()
      b=maybe( action ) or  block
      end_block()

    # event=Event(interval:interval,event:b)
    # event=Event(interval, b)
    # event
    #if angel.use_tree: parent_node()

def repeat_action_while():
    _ ('repeat') #,'do'
    if re.search(r'\s*while'): raise_not_matching("repeat_action_while != repeat_while_action",the.string)
    b=action_or_block()
    _( 'while')
    c=condition()
    if not interpreting():
        return ast.While(test=c,body=b)
    while check_condition(c):
        the.result=do_execute_block(b)
    return the.result

def while_loop():
    ___( 'repeat')
    __('while','as long as')
    no_rollback() #no_rollback 13 # arbitrary value ! :{
    dont_interpret()
    c=condition()
    no_rollback()
    ___('repeat') # keep gerunding
    ___('then') #,':'
    b=action_or_block() #Danger when interpreting it might contain conditions and breaks
    r=False
    if not interpreting():
        return ast.While(test=c,body=b)
    while (check_condition(c)):
        r=do_execute_block( b)
    return r #or OK

def until_loop():
    ___('repeat')
    __('until','as long as')
    dont_interpret()
    no_rollback() #no_rollback 13 # arbitrary value ! :{
    c=condition()
    ___('repeat')
    b=action_or_block() #Danger when interpreting it might contain conditions and breaks
    r=False
    if interpreting():
        while(not check_condition(c)):
             r=do_execute_block(b)

    return r

def looped_action():
    must_not_start_with('while')
    must_contain( 'as long as', 'while')
    dont_interpret()
    ___('do')
    ___('repeat')
    a=action() # or semi-block
    __('as long as', 'while')
    c=condition()
    r=False
    if not interpreting(): return a
    if interpreting():
         while (check_condition (c)):
            r=do_execute_block(a)

    return r

def looped_action_until():
    must_contain ('until')
    dont_interpret()
    ___('do')
    ___('repeat')
    a=action() # or semi-block
    _('until')
    c=condition()
    r=False
    if not interpreting(): return a
    if interpreting():
                while(not check_condition(c)):
                    r=do_execute_block(a)
    return r


def is_number(n):
  str(n).replace_numerals().to_i() != 0 #hum

    # notodo: LTR parser just here!
  # say hello 6 times   #=> (say hello 6) times ? give up for now
  # say hello 6 times 5 #=> hello 30 ??? SyntaxError! say hello (6 times 5)
def action_n_times():
    must_contain('times')
    dont_interpret()
    ___('do')
    #___ "repeat"
    a=action()
    # ws=a.join(' ').split(' ') except [a]

    # if is_number ws[-1] # greedy action hack "say hello 6" times:
    #   a=ws[0..-2]
    #   n=ws[-1]

    # if not n:
    n=number()
    _('times')
    end_block()
    if interpreting():
        int(n).times(lambda :do_evaluate(a))
    return a

def n_times_action():
    # global the.result
    must_contain('times')
    n=number() #or int_variable
    _('times')
    no_rollback()
    ___('do')
    ___('repeat')
    dont_interpret()
    a=action_or_block()
    if interpreting():
        int(n).times(lambda : do_evaluate(a))
    return a

def repeat_n_times():
    must_contain( 'times')
    _('repeat')
    n=number()
    _('times')
    no_rollback()
    dont_interpret()
    b=action_or_block()
    if interpreting(): int(n).times(lambda : do_execute_block(b))
    return b
    #if angel.use_tree: parent_node()

# if action was (not) parsed before: todo: node cache: skip action(X) -> _'forever'
def forever():
    must_contain ('forever')
    dont_interpret()
    allow_rollback
    a= action()
    _('forever')
    if interpreting():
        while (True):
            do_execute_block(a)

def as_long_condition_block():
    _('as long as')
    c=condition()
    start_block
    a=block #  danger, block might contain condition()
    end_block()
    if interpreting():
        while (check_condition (c)):
            do_execute_block(a)

def ruby_action():
    _('ruby')
    exec(action or quote)
