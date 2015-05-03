#!r'usr'bin/env ruby
# encoding: utf-8
import time
import traceback
import sys
import __builtin__ # class function(object) etc

import Interpretation
import TreeBuilder
import CoreFunctions
import HelperMethods
# import core.angel
import angel
import english___
from nodes import Function, Argument, Variable, Property
from nodes import FunctionCall
import power_parser
import extensions
import events
from exceptions import *
from power_parser import *
from power_parser import _
from const import *
from english_tokens import *
from the import *
from angel import parent_node
from angel import *
from extensions import *
import the

function=__builtin__.function

# from power_parser import Parser
# import grammar.ruby_grammar
# import grammar.loops_grammar

# import bindings.shell.betty
# import bindings.native.native-scripting
# import bindings/common-scripting-objects

# import linguistics
# import wordnet
# import wordnet-defaultdb
# Linguistics.use(:en, :monkeypatch => True)
# http:r''99designs.comr'tech-blog' More magic

# look at java AST http:r''groovy.codehaus.org/Compile-time+Metaprogramming+-+AST+Transformations
from treenode import TreeNode

def end():
    pass

def _any(lamb):
    pass

def subnode(param, c):
    pass


def maybe_token(param):
    pass

class Nil(object):
    pass


class Nill(Nil):
    pass


def nill():
    return __(nill_words)


def boolean():
    b = __('True', 'False','true', 'false')
    result = (b == 'True' or b=='true') and TRUE or FALSE
    # result=b=='True'
    return result
    # OK


def _try(param):
    pass


def should_not_start_with(words):
    bad = _try(lambda: starts_with(words))
    if not bad: return OK
    if bad: verbose("should_not_match DID match #{bad)")
    if bad: raise ShouldNotMatchKeyword(bad)


def no_keyword_except(excepty=None):
    if not excepty:
        excepty = []
    return should_not_start_with(keywords - excepty)


def no_keyword():
    return no_keyword_except([])


def constant():
    return tokens(constants)


def it():
    __(result_words)
    return angel.last_result


def value():
    the.current_value = None
    no_keyword_except(constants + numbers + result_words + nill_words + ['+', '-'])
    x = any(lambda:
            maybe(quote) or \
            maybe(nill) or \
            maybe(number) or \
            maybe(true_variable) or \
            maybe(boolean) or \
            maybe(constant) or \
            maybe(it) or \
            maybe(nod)
            )
    the.result = the.current_value = x
    # rest_of_line # TOOBIG HERE!
    if ___('as'): typ = typeNameMapped()
    if typ: x = cast(x, typ)
    return x

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


def __(token):
    return tokens(token)


def ___(*tokens0):
    return _try(lambda: tokens(tokens0))


def ___(*tokens0):
    return _try(lambda: tokens(tokens0))


    # !!!
    # import TreeBuilder
    # import CoreFunctions
    # import EnglishParserTokens # module
    # import LoopsGrammar # while, as long as, :.
    # import RubyGrammar # def, :.
    # import Betty # convert a.wav to mp3
    # import ExternalLibraries

    # attr_accessor :methods, :result, :last_result, :interpretation, :variables, :variableValues,:variableType #remove the later!


interpret = True
did_interpret = True
javascript = ''
context = ''
variables = {}
variableTypes = {}
variableValues = {}  # ={nill: None)
svg = []
lines = []
# bash_methods=["say"]
c_methods = ['printf']
ruby_methods = ['puts', 'print']  # "puts"=>x_puts !!!
core_methods = ['show', 'now', 'yesterday', 'help']  # _try(difference)
methods = {}  # name->method-node
OK = 'OK'
result = ''
listeners = []


def now():
    return time.clock()


def yesterday():
    return time.clock() - 24 * 60 * 60


def interpretation():
    interpretation = Interpretation()
    i = interpretation  # Interpretation.new
    # super  # set tree, nodes
    i.javascript = javascript
    i.context = context
    i.methods = methods
    i.ruby_methods = ruby_methods
    i.variables = variables
    i.svg = svg
    i.result = result
    return i

    # beep when it rains
    # listener


def add_trigger(condition, action):
    return listeners.append(events.Observer(condition, action))


    # todo vs checkNewline() ??


def end_expression():
    return checkEndOfLine() or ___((newline_tokens) or newline)


def root():
    return many(lambda:
                maybe(expressions) or\
                maybe(requirements) or \
                maybe(method_definition) or \
                maybe(assert_that) or \
                maybe(lambda: block() and checkNewline()) or \
                maybe(statement and end_expression) or \
                maybe(expressions and end_expression) or \
                maybe(lambda: condition() or comp()) or \
                maybe(context)
                )
    # # maybe( ruby_def )or\ # SHOULD BE just as method_definition !!:


def set_context(context):
    the.context = context

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
    if dependency.match(r'\.js$'): return javascript_require(dependency)
    if type and "javascript script js".split().has(type): return javascript_require(dependency)
    # if not type or "ruby gem".split().has(type): return ruby_require(dependency)

    # #{escape_token t)


def regex(x):
    match = the.string.match(x)
    match = match or the.string.match(r'(?im)^\s*#{x)')
    if not match: raise NotMatching(x)
    the.string = match.post_match.strip
    return match

def package_version():
    maybe_token('with')
    c = maybe_token(comparison_words)
    __('v'), 'version'
    c = c or maybe_token(comparison_words)
    subnode(bigger= c)
    # current_value=
    result = c + " " + regex('\d(\.\d)*')[0]
    ___("or later")
    return result

    # (:use [native])

#
# def _try(quote):
#     pass


def requirements():
    require_types = "javascript script js gcc ruby gem header c cocoa native".split()  # todo c++ c# not tokened!
    type = ___(require_types)
    __(
        'dependencies'), 'dependency', 'depends on', 'depends', 'requirement', 'requirements', 'require', 'required', 'include', 'using', 'uses', 'needs', 'requires'
    type = type or ___(require_types)
    ___("file script header source src".split())
    ___('gem', 'package', 'library', 'module', 'context')
    type = type or ___(require_types)
    # _try(source) _try(really)
    dependency = _try(quote)
    no_rollback11(5)
    # _try(list_of){packages)
    dependency = dependency or word()  # regex "\w+(\/\w*)*(\.\w*)*\.?\*?" # rest_of_line
    version = maybe(package_version)
    if interpreting(): includes(dependency, type, version)  #
    result = {'dependency': {'type': type, 'package': dependency, 'version': version}}
    return result


def context():
    _('context')
    context = word()
    newlines()
    # NL
    block()
    return done()  # done context!!!


def bracelet():
    subnode(brace= _('('))
    a=algebra()
    subnode(brace= _(')'))
    return a


def operator():
    return tokens(operators)


def algebra():
    must_contain_before([be_words, ',', ';', ':'], operators)
    result = _try(value) or bracelet()  # any { maybe( value ) or maybe( bracelet ) )
    return result


def star():
    op = operator  # operator KEYWORD!?! ==> the.string="" BUG     4 and 5 == TROUBLE!!!
    if not op == 'and': no_rollback11()
    # the.string=""+the.string2 #==> the.string="" BUG _try(WHY)?
    y = maybe(value) or bracelet()
    if interpreting():  # and not angel.use_tree:
        if op == "r'":  # 3'4==0 ? NOT WITH US!!: y=float(y)
            try:
                result = do_send(the.result, op, y or the.result)
            except SyntaxError:
                print("x")
                # ??? result or True # star OK

        if angel.use_tree and not interpreting():
            return the.parent_node()
        # result=result
        if angel.use_tree and interpret:
            tree = the.parent_node()
            if tree: result = the.tree.eval_node(variableValues, result)  # except result #wasteful!!
        return result

        # def current_context():
        # context: tree / per node

        # def javascript:
        # _try(script_block)
        #   __(current_context)=='javascript' ? 'script' : 'java script', 'javascript', 'js'
        #   no_rollback11() 10
        #   javascript+=rest_of_line+';'
        #   newline22
        #   return javascript
        #   #if not javascript: block and done
        #


def read_block(type=None):
    block = []
    start_block(type)
    while True:
        if _try(lambda: end_block(type)): break
        block.append(rest_of_line)
    return subnode(type or {'block': block})


def html_block():
    return read_block('html')


def javascript_block():
    block = maybe(read_block('script')) or maybe(read_block('js')) or read_block('javascript')
    javascript.append(block.join(";\n"))
    return block


def ruby_block():
    return read_block('ruby')


def special_blocks():
    return _try(html_block) or _try(ruby_block) or javascript_block


def end_of_statement():
    return checkNewline() or end_expression
    # or end_expression #end_block #newlines

    # see read_block for RAW blocks! (</EOF> type)
    # EXCLUDING start_block & end_block !!!


def block():  # type):
    start_block()  # NEWLINE ALONE == START!!!?!?!
    the.original_string = the.string  # _try(REALLY)?
    start = pointer()
    s = statement  # BUUUUUG~~~!!!
    content = pointer() - start
    end_of_block = _try(end_block)  # ___ done_words
    if not end_of_block:
        end_of_statement()  # danger might act as block end!
        ss=s
        def lamb():
            s = statement or ss
            content = pointer() - start
            end_of_statement

        star(lamb)
        # _try(end_of_statement)
        end_of_block = end_block()

    the.last_result = the.result
    if interpreting(): return s
    return content
    # if angel.use_tree:
    # p=parent_node()
    # if p: p.content=content
    #   p
    #


def nth_item():  # Also redundant with property evaluation (But okay as a shortcut)):
    set = maybe_token('set')
    n = __(numbers + ['first', 'last', 'middle'])
    maybe_token('.')
    type = __['item', 'element', 'object', 'word', 'char', 'character'] + type_names  # noun
    __('in', 'of')
    l = resolve(true_variable) or _try(list) or quote
    if type.match(r'^char'):
        the.result = l.join('')[n.parse_integer - 1]
        return the.result
    if type_names.contains(type): l = l.select(lambda x: x == False)
    result = l.item(n)  # -1 AppleScript style !!! BUT list[0] !!!
    if set:
        _('to')
        val = endNode
        l[n.parse_integer - 1] = do_evaluate(val)

    return result


def listselector():
    return _try(nth_item) or functionalselector()

    # DANGER: INTERFERES WITH _try(LIST), NAH, NO COMMA: {x > 3)


def functionalselector():
    _('{')
    xs = true_variable()
    crit = selector()
    _(')')
    return filter(xs, crit)


def list(check=True):
    if the.string[0] == ',': raise NotMatching()
    if check: must_contain_before([be_words, operators - ['and']], ',')
    # +[' '] ???
    start_brace = ___('[', '{', '(')  # only one!
    if not start_brace and (the.inside_list): raise NotMatching('not a deep list')

    # all<<expression(start_brace)
    # angel.verbose=True #debug
    inside_list = True
    first = _try(endNode)
    if not first: inside_list = False
    if not first: raise_not_matching()
    all = [first]
    star(lambda: tokens(',', 'and') and all.append(endNode))
    # all<<expression
    # danger: and as plus! BAD IDEA!!!
    if start_brace == '[': _(']')
    if start_brace == '{': _(')')
    if start_brace == '(': _(')')
    the.inside_list = False
    the.current_value = all
    return all


def minusMinus():
    must_contain('--')
    v = variable()
    _('--')
    if interpret: result = do_evaluate(v, v.type) + 1
    # else:result=UnaryOp('--',v)
    variableValues[v] = v.value = result
    return result


def plusPlus():
    must_contain('++')
    v = variable()
    _('++')
    if not interpret: return angel.parent_node()
    result = do_evaluate(v, v.type) + 1
    variableValues[v.name] = v.value = result
    return result


def selfModify():
    return maybe(plusEqual) or maybe(plusPlus) or minusMinus


def plusEqual():
    must_contain('|=', '&=', '&&=', '= or ', '+=', '-=', '/=', '^=', '%=', '#=', '*=', '**=', '<<', '>>')
    v = variable()
    mod = ___('|=', '&=', '&&=', '= or ', '+=', '-=', '/=', '^=', '%=', '#=', '*=', '**=', '<<', '>>')
    val = v.value
    exp = expressions()  # value
    arg = do_evaluate(exp, v.type)
    if not interpreting(): return angel.parent_node()
    if mod == '|=': result = val | arg
    if mod == '= or ': result = val or arg
    if mod == '&=': result = val & arg
    if mod == '&&=': result = val and arg
    if mod == '+=': result = val + arg
    if mod == '-=': result = val - arg
    if mod == '*=': result = val * arg
    if mod == '**=': result = val ** arg
    if mod == '/': result = val / arg
    if mod == '/=': result = val % arg
    if mod == '<<': result = val.append(arg)
    if mod == '>>': result = val >> arg
    variableValues[v.name] = result
    v.value = result
    return result


def swift_hash():
    _('[')
    h = {}

    def hashy():
        if h.length > 0: _(',')
        ___('"', "'")
        key = word()
        ___('"', "'")
        _(':')
        inside_list = True
        # h[key] = expression0 # no
        h[result] = expressions()  # no

    star()
    _(']')
    inside_list = False
    return h


def close_bracket():  # for nice GivingUp):
    return _(')')


def json_hash():
    must_contain(":", "=>", before=")")
    # z=_try(regular_json_hash) or immediate_json_hash RUBY BUG! or and  or  act very differently!
    z = _try(regular_json_hash) or immediate_json_hash()
    return z

    # colon for types not _try(Compatible) puts a:int vs puts {a:int) ? maybe egal
    # careful with blocks!! {puts "s") VS {a:"s")


def regular_json_hash():
    _('{')
    maybe_token(':') and no_rollback11()  # {:a:.) Could also mean list of _try(symbols) Nah
    h = {}

    def lamb():
        if h.length > 0: ___(';', ',')
        quoted = ___('"', "'")
        key = word()
        if quoted: __('"', "'")
         # Property versus hash !!
        ___('=>', '=') or starts_with("{") or ___('=>', ':')
        inside_list = True
        # h[key] = expression0 # no
        h[result] = expressions()

    star(lamb)
    # no_rollback11()
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
    no_rollback11()
    r = regular_json_hash()
    return {str(result): r}  # AH! USEFUL FOR NON-symbols !!!


# todo PYTHONBUG ^^

# keyword expression is reserved by ruby/rails!!! => use hax0r writing or plural
def expressions(fallback=None):
    # raiseNewline ?
    start = pointer()
    result = ex = any(lambda:
                      maybe(algebra) or \
                      maybe(json_hash) or \
                      maybe(swift_hash) or \
                      maybe(evaluate_index) or \
                      maybe(listselector()) or \
                      maybe(list) or \
                      maybe(evaluate_property) or \
                      maybe(selfModify) or \
                      maybe(endNode)
                      )
    # or ['one'].has(fallback) ? 1 : false # WTF todo better quantifier one beer vs one==1
    # expression)
    if not interpreting() and not angel.use_tree: return pointer() - start
    if ex and interpreting():
        last_result = result = do_evaluate(ex)
        # TODO PYTHON except SyntaxError:
    if not result or result == SyntaxError and not ex == SyntaxError:
        pass
        # keep false
    else:
        ex = result
    # NEIN! print('hi' etc etc)
    # if result.isa(Quote): more=_try(expression0)
    # more=more or _try(quote) #  "bla " 7 " yeah"
    # if more.isa(Quote) except "": more+=_try(expression0)
    # if more: ex+=more
    # subnode (expression: ex)
    result = ex
    return result


def piped_actions():
    if angel.in_pipe(): return False
    must_contain("|")
    in_pipe = True
    a = statement()
    token('|')
    no_rollback11()
    c = true_method() or bash_action()
    args = star(arg)
    if isinstance(c, __builtin__.function): args = [args, Argument(value=a)]  # with owner
    if interpreting():
        result=do_send(a, c, args)
        print(result)
        return result
    else:
        return OK



def statement():
    raiseNewline  # _try(really) _try(why)

    def lamb():
        # statement)
        if checkNewline(): return NEWLINE
        # maybe( if_then ) or 
        maybe(loops) or \
        maybe(if_then_else) or \
        maybe(once) or \
        maybe(piped_actions) or \
        maybe(declaration) or \
        maybe(setter) or \
        maybe(returns) or \
        maybe(breaks) or \
        maybe(constructor) or \
        maybe(action) or \
        maybe(expressions)  # AS RETURN VALUE! DANGER!

    x = _any(lamb)

    if x: last_result = x
    # last_result=last_result or x
    # one :action, :if_then ,:once , :looper
    # any{action  or  if_then  or  once  or  looper)


def method_definition():
    # annotations=_try(annotations)
    # modifiers=_try(modifiers)
    tokens(method_tokens)  # how to
    no_rollback11()
    name = _try(noun) or verb  # integrate or word
    # obj=maybe( endNode ) # a sine wave  TODO: invariantly get as argument book.close==close(book)
    maybe_token('(')
    args = []
    def lamb():
        # nonlocal arg_nr #  python 3 , for python 2 there's no simple workaround, unfortunately SHOWSTOPPER!!!
        global arg_nr #  python 3 , for python 2 there's no simple workaround, unfortunately SHOWSTOPPER!!!
        the.in_params = True
        a = arg(len(args))
        maybe_token(',')
        args.append(a)

    star(lamb)  # over an interval
    return_type = ___(('as', 'return', 'returns', 'returning') and _try(typeNameMapped))
    if maybe_token('->'):  # swift style --:
        return_type = return_type or typeNameMapped  # _22 '!'
    the.in_params = False
    maybe_token(')')
    allow_rollback  # for
    dont_interpret11()
    b = action_or_block  # define z as 7 allowed !!!
    f = Function(name=name, arguments=args, return_type=return_type, body=b)
    # ,modifiers:modifiers, annotations:annotations
    methods[name] = f or parent_node() or b
    # # with args! only in tree mode!!
    return f or name


def raise_not_matching(msg=None):
    raise NotMatching(msg)


def execute(command):
    exec(command)


def bash_action():
    # import bindingsr'shell'bash-commands
    ok = starts_with(['bash'] + bash_commands)
    if not ok: raise_not_matching("no bash commands")
    remove_tokens('execute', 'command', 'commandline', 'run', 'shell', 'shellscript', 'script', 'bash')
    command = maybe(quote)  # danger bash "hi">echo
    command = command or rest_of_line
    subnode(bash=command)
    # any{ _try(  ) or   statements )
    if interpreting():
        try:
            print('going to execute ' + command)
            result = execute(command)
            print('result:')
            print(result)
            if result:
                return result.split("\n")
            else:
                return True
        except:
            print('error (e)xecuting bash_action')

    return False


def if_then_else():
    maybe(if_then)  # todo :if 1 then False else: 2 => 2 :(: ok      =
    ok = action_if
    if ok == False:
        ok = FALSE
    o = _try(otherwise) or FALSE
    if ok != "OK":
        return ok
    else:
        return o


def action_if():
    must_contain('if')
    a = action_or_expressions
    _('if')
    c = condition_tree
    if interpreting():
        if check_condition(c):
            return do_execute_block(a)
        else:
            return OK  # false but block ok!
    return a


def if_then():
    __(if_words)
    no_rollback11()  # 100
    c = condition_tree
    if c == None: raise InternalError("no condition_tree")
    # c=condition
    maybe_token('then')
    dont_interpret11()  # if not c  else: dont do_execute_block twice!:
    b = expression_or_block  # action_or_block
    # o=_try(otherwise)
    # if use_block: b=block
    # if not use_block: b=statement
    # if not use_block: b=action
    allow_rollback
    if interpreting():
        if check_condition(c):
            return do_execute_block(b)
        else:
            return OK  # o or  false but block ok!

    return b


def once_trigger():
    __(once_words)
    dont_interpret11()
    c = condition
    no_rollback11()
    maybe_token('then')
    use_block = _try(start_block)
    if not use_block: b = action and end_expression
    if use_block: b = block and done
    add_trigger(c, b)


def _do():
    pass


def action_once():
    if not _do() and newline: must_contain(once_words)
    no_rollback11()
    b = action_or_block
    # _do=maybe_token('do')
    # dont_interpret11()
    # if not _do: b=action
    # if _do: b=block and _try(done)
    __(once_words)
    c = condition
    end_expression
    add_trigger(c, b)


def once():
    # or  'as soon as' condition \n block 'ok'
    #	 or  'as soon as' condition 'then' action;
    maybe(once_trigger) or action_once


# or  action 'as soon as' condition

#/*n_times
#	 verb number 'times' preposition nod -> "<verb> <preposition> <nod> for <number> times" 	*/
#r'*	 verb number 'times' preposition nod -> ^(number times (verb preposition nod)) # Tree ~= lisp	*'
def verb_node():
    v = verb
    nod
    if not methods.contains(v): raise UnknownCommandError('no such method: ' + v)
    return v
    #end_expression


def spo():
    # NotImplementedError
    if not the.use_wordnet: return False
    if not the.use_wordnet: raise NotMatching("the.use_wordnet==false")
    s = endNoun
    p = verb
    o = nod
    if interpret: return do_send(s, p, o)


def substitute_variables(args):
    #args=" "+args+" "
    for variable in variableValues.keys:
        if isinstance(variable, list):
            variable = variable.join(' ')  #HOW!?!?!:
        value = variableValues[variable] or 'None'
        #args=args.replace(r'\$#{variable)', "#{variable)") # $x => x !!
        args = args.replace(r'.\{#{variable)\)', "#{value)")  #  ruby style #{x) ;)
        args = args.replace(r'\$#{variable)$', "#{value)")  # php style $x
        args = args.replace(r'\$#{variable)([^\w])', "#{value)\\\1")
        args = args.replace(r'^#{variable)$', "#{value)")
        args = args.replace(r'^#{variable)([^\w])', "#{value)\\1")
        args = args.replace(r'([^\w])#{variable)$', "\\1#{value)")
        args = args.replace(r'([^\w])#{variable)([^\w])', "\\1#{value)\\2")

    #args.strip
    args

    # todo : why _try(special) direct eval, rest_of_line


def print_variables():
    pass


def ruby_method_call():
    call = ___('call', 'execute', 'run', 'start', 'evaluate', 'invoke')
    if call: no_rollback11()
    ruby_method = ___(ruby_methods + core_methods)
    if not ruby_method: raise UndefinedRubyMethod(word())
    args = rest_of_line
    # args=substitute_variables rest_of_line
    if interpreting():
        try:
            the_call = ruby_method + ' ' + str(angel.result)
            # print_variables=variableValues.inject("") ? (lambda x: x==False )={v[1].is_a(the.string) ? '"'+v[1]+'"' : v[1]);"+s )
            result = eval(print_variables() + the_call) or ''
            verbose(the_call + '  called successfully with result ' + str(result))
            return result
        except SyntaxError as e:
            print("\n!!!!!!!!!!!!\n ERROR calling #{the_call)\n!!!!!!!!!!!! #{e)\n ")
        except Exception as e:
            print("\n!!!!!!!!!!!!\n ERROR calling #{the_call)\n!!!!!!!!!!!! #{e)\n ")
            error(traceback.extract_stack())
            print('!!!! ERROR calling ' + the_call)

    checkNewline()
    #raiseEnd
    subnode(method=ruby_method)  #why not _try(auto)?
    subnode(args=args)
    current_value = ruby_method
    return current_value
    # return Object.method ruby_method.to_sym
    # return Method_call(ruby_method,args,:ruby)


def is_object_method(m):
    if not str(m) in globals(): return False
    if isinstance(m, function) and str(m) in globals():
        return m #'True'
    object_method = globals()[m] #.method(m)
    return object_method # 'True' ;)
    # Object.constants  :IO, :STDIN, :STDOUT, :STDERR :.:Complex, :RUBY_VERSION :.


def has_object(m):
    return str(m) in globals()


def has_args(method, clazz=object, assume=False):
    #todo MATCH!   [[:req, :x]] -> required: x
    if isinstance(method, function): return method.arity > 0
    if not isinstance(clazz, type):  #lol:
        clazz = type(clazz)
    if clazz.method_defined(method): object_method = clazz.method(method)
    if not object_method: object_method = clazz.public_instance_method(method)
    if object_method:  #that might be another method Tree.beep!
        # puts "has_args method.parameters : #{object_method) #{object_method.parameters)"
        return object_method.arity > 0

    if ['invert', '++', '--'].index(method):  # increase by 8:
        return False
    return assume  #false # True


def c_method():
    tokens(c_methods)


def builtin_method():
    w = word
    if not w: raise_not_matching("no word")
    if w.capitalize == w: raise_not_matching("capitalized #{w) no builtin_method")
    m = is_object_method(w)
    m = m or HelperMethods.method(w)
    m
    # m ? m.name : None


def true_method():
    no_keyword()
    should_not_start_with(auxiliary_verbs)
    # _try(lambda:tokens(methods.keys+"ed")) sorted files -> sort files ?
    v = _try(c_method) or _try(verb) or tokens_(methods.keys) or _try(lambda: tokens(ruby_methods)) or _try(
        lambda: tokens(core_methods)) or _try(builtin_method)
    if not v: raise NotMatching('no method found')
    v  #.to_s


def strange_eval(obj):
    maybe_token('(')
    args = star(arg)
    _(')')
    result = do_evaluate_property(obj,args)
    result
    # conflict with files, 3.4


def thing_dot_method_call():
    must_contain_before['='], '.'  # before:.?
    obj = endNode
    if maybe_token('(') and interpreting(): return strange_eval(obj)
    _('.')
    method_call(obj)


def method_call(obj=None):
    # _try(ruby_method_call)  or 
    _try(thing_dot_method_call) or generic_method_call(obj)

    # read mail or bla(1) or a.bla(1)  vs ruby_method_call !!


def generic_method_call(obj=None):
    #verb_node
    method =true_method()
    start_brace = ___('(', '{')  # '[', list and closure danger: index)
    # todo  ?merge with _try(list)
    if start_brace: no_rollback11()
    if is_object_method(method):  #todo  not has_object(method) is_class_method:
        obj = obj or object
    else:
        maybe_token('of')
        if angel.in_args(): obj = maybe(_try(nod))
        if not angel.in_args(): obj = maybe(_try(nod) or list)
        # print(sorted files)
        # if not in_args: obj=maybe( _try(nod)  or  _try(list)  or  expression )

    assume_args = True  # not starts_with("of")  # True    #<< Redundant with property eventilation!
    if has_args(method, obj, assume_args):
        current_value = None
        in_args = True
        args = star(arg)
        if not args: args = obj
        # ___( ',','and')
    else:
        more = maybe_token(',')
        if more: obj = [obj] + list(False)

    in_args = False
    if start_brace == '(': _(')')
    if start_brace == '[': _(']')
    if start_brace == '{': _(')')
    subnode(object=obj)
    subnode(arguments=args)
    if not interpreting(): return FunctionCall(name=method, arguments=args, object=obj)  #parent node!!!
    result = do_send(obj, method, args)
    return result


def tokens_(tokens0):
    ___(tokens0)


def bla():
    tokens_(bla_words)


def applescript():
    tokens('tell application', 'tell app')
    no_rollback11()
    app = quote
    result = "tell application \"#{app)\""
    if maybe_token('to'):
        result += ' to ' + rest_of_line()  # "end tell"
    else:  #Multiline
        while the.string and not the.string.contains('end tell'):
            # #TODO deep blocks! simple 'end' : and not the.string.contains('end')
            result += rest_of_line() + "\n"

            # ___ "end tell","end"

    # result        +="\ntell application \"#{app)\" to activate" # to front
    # -s o r'path'tor'the'script.scpt
    if interpret: result=current_value = execute("r'usr'bin/osascript -ss -e $'#{result)'")
    return result


def assert_that():
    _('assert')
    maybe_token('that')
    what = rest_of_line
    assert what


def arguments():
    star(arg)


def constructor():
    maybe_token('create')
    maybe(the)
    _('new')
    # clazz=word #allow data
    clazz = class_constant
    do_send(clazz, 'new', arguments)
    # clazz=Class.new
    # variables[clazz]=
    # clazz(arguments)


def returns():
    _('return')
    result = _try(expressions)
    result


def breaks():
    __('next'), 'continue', 'break', 'stop'


#	 or 'say' x=(.*) -> 'bash "say $quote"'
def action():
    start = pointer()
    _try(bla)

    def lamb():
        maybe(special_blocks) or \
        maybe(applescript) or \
        maybe(bash_action) or \
        maybe(evaluate) or \
        maybe(returns) or \
        maybe(selfModify) or \
        maybe(method_call) or \
        maybe(spo)

    result = any(lamb)  #action
    #_try( verb_node ) or
    #_try( verb )

    if not result: raise NoResult()
    ende = pointer()
    # newline22:
    if not angel.use_tree and not interpret: return ende - start
    return result


def action_or_block():  # expression_or_block ??):
    # dont_interpret  # _try(always)
    # the.string
    if not starts_with[':', 'do', '{']: a = maybe(action)
    if a: return a
    # type=start_block && newline22
    b = block
    # end_block
    return b


def expression_or_block():  # action_or_block):
    # dont_interpret  # _try(always)
    a = maybe(action) or maybe(expressions)
    if a: return a
    b = block
    return b


def end_block(type=None):
    done(type)


def done(type=None):
    if type and _try(lambda: close_tag(type)): return OK
    if checkEndOfLine(): return OK
    newline22
    ok = tokens(done_words)
    if type: token(type)
    ignore_rest_of_line
    ok


# used by done / end_block
def close_tag(type):
    _('</')
    _(type)
    _('>')


def call_function(f, args=None):
    do_send(f.object, f.name, args or f.arguments)


def raiseNewline():
    pass


class Fixnum(int):
    pass


def do_execute_block(b, args={}):
    if not b: return False
    if isinstance(b, FunctionCall): return call_function(b)
    if isinstance(b, Function): return call_function(b, args)
    if isinstance(b, TreeNode): b = b.content
    if not isinstance(b, str): return b  # OR :. !!!
    block_parser = EnglishParser()
    block_parser.variables = the.variables
    block_parser.variableValues = the.variableValues
    if not isinstance(args, dict): args = {'arg': args}
    for arg, val in args:
        v = block_parser.variables[arg]
        if v:
            v = v.clone
            v.value = val
            block_parser.variables[str(arg)] = v  # to_sym todo NORM in hash!!!
        else:
            block_parser.variables[str(arg)] = Variable(name=arg, value=val)


    # block_parser.variables+=args
    try:
        result = block_parser.parse.result
    except:
        error(traceback.extract_stack())

    variableValues = block_parser.variableValues
    result
    #do_evaluate b


def datetime():
    # Complicated stuff!
    # later: 5 secs from now  , _(5pm) == AT 5pm
    must_contain(time_words)
    _kind = tokens(event_kinds)
    no_rollback11()
    ___('around', 'about')
    # import chronic_duration
    # WAH! every second  VS  every second hour WTF ! lol
    n = _try(number) or 1  # every [1] second
    _to = maybe(lambda: tokens('to', 'and'))
    if _to: _to = number
    _unit = __(time_words)  # +["am"]
    _to = _to or ___('to', 'and')
    if _to: _to = _to or _try(number)
    return events.Interval(_kind, n, _to, _unit)


def collection():
    any(lambda:
        maybe(ranger) or
        maybe(true_variable()) or
        action_or_expressions  #of type list !!
        )


def for_i_in_collection():
    maybe_token('repeat')
    __('for', 'with')
    maybe_token('all')
    v = variable()  # selector() !
    __('in', 'from')
    c = collection()
    b = action_or_block()
    for i in c:
        do_execute_block(b)
    if interpreting(): end()


#  until_condition ,:while_condition ,:as_long_condition


def assure_same_type(var, type):
    oldType = variableTypes[var.name]
    # try:
    if oldType and type and not type <= oldType: raise WrongType("#{oldType) #{type)")
    if oldType and var.type and not var.type <= oldType: raise WrongType("#{oldType) #{var.type)")
    # if type and var.type and not var.type>=type: raise WrongType.new "#{type) #{var.type)"
    if type and var.type and not (var.type <= type or var.type >= type): raise WrongType("#{type) #{var.type)")
    # except
    #   p e
    #
    var.type = type


def assure_same_type_overwrite(var, val):
    oldType = var.type
    if oldType and not isinstance(val.type, oldType): raise WrongType("#{var) #{val)")
    if var.final and var.value and not val.value == var.value: raise ImmutableVaribale()
    var.value = val


def do_get_class_constant(c):
    # if interpreting(): c = getattr(__module__, c)
    for module in sys.modules:
        if hasattr(module,c):
            return getattr(module, c)


def class_constant():
    c = word
    return do_get_class_constant(c)
    # if not Object._try(const_defined) c: raise NameError "uninitialized constant #{c)"


def get_obj(o):
    if not o: return False
    eval(o)  # except variables[o]

    # Object.property  or  object.property


def property():
    must_contain_before(' ', ".")
    no_rollback11()
    owner = class_constant
    owner = get_obj(owner) or variables[true_variable()].value  #reference
    _('.')
    properti = word
    return Property(name=properti, owner=owner)


def declaration():
    should_not_contain('=')
    # must_contain_before  be_words+['set'],';'
    a = _try(the)
    mod = _try(modifier)
    type = typeNameMapped
    ___('var', 'val', 'value of')
    mod = mod or _try(modifier)  # public static :.
    var = _try(property) or variable(a)
    assure_same_type(var, type)
    # var.type = var.type or type
    var.final = const.contains(mod)
    var.modifier = mod
    return var


#  CAREFUL WITH WATCHES!!! THEY manipulate the current system, especially variable
#r'*	 let nod be nods *'
def setter():
    must_contain_before['>', '<', '+', '-', '|', '/', '*'], be_words + ['set']
    if _try(let): _let = no_rollback11()
    a = _try(the)
    mod = _try(modifier)
    type = _try(typeNameMapped)
    ___('var', 'val', 'value of')
    mod = mod or _try(modifier)  # public static :.
    var = _try(property) or variable(a)
    # _22("always") => pointer()
    setta = ___('to') or be  # or not_to_be 	contain -> add or create
    val = _try(adjective) or expressions
    no_rollback11()
    if setta == 'are' or setta == 'consist of' or setta == 'consists of': val = [val].flatten
    if _let: assure_same_type_overwrite(var, val)
    # var.type=var.type or type or type(val) #eval'ed! also x is an integer
    assure_same_type(var, type or type(val))
    if not variableValues.contains(var.name) or mod != 'default' and interpret:
        variableValues[var.name] = val

    var.value = val
    var.final = const.contains(mod)
    var.modifier = mod
    if isinstance(var, Property): var.owner.send(var.name + "=", val)  #todo
    result = val
    # end_expression via statement!
    # if interpret: return var

    subnode(var=var)
    subnode(val=val)
    if interpreting(): return val
    return var
    # if angel.use_tree: return parent_node()
    # if not interpret: return old-the.string
    #  or 'to'
    #'initial'?	_try(let) _try(the) ('initial' or 'var' or 'val' or 'value of')? variable (be or 'to') value


# a=7
# a dog=7
# Int dog=7
# my dog=7
# a green dog=7
# an integer i
def isType(x):
    if isinstance(x, type): return True
    if type_names.contains(x): return True
    return False

    # already existing


def current_node():
    pass


def current_context():
    pass


def variable(a=None):
    a = a or _try(article)
    if a != 'a': a = None  #hack for a variable
    typ = _try(typeNameMapped)  # DOESN'T BELONG HERE!  e.g. int i++
    p = ___(possessive_pronouns)
    # all=p ? [p] : []
    try:
        all = one_or_more(word)
    except:
        if a == 'a':
            all = [a]
        else:
            raise NotMatching()
    if not all or all[0] == None: raise_not_matching
    name = all.join(' ')
    if not typ and all.length > 1 and isType(all[0]): name = all[1:-1].join(' ')  #(p ? 0 : 1)
    if p: name = p + ' ' + name
    name = name.strip()
    oldVal = variableValues[name]
    # {variable:{name:name,type:typ,scope:current_node,module:current_context))
    if variables[name]: return variables[name]
    result = Variable({name: name, type: typ, scope: current_node(), module: current_context(), value: oldVal})
    variables[name] = result
    # if p: variables[p+' '+name]=result
    result


def word(include=[]):
    #danger:greedy!!!
    no_keyword_except(include)
    raiseNewline()
    #if not the.string: raise EndOfDocument.new
    #if _try(starts_with) keywords: return false
    match = the.string.match(r'^\s*[a-zA-Z]+[\w_]*')
    if (match):
        the.string = the.string[match[0].length:-1].strip
        current_value = match[0].strip
        return match[0]

        #fad35
        #unknown
        # noun

        # NOT SAME AS should_not_start_with!!!


def should_not_contain(words):
    for w in [words].flatten:
        if w.match(r'^\w'):
            bad = the.string.match(r'(?im)^\w#{w)^\w')
        else:
            if the.string.match(r';'):
                bad = the.string.match(r'#{escape_token(w)).*?;')
            else:
                bad = the.string.match(r'#{escape_token(w))')

        if bad:
            raise ShouldNotMatchKeyword(w)


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
           maybe(true_variable()) or \
           maybe(the_noun_that)  # or
    #_try( variables_that ) # see selectable


def article():
    tokens(articles)


def number_or_word():
    _try(number) or word()


def arg(position=1):
    pre = _try(preposition) or ""  #  might be superfluous if calling"BY":
    _try(article)  #todo use a vs the ?
    a = _try(variable)
    if a: return Argument(name=a.name, type=a.type, preposition=pre, position=position)
    type = _try(typeNameMapped)
    v = endNode
    name = pre + (a and a.name or "")
    return Argument({preposition: pre, name: name, type: type, position: position, value: v})


# BAD after filter, ie numbers [ > 7 ]
# that_are bigger 8
# whose z are nonzero
def compareNode():
    c = comparison()
    if not c: raise NotMatching("NO comparison")
    if c == '=': raise NotMatching('compareNode = not allowed')  #todo Why not / when
    the.rhs = endNode()  # expression
    return the.rhs


def whose():
    _('whose')
    endNoun
    compareNode  # is bigger than live


# things that stink
# things that move backwards
# people who move like Chuck
# the input, which has caused problems
#images which only vary horizontally
def that_do():
    __('that', 'who', 'which')
    star(adverb)  # only
    comp = verb  # live
    maybe_token('s')  # lives
    star(lambda: _try(adverb) or maybe(preposition) or maybe(endNoun))


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
    if c.startswith('more') or c.ends_with('er'): return c


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
    star(
        _try(adverb) or _try(preposition) or _try(endNoun)
    )


def that():
    filter = maybe(that_do) or maybe(that_are) or whose


def where():
    tokens('where')  # NOT: ,'who','whose','which'
    condition


# _try(ambivalent)  delete james from china

def current_value():
    TreeBuilder.current_value()


def selector():
    if checkEndOfLine(): return
    x = maybe(compareNode) or \
        maybe(where) or \
        maybe(that) or \
        maybe(token('of') and endNode) or \
        preposition and nod  # friends in africa
    if angel.use_tree:
        parent_node()
    else:
        current_value()
    return x


# preposition nod  # _try(ambivalent)  delete james, from china delete (james from china)

# (who) > run like < rabbits
# contains
def verb_comparison():
    star(adverb)
    comp = verb  # WEAK !?
    _try(preposition)
    comp


def comparison():  # WEAK _try(pattern)):
    comp = maybe(verb_comparison) or \
           comparation()  # are bigger than


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
        no_rollback11()

    if eq: maybe_token('to')
    ___('and', 'or', 'xor', 'nor')
    ___(comparison_words)  # bigger or equal != different to condition_tree True or false
    comp = comp and pointer() - start or eq
    # if Jens.smaller then ok:
    maybe_token('than')  #, 'then' #_22'then' ;) danger:
    subnode(comparation=comp)
    comp


def either_or():
    ___('be', 'is', 'are', 'were')
    tokens('either', 'neither')
    _try(comparation)
    value
    ___('or', 'nor')
    _try(comparation)
    value


def is_comparator(c):
    ok = comparison_words.contains(c) or \
         comparison_words.contains(c - "is ") or \
         comparison_words.contains(c - "are ") or \
         comparison_words.contains(c - "the ") or \
         class_words.contains(c)
    ok


def check_list_condition(quantifier,lhs,comp,rhs):
    # if not a.isa(Array): return True
    # see quantifiers
    try:
        count = 0
        comp = comp.strip()
        for item in lhs:
            if is_comparator(comp): result = do_compare(item, comp, rhs)
            if not is_comparator(comp): result = do_send(item, comp, rhs)
            if not result and ['all', 'each', 'every', 'everything', 'the whole'].matches(quantifier): break
            if result and ['either', 'one', 'some', 'few', 'any'].contains(quantifier): break
            if result and ['no', 'not', 'none', 'nothing'].contains(quantifier):
                the.negated = not the.negated
                break

            if result: count = count + 1

        min = lhs.length / 2
        if quantifier == 'most' or quantifier == 'many': result = count > min
        if quantifier == 'at least one': result = count >= 1
        # todo "at least two","at most two","more than 3","less than 8","all but 8"
        # if not result= not result
        if not result:
            verbose("condition not met #{lhs) #{comp) #{rhs)")

        return result
    except Exception as e:
        #debug x #soft message
        error(e)  #exit!

    return False


def check_condition(cond=None, negate=False):
    if cond == True or cond == 'True': return True
    if cond == False or cond == 'False': return False
    if cond != None and not isinstance(cond, TreeNode) and not isinstance(cond, str): return cond
    # cond==None  or 
    # if cond==false: return false
    try:
        # else: use state variables todo better!
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
            result = do_compare(lhs, comp, rhs)
        else:
            result = do_send(lhs, comp, rhs)

        # if  not result and cond:
        #   #if c: a,comp,b= extract_condition c
        #   evals=''
        #   variables.each { |var, val| evals+= "#{var)=#{val);" )
        #   result=eval(evals+cond.join(' ')) #dont set result here (i.e. while(:.)last_result )
        #
        # if _not: result = not result
        if negate: result = not result
        if not result:
            verbose("condition not met #{cond) #{lhs) #{comp) #{rhs)")

        return result
    except Exception as e:
        #debug x #soft message
        error(e)  #exit!

    return False


def action_or_expressions(fallback=None):
    maybe(action) or expressions(fallback)
    # maybe(expressions(fallback))
    # expressions(fallback)

    # all of 1,2,3
    # all even numbers in [1,2,3,4]
    # one element in 1,2,3


def element_in():
    _try(noun)
    __('in'), "of"


def condition():
    start = pointer()
    brace = maybe_token('(')
    negated = maybe_token('not')
    if negated: brace = brace or maybe_token('(')
    # a=endNode:(
    quantifier = ___(quantifiers)  # vs selector()!
    if quantifier: _try(element_in)
    lhs = action_or_expressions(quantifier)
    _not = False
    comp = use_verb = maybe(verb_comparison)  # run like , contains
    if not use_verb: comp = maybe(comparation)
    # allow_rollback # upto _try(where)?
    if comp: rhs = action_or_expressions(None)
    if brace: _(')')
    negate = (negated or _not) and not (negated and _not)
    subnode(negate=negate)
    if not comp: lhs

    # 1,2,3 are smaller 4  VS 1,2,3.contains(4)
    if isinstance(lhs, list) and not _try(lambda: lhs.respond_to(comp)) and not isinstance(rhs,
                                                                                           list): quantifier = quantifier or "all"
    # if not comp: return  negate ?  not a : a
    if interpreting():
        if quantifier:
            if negate:
                return ( not check_list_condition(quantifier))
            else:
                return check_list_condition(quantifier)
        if negate:
            return ( not check_condition())
        else:
            return check_condition()  # None

    # return Condition.new lhs:a,cmp:comp,rhs:b
    if not angel.use_tree: return start - pointer()
    if angel.use_tree: return parent_node()


def condition_tree(recurse=True):
    brace = maybe_token('(')
    maybe_token('either')  # todo don't match 'either of'!!!
    # negate=maybe_token('neither')
    if brace and recurse: c = condition_tree(False)
    if not brace: c = condition
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
    newline22
    must_contain('else:', 'otherwise')
    ___('else:', 'otherwise')
    # if :. ! _try(OK): else:
    e = expressions
    ___('else:', 'otherwise' and newline)
    e


# todo  I hate to :.
def loveHateTo():
    ___('would', "wouldn't")
    ___('do', 'not', "don't")
    __['want', 'like', 'love', 'hate']
    _('to')


def gerundium():
    verb
    token('ing')


def verbium():
    comparison or verb and adverb  # be or have or 


def the_noun_that():
    _try(the)
    n = noun
    if not n: raise_not_matching("no noun")
    star(selector)
    n


#def plural:
#  word #todo
#


def const_defined(c):
    pass


def classConstDefined():
    try:
        c = word().capitalize
        if not _try(const_defined(c)): return False
    except NameError as e:
        raise NotMatching()

    if interpreting(): c = do_get_class_constant(c)
    c


def typeNameMapped():
    x = typeName
    if x == "int": return int
    x


def typeName():
    _try(classConstDefined) or tokens(type_names)


def gerund():
    #'stinking'
    match = the.string.match(r'^\s*(\w+)ing')
    if not match: return False
    the.string = match.post_match
    pr = ___(prepositions)  # wrapped in
    if pr: _try(endNode)
    current_value = match[1]
    current_value


def postjective():  # 4 squared , 'bla' inverted, buttons pushed in, mail read by James):
    match = the.string.match(r'^\s*(\w+)ed')
    if not match: return False
    the.string = match.post_match
    if not checkEndOfLine(): pr = ___(prepositions)  # wrapped in
    if pr and not checkEndOfLine(): _try(endNode)  # silver
    current_value = match[1]
    current_value

    # TODO: big cleanup!
    # see resolve, eval_the.string,  do_evaluate, do_evaluate_property, do_s


def do_evaluate_property(x, y):
    # todo: REFLECTION / eval NODE !!!
    if not x: return False
    verbose("do_evaluate_property '+str(x)+' ") + str(y)
    result = None  #delete old!
    if x == 'type': x = 'class'  # !!*)($&) NOO
    if isinstance(x, TreeNode): x = x.value_the.string
    result = do_send(y, x, None)  #try 1
    result = eval(y + '.' + x)  #try 1
    if isinstance(x, list): x = x.join(' ')
    result = eval(y + '.' + x)  #try 2
    y = str(y)  #if _try(y.is_a) Array:
    result = eval(y + '.' + x)  #try 3
    if (result): return result
    all = str(x) + ' of ' + str(y)
    x = x.gsub(' ', ' :')
    try:
        result = eval(y + '.' + x)
        if not result: result = eval("'" + y + "'." + x)
        #if not result  except SyntaxError: result=eval('"'+y+'".'+x)
        if not result: result = eval(all)
    except:
        error('')
    return result

    # Strange method, see resolve, do_evaluate


def eval_string(x):
    if not x: return None
    if isinstance(x, extensions.File): return x.to_path
    if isinstance(x, str): return x
    # and x.index(r'')   :. notodo :.  x.match(r'^\'.*[^\/]$'): return x
    # if _try(x.is_a) Array: x=x.join(" ")
    if isinstance(x, list) and x.count == 1: return x[0]
    if isinstance(x, list): return x
    # if _try(x.is_a) Array: return x.to_s
    return do_evaluate(x)

    # see resolve eval_the._try(string)??


def do_evaluate(x, type=None):
    if not interpreting(): return x
    try:
        if isinstance(x, list) and x.length == 1: return do_evaluate(x[0])
        if isinstance(x, list) and x.length != 1: return x
        if isinstance(x, Variable): return x.value or variableValues[x.name]
        if isinstance(x, str) and type and isinstance(type, extensions.Numeric): return float(x)
        if variableValues.contains(x): return variableValues[x]
        if x == True or x == False: return x
        if isinstance(x, str) and type and isinstance(type, Fixnum): return float(x)
        if isinstance(x, TreeNode): return x.eval_node(variableValues)
        if isinstance(x, str) and match_path(x): return resolve(x)
        # :. todo METHOD / Function!
        if isinstance(x, extensions.Method): return x.call  #Whoot
        if isinstance(x, function): return x.call  #Whoot
        if isinstance(x, str): return x
        if isinstance(x, str): return eval(x)  #  except x
        return x  # DEFAULT!
    except (TypeError, SyntaxError )as e:
        print("ERROR #{e) in do_evaluate #{x)")
        return x


        # see do_evaluate ! merge


def resolve(x):
    if is_dir(x): return extensions.Directory(x)
    if is_file(x): return extensions.File(x)
    if isinstance(x, Variable): return x.value
    if interpret and variableValues.has_key(x): return variableValues[x.strip]
    x


def self_modifying(method):
    method == 'increase' or method == 'decrease' or method.match(r'\!$')


#
# def self_modifying(method):
#     EnglishParser.self_modifying(method)  # -lol


# INTERPRET only,  todo cleanup method + argument matching + concept
def do_send(obj0, method, args0):
    if not interpreting(): return False
    if not method: return False

    # try direct first!
    # if _try(y.is_a) Array and y.count==1: y=y[0]
    if methods.contains(method):
        result = do_execute_block(methods[method].body, args0)
        return result

    if isinstance(method, Method): obj = method.owner
    obj = obj or resolve(obj0)
    # obj.map{|x| x.value)
    args = args0
    if isinstance(args, Argument): args = args.name_or_value
    if isinstance(args, list) and isinstance(args[0], Argument): args = args.map(name_or_value)
    args = eval_the.string(args)  # except NoMethodError
    if args and isinstance(args, str): args = args.replace_numerals
    # if args and _try(obj.respond_to) + " " etc!: args=args.strip()

    if isinstance(method, Method) and method.owner:
        result = method.call(*args)
        return result

    method_name = (isinstance(method, Method)) and method.str(name) or str(method)  #todo bettter
    # if obj.respond_to(method_name):
    # elif  obj._try(respond_to) method_name+'s':

    result = NoMethodError
    if not obj:
        obj = args0
        result = Object.send(method, args)  #except NoMethodError
        result = args.send(method)  #except NoMethodError #("#{obj).#{op)")
        if (args[0] == 'of' and has_args(method, obj)): result = args[1].send(method)  #except NoMethodError #rest of x
    else:
        if (obj == Object):
            m = method(method_name)
            if not has_args(method, obj, False): result = m.call or Nil
            if has_args(method, obj, True): result = m.call(args) or Nil
        else:
            if not has_args(method, obj, False): result = obj.send(method)
            if has_args(method, obj, True): result = obj.send(method, args)


    #todo: call FUNCTIONS!
    # puts object_method.parameters #todo MATCH!

    # => selfModify todo
    if obj0 or args and self_modifying(method):
        name = (obj0 or args).str(to_sym)  #
        variables[name].value = result  #
        variableValues[name] = result
    end

    # todo : None OK, error not!
    if result == NoMethodError: msg = "ERROR CALLING #{obj).#{method)(): #{args))"
    if result == NoMethodError: raise NoMethodError(msg, method, args)
    # raise SyntaxError("ERROR CALLING: NoMethodError")
    return result


def do_compare(a, comp, b):
    a = eval_the.string(a)  # NOT: "a=3; 'a' is 3" !!!!!!!!!!!!!!!!!!!!   Todo ooooooo!!
    b = eval_the.string(b)
    if a.match(r'^\+?\-?\.?\d') and isinstance(b, extensions.Numeric): a = float(a)
    if b.match(r'^\+?\-?\.?\d') and isinstance(a, extensions.Numeric): b = float(b)
    if isinstance(comp, str): comp = comp.strip
    if comp == 'smaller' or comp == 'tinier' or comp == 'comes before' or comp == '<':
        return a < b
    elif comp == 'bigger' or comp == 'larger' or comp == 'greater' or comp == 'comes after' or comp == '>':
        return a > b
    elif comp == 'smaller or equal' or comp == '<=':
        return a <= b
    elif class_words.index(comp):
        return isinstance(a, b)
        # if b.isa(Class): return a.isa(b)
    elif be_words.index(comp) or comp.match(r'same'):
        return isinstance(a, b) or a.__eq__(b)
    elif comp == 'equal' or comp == 'the same' or comp == 'the same as' or comp == 'the same as' or comp == '=' or comp == '==':
        return a == b  # Redundant
    else:
        try:
            return a.send(comp, b)  # raises!
        except:
            error('ERROR COMPARING ' + str(a) + ' ' + str(comp) + ' ' + str(b))
            return a.send(comp + '?', b)


def get_iterator(list):
    pass


def comp():
    pass


def filter(liste, criterion):
    if not criterion: return liste
    list = eval_the.string(liste)
    if not isinstance(list, list): list = get_iterator(list)
    if angel.use_tree:
        method = criterion['comparative'] or criterion['comparison'] or criterion['adjective']
        args = criterion['endNode'] or criterion['endNoun'] or criterion['expressions']
    else:
        method = comp() or criterion()
        args = the.rhs
    list.select(lambda i: do_compare(i, method, args))  #REPORT BUGS!!! except False


def selector(args):
    pass


def selectable():
    must_contain('that', 'whose', 'which')
    ___('every', 'all', 'those')
    xs = resolve(true_variable) or endNoun
    s = maybe(selector)  # rhs=xs, lhs implicit! (BAD!)
    if interpret: x = filter(xs, s)  # except xs
    return x


def ranger():
    if the.in_params: return False
    must_contain('to')
    maybe_token('from')
    a = number
    _('to')
    b = number
    return range(a, b)  # a:b # (a:b).to_a


# #  or  endNode have adjective  or  endNode attribute  or  endNode verbTo verb # or endNode auxiliary gerundium
def endNode():
    raiseEnd
    x = any(lambda:  # NODE )
            #_try( plural) or 
            maybe(list) or
            maybe(rubyThing) or
            maybe(fileName) or
            maybe(linuxPath) or
            maybe(quote) or  #redundant with value !
            maybe(lambda: _try(article) and typeNameMapped) or
            maybe(evaluate_property) or
            maybe(selectable) or
            maybe(true_variable()) or
            maybe(_try(article) and word) or
            maybe(ranger) or  # not params!
            maybe(value) or
            maybe(token('a'))  # variable 'a' not as article DANGER!
            )
    po = maybe(postjective)  # inverted
    if po and interpret: x = do_send(x, po, None)
    x


def endNoun(included=[]):
    _try(article)
    adjs = star(adjective)  #  first second :. included
    obj = maybe(noun(included))
    if not obj:
        if adjs and adjs.join(' ').is_noun:
            return adjs.join(' ')
        else:
            raise NotMatching('no endNoun')

    if angel.use_tree: return obj
    #return adjs.to_s+" "+obj.to_s # hmmm  hmmm   hmmm  W.T.F.!!!!!!!!!!!!!?????
    if adjs and isinstance(adjs, list): adjs = ' ' + adjs.join(' ')
    return str(obj) + str(adjs)  # hmmm hmmm   hmmm  W.T.F.!!!!!!!!!!!!!????? ( == todo )


def any_ruby_line():
    line = the.string
    the.string = the.string.gsub(r'.*', '')
    checkNewline()
    line


def start_block(type=None):
    if type:
        xmls = maybe_token('<')
        _(type)
        if xmls: _('>')

    if checkNewline(): return OK
    ___(':', 'do', '{', 'first you ', 'second you ', 'then you ', 'finally you ')


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
    v = endNode  # true_variable()
    _('[')
    i = endNode
    _(']')
    set = maybe_token('=')
    if set: set = expressions
    # if interpreting(): result=v.send :index,i
    # if interpreting(): result=do_send v,:[], i
    # if set and interpreting(): result=do_send(v,:[]=, [i, set])
    va = resolve(v)
    if interpreting(): result = va.__index__(i)  #old value
    if set and interpreting():
        result = va.__index__(i, set)
    if set and isinstance(v, Variable): v.value = va

    # if interpreting(): result=do_evaluate "#{v)[#{i)]"
    result


def evaluate_property():
    maybe_token('all')  # list properties (all files in x)
    must_contain_before('(', ['of', 'in', '.'])
    raiseNewline()
    x = endNoun(type_keywords)
    __('of', 'in')
    y = expressions()
    if not interpret: return parent_node()
    try:  #interpret !:
        result = do_evaluate_property(x, y)
    except SyntaxError as e:
        verbose("ERROR do_evaluate_property")
        #if not result: result=jeannie all
    except Exception as e:
        verbose("ERROR do_evaluate_property")
        verbose(e)
        error(e)
        error(traceback.extract_stack())
        #if not result: result=jeannie all

    return result


def jeannie(request):
    jeannie_api = 'https:r''weannie.pannous.com/_try(api)'
    params = 'login=test-user&out=simple&input='
    #if not current_value: raise "empty evaluation"
    # download(jeannie_api+params+URI.encode(request))


#  those attributes. _try(hacky) do better / don't use
def subnode(attributes={}):
    if not angel.use_tree: return
    if not current_node: return

    def lamb():
        node = TreeNode({name: name, value: value})
        nodes.append(node)
        current_node.nodes.append(node)
        current_value = value

    attributes.each(lamb)

    return attributes  #current_value


def evaluate():
    ___('what is', 'evaluate', 'how much', 'what are', 'calculate', 'eval')
    no_rollback11()
    the_expression = rest_of_line
    subnode(statement=the_expression)
    current_value = the_expression
    try:
        result = eval(english_to_math(the_expression))  #if not result:
    except:
        result = jeannie(the_expression)

    subnode(result=result)  #: via automagic)
    current_value = result
    current_value


def newline22():
    maybe(newline)


def raiseNewline():
    if not the.string: raise EndOfLine()


def checkNewline():
    if not not the.string: comment
    if not the.string or not the.string.strip:
        if the.line_number < lines.count: line_number = the.line_number + 1
        if line_number >= lines.count:
            the.original_string = ''
            the.string = ''  #done!
            return NEWLINE

        #if line_number==lines.count: raise EndOfDocument.new
        the.string = lines[line_number].strip  #LOOSE INDENT HERE!!!
        the.string = the.string.gsub(r'\/\/.*', "")  # todo : Grab comment
        the.original_string = the.string or ''
        checkNewline()
        return NEWLINE


def newline():
    if checkNewline() == NEWLINE: return NEWLINE
    found = tokens(newline_tokens())
    if checkNewline() == NEWLINE:  # get new line: return NEWLINE
        return found
    return False


def newlines():
    #one_or_more{newline)
    return star(newline)


def NL():
    return tokens('\n', '\r')


def NLs():
    return tokens('\n', '\r')


def rest_of_statement():
    current_value = the.string.match(r'(.*?)([\r\n;]|done)')[1].strip
    the.string = the.string[current_value.length:-1]
    return current_value


# todo merge ^> :
def rest_of_line():
    if not the.string.match(r'(.*?)[;\n]'):
        current_value = the.string
        the.string = None
        return current_value

    match = the.string.match(r'(.*?)([;\n].*)')  # Need to preserve ;\n Characters for 'end of statement'
    current_value = match[1]
    the.string = match[2]
    current_value = current_value.strip()
    return current_value


def comment_block():
    token('/*')
    while not the.string.match(r'\*\/'):
        rest_of_line()
        newline22()  #_try(weg)

    the.string.gsub('.*?\*\/', '')
    #token '*/'
    # add_tree_node


def comment():
    if the.string == None: raiseEnd()
    the.string = the.string.replace(r' -- .*', '')
    the.string = the.string.replace(r'\/\/.*', '')  # todo
    the.string = the.string.replace(r'#.*', '')
    if not the.string: checkNewline()


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
#         if lines.count > histSize: lines = lines[-histSize, histSize]
#         File::open(history_file, File::WRONLY|File::CREAT|File::TRUNC) (lambda io: io.print(lines.join("\n") ))
#
#     except Exception as e:
#       print("Error when configuring history: #{e)")
#

def start_shell():
    angel.verbose = False
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
        #   input = STDIN.gets.strip
        try:
            # interpretation= parser.parse input
            interpretation = parse(input)
            if not interpretation: next
            if angel.use_tree: print(interpretation.tree)
            print(interpretation.result)
        # except NotMatching as e:
        #   print('Syntax Error')
        # except GivingUp as e:
        #   print('Syntax Error')
        except Exception as e:
            print(e)
        input0 = input()
    print("")
    exit()


def startup():
    ARGV = sys.argv
    # ARGF=sys.argv
    if ARGV.count == 0: return start_shell()  #and not ARGF:
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
            result = interpretation.result
            if angel.use_tree: print(interpretation.tree)
            if result and not not result and not result == Nil: print(result)
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
# def result:
#   result
#
# $testing=testing or False
# if ARGV and not $testing and not $commands_server: EnglishParser.startup

def verbs():
    return main_verbs  # None #remove:


def be(self): self.tokens(be_words)


def modifier(self): self.tokens(modifiers)


def attribute(self): self.tokens(attributes)


def preposition(self): self.tokens(prepositions)


def pronoun(self): self.tokens(pronouns)


def nonzero(self): self.tokens('nonzero', 'not null', 'defined', 'existing', 'existant', 'available')


# def # nill=t(self):self.self.tokens(nill_words)
#     return Nill

def adverb(self):
    self.no_keyword_except(adverbs)
    found_adverb = self.___(adverbs)
    if not found_adverb: self.raise_not_matching("no adverb")
    if not angel.use_wordnet(): return found_adverb
    self.current_value = found_adverb or self.wordnet_is_adverb()  # call_is_verb
    return self.current_value


def verb(self):
    self.no_keyword_except(self.system_verbs - be_words)
    found_verb = self.___(self.other_verbs + self.system_verbs - be_words - ['do'])  #verbs,
    if not found_verb: self.raise_not_matching("no verb")
    if not angel.use_wordnet(): return found_verb
    self.current_value = found_verb or self.wordnet_is_verb()  # call_is_verb
    return self.current_value


def adjective(self):
    if not angel.use_wordnet(): return self.tokens('funny', 'big', 'small', 'good', 'bad')
    # if not found_verb: raise_not_matching("no verb")
    return wordnet_is_adjective()


def wordnet_is_noun(self):  # expensive!!!):
    if self.string.match(r'^\d'): raise NotMatching("numbers are not nouns")
    if self.string.match(r'^\s*(\w+)'): the_noun = self.string.match(r'^\s*(\w+)')[1]
    #if not the_noun: return false
    if not the_noun: raise NotMatching("no noun word")
    if not the_noun.is_noun: raise NotMatching("no noun")
    self.string = self.string.strip[the_noun.length:-1]
    return the_noun


def wordnet_is_adjective(self):  # expensive!!!):
    if self.string.match(r'^\s*(\w+)'): the_adjective = self.string.match(r'^\s*(\w+)')[1]  #
    if boolean_words.has(the_adjective): raise NotMatching("no boolean adjectives")
    #if not the_adjective: return false
    if not the_adjective: raise NotMatching("no adjective word")
    if not the_adjective.is_adjective: raise NotMatching("no adjective")
    self.string = self.string.strip[the_adjective.length:-1]
    the_adjective


def wordnet_is_verb(self):  # expensive!!!):
    if self.string.match(r'^\s*(\w+)'): the_verb = self.string.match(r'^\s*(\w+)')[1]
    if not the_verb: return False
    if the_verb.synsets('verb'): raise NotMatching("no verb")
    #if not the_verb.is_verb: raise NotMatching.new "no verb"
    self.string = self.string.strip[the_verb.length:-1]
    return the_verb


def call_is_verb(self):
    # eats=>eat todo lifted => lift
    test = self.string.match(r'^\s*(\w+)_try(s)')[1]
    if not test: return False
    command = app_path() + "r':'word-lists/is_verb " + test
    #puts command
    found_verb = exec(command)
    if not found_verb: raise NotMatching("no verb")
    if found_verb: self.string = self.string.strip[found_verb.length:-1]
    verbose("found_verb " + str(found_verb))
    return found_verb


def call_is_noun(self):
    test = self.string.match(r'^\s*(\w+)')[1]
    if not test: return False
    command = app_path() + "r':'word-lists/is_noun " + test
    found_noun = exec(command)
    if not found_noun: raise NotMatching("no noun")
    if found_noun == found_noun.upcase: raise NotMatching("B.A.D. acronym noun")
    if found_noun: self.string = self.string.strip[found_noun.length:-1]
    verbose("found_noun " + str(found_noun))
    found_noun


def quote(self):
    self.raiseEnd()
    #if checkEnd: return
    # todo :match ".*?"
    if self.string.strip[0] == "'":
        self.string = self.string.strip()
        to = self.string[1:-1].index("'")
        result = current_value = self.string[1:to];
        self.string = self.string[to + 2:-1].strip()
        return Quote(current_value)
        #return "'"+current_value+"'"

    if self.string.strip[0] == '"':
        self.string = self.string.strip()
        to = self.string[1:-1].index('"')
        result = current_value = self.string[1:to];
        self.string = self.string[to + 2:-1].strip
        return Quote(result)
        #return '"'+current_value+'"'

    raise NotMatching("quote")
    #if throwing: throw "no quote"
    return False


def true_variable(self):
    vars = self.variables.keys
    v = self.tokens(vars)
    v = self.variables[v]  #why _try(later)
    #if interpret #LATER!: variableValues[v]
    return v
    #for v in variables.keys:
    #  if self.string._try(start_with) v:
    #    var=token(v)
    #    return var
    #
    #
    #self.tokens(variables_list # todo: remove (in endNodes, selectors,:.))


def noun(self, include=[]):
    a = self._try(the)
    if not a: self.should_not_start_with(self.system_verbs)
    if not angel.use_wordnet(): return self.word(include)
    #if true_variable: return True
    self.no_keyword_except(include)
    current_value = self.wordnet_is_noun()  # expensive!!!
    #current_value=call_is_noun # expensive!!!
    self.tokens(self.question_words)

    # is defined as
    #


def bla(self):
    return self.tokens('hey')  #,'here is')


def the(self):
    return self.tokens(articles)


def the_(self):
    self.maybe(the)


def number_word(self):
    return self.__(numbers).parse_integer  #except NotMatching.new "no number"


def fraction(self):
    f = self.maybe(integer) or 0
    self.raiseEnd()
    m = self.starts_with(["¼", "½", "¾", "⅓", "⅔", "⅕", "⅖", "⅗", "⅘", "⅙", "⅚", "⅛", "⅜", "⅝", "⅞"])
    if not m: raise NotMatching
    self.string.shift
    m = m.parse_number
    result = float(f) + m
    return result


def number(self):
    self._try(real) or self._try(fraction) or self._try(integer) or self._try(number_word)


# _try(complex)  or

def integer(self):
    self.raiseEnd()
    match = self.string.match(r'^\s*-?\d+')
    if match:
        current_value = match[0].to_i
        self.string = match.post_match.strip
        return current_value

    #return false
    raise NotMatching("no integer")
    #plus{self.tokens('1','2','3','4','5','6','7','8','9','0'))


def real(self):
    self.raiseEnd()
    match = self.string.match(r'^-?\d*\.\d+_try(f)_try(r)')
    if match:
        current_value = match[0].to_f
        self.string = match.post_match.strip
        return current_value

    #return false
    raise NotMatching("no real")


def complex(self):
    match = self.string.match(r'^\s*\d+i')  # 3i
    if not match: match = self.string.match(r'^\s*\d*\.\d+i')  # 3.3i
    if not match: match = self.string.match(r'^\s*\d+\s*\+\s*\d+i')  # 3+3i
    if not match: match = self.string.match(r'^\s*\d*\.\d+\s*\+\s*\d*\.\d+i')  # 3+3i
    if match:
        current_value = match[0].strip
        self.string = match.post_match.strip
        return current_value
    return False


def fileName(self):
    self.raiseEnd()
    match = is_file(self.string, False)
    if match:
        path = match[0]
        path = path.gsub(r'^/home', "'Users")
        path = extensions.File(path)
        self.string = match.post_match.strip
        self.current_value = path
        return path
    return False


def match_path(string):
    m = string.match(r'^(\/[\w\'\.]+)')
    if not m: return False
    return m


def is_file(string, must_exist=True):
    if str(string).match(r'^\d*\.\d+'): return False
    m = str(string).match(r'^([\w\/\.]*\.\w+)') or match_path(string)
    if not m: return False
    return must_exist and m and os.path.isfile(m) or m


def is_dir(string, must_exist=True):
    #(string+" ").match(r'^(\')?([^\/\\0]+(\')?)+ ')
    m = match_path(string)
    return must_exist and m and os.path.isdirectory(m[0]) or m


def linuxPath(self):
    self.raiseEnd()
    match = match_path(self.string)
    if match:
        path = match[0]
        path = path.gsub(r'^/home', "'Users")
        path = extensions.Dir(path)  # except path
        self.string = match.post_match.strip
        self.current_value = path
        return path
    return False


def rubyThing(self):
    self.raiseEnd()
    match = self.string.match(r'^[A-Z]\w+\.\w+')
    if not match:
        return False
    thing = match[0]
    self.string = match.post_match.strip
    args = self.string.match(r'^\(.*?\)')
    if args: self.string = args.post_match.strip
    args = args or " #{value22 or '')"
    thing = thing + "#{args)"
    verbose("rubyThing: " + thing)
    # todo: better than eval!
    if self.interpret(): current_value = eval(thing)
    return current_value

def loops(self):
    # any {#loops }
    def lamb():
      maybe( repeat_every_times ) or\
          maybe( repeat_n_times ) or\
          maybe( n_times_action ) or\
          maybe( action_n_times ) or\
          maybe( for_i_in_collection ) or\
          maybe( while_loop ) or\
          maybe( looped_action ) or\
          maybe( looped_action_until ) or\
          maybe( repeat_action_while) or\
          maybe( as_long_condition_block ) or\
          maybe( forever)
    any(lamb)
# beep every 4 seconds
# every 4 seconds beep
# at 5pm send message to john
# send message to john at 5pm
def repeat_every_times(self):
    must_contain time_words
    dont_interpret11 #'cause later
    ___('repeat')
    b=maybe( action }
    interval=datetime
    no_rollback11
    if not b:
      start_block
      dont_interpret11
      b=maybe( action ) or  block
      end_block

    # event=Event(interval:interval,event:b)
    # event=Event(interval, b)
    # event
    #if angel.use_tree: parent_node()

def repeat_action_while(self):
    _ ('repeat') #,'do'
    if self.string.match(r'\s*while'): raise_not_matching("repeat_action_while != repeat_while_action")
    b=action_or_block
    _( 'while')
    c=condition
    while evaluate_condition(c):
      self.result=do_execute_block(b)
    if self.interpret: end()
    if angel.use_tree: return core.angel.parent_node()
    return self.result

def while_loop(self):
    ___( 'repeat')
    __ ('while','as long as')
    dont_interpret11()
    no_rollback11() #no_rollback11 13 # arbitrary value ! :{
    c=condition()
    no_rollback11()
    ___('repeat') # keep gerunding
    ___('then')
    b=action_or_block #Danger when interpreting it might contain conditions and breaks
    try:
    if interpreting(): r=do_execute_block b while (check_condition c)
    except
      print $!

    end_block?
    r or self.OK

  def until_loop(self):
    ___('repeat')
    __('until','as long as')
    dont_interpret11
    no_rollback11 #no_rollback11 13 # arbitrary value ! :{
    c=condition
    ___('repeat')
    b=action_or_block #Danger when interpreting it might contain conditions and breaks
    if interpreting(): r=do_execute_block b until (check_condition c)
    r

  def looped_action(self):
    must_contain 'as long as', 'while'
    dont_interpret11
    ___('do')
    ___('repeat')
    a=action # or semi-block
    __('as long as', 'while')
    c=condition
    if !interpreting(): return a
    if interpreting(): self.result=do_execute_block a while (check_condition c)
    self.result

  def looped_action_until(self):
    must_contain 'until'
    dont_interpret11
    ___('do')
    ___('repeat')
    a=action # or semi-block
    _'until'
    c=condition
    if !interpreting(): return a
    if interpreting(): self.result=do_execute_block a until (check_condition c)
    self.result

  def is_number(n):
    str(n).replace_numerals!.to_i != 0 #hum

    # notodo: LTR parser just here!
  # say hello 6 times   #=> (say hello 6) times ? give up for now
  # say hello 6 times 5 #=> hello 30 ??? SyntaxError! say hello (6 times 5)
  def action_n_times(self):
    must_contain 'times'
    dont_interpret11
    ___('do')
    #___ "repeat"
    a=action
    ws=a.join(' ').split(' ') except [a]

    if is_number ws[-1] # greedy action hack "say hello 6" times:
      a=ws[0..-2]
      n=ws[-1]

    if not n: n=number
    _('times')
    end_block
    if interpreting(): int(n).times { self.result=do_evaluate a }

  def n_times_action(self):
    must_contain 'times'
    n=number #or int_variable
    _('times')
    no_rollback11
    ___('do')
    ___('repeat')
    dont_interpret11
    a=action_or_block
    if interpreting(): int(n).times { self.result=do_evaluate a }

  def repeat_n_times(self):
    must_contain 'times'
    _('repeat')
    n=number
    _('times')
    no_rollback11
    dont_interpret11
    b=action_or_block
    if interpreting(): n.times { do_execute_block b }
    b
    #if angel.use_tree: parent_node()

# if action was (not) parsed before: todo: node cache: skip action(X) -> _'forever'
  def forever(self):
    must_contain 'forever'
    dont_interpret11
    allow_rollback
    a= action
    _('forever')
    self.forever=True
    if interpreting(): do_execute_block a while (self.forever)

  def as_long_condition_block(self):
    _('as long as')
    c=condition
    start_block
    a=block #  danger, block might contain condition
    end_block
    if interpreting(): do_execute_block a while (check_condition c)

def ruby_action():
    _('ruby')
    return exec(action or quote)
