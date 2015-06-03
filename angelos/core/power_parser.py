#!/usr/bin/env ruby
# encoding: utf-8
# from TreeBuilder import show_tree
# from english_parser import result, comment, condition, root
import tokenize
import const
import english_parser
import english_tokens
import re
import token as _token
import exceptions
from exceptions import *
from nodes import Pointer
# from exceptions import NotMatching
import nodes
import angle
# from exceptions import *
from english_tokens import NEWLINE
from the import *
import the


#Beware of decorator classes. They don't work on methods unless you manually reinvent the logic of instancemethod descriptors.
class Starttokens(object):
    def __init__(self,starttokens):
        if not isinstance(starttokens,list):
            starttokens=[starttokens]
        self.starttokens = starttokens
    def __call__(self, original_func):
        decorator_self = self
        for t in self.starttokens:
            if t in the.token_map:
                print("ALREADY mapped %s to %s, now %s"%(t, the.token_map[t],original_func))
            the.token_map[t]=original_func
        return  original_func
        # def wrappee( *args, **kwargs):
        # print 'in decorator with',decorator_self.flag
        #     original_func(*args,**kwargs)
        # return wrappee

# def starttokens(keywords,fun):
#     for t in keywords:
#         token_map[t]=fun
#     return fun


#
# class NotMatching(StandardError):
#     pass

class StandardError(Exception):
    pass

class Error(Exception):
    pass

class NoMethodError(StandardError):
    pass

class InternalError(StandardError):
    pass

class NotMatching(StandardError):
    pass

class UnknownCommandError(StandardError):
    pass

class SecurityError(StandardError):
    pass

# NotPassing = Class.new StandardError
class NotPassing(StandardError):
    pass

class NoResult(NotMatching):
    pass

class EndOfDocument(StandardError):
    pass

class EndOfLine(NotMatching):
    pass

class MaxRecursionReached(StandardError):
    pass

class EndOfBlock(NotMatching):
    pass

class GivingUp(StandardError):
    pass

class ShouldNotMatchKeyword(NotMatching):
    pass

class KeywordNotExpected(NotMatching):
    pass

class UndefinedRubyMethod(NotMatching):
    pass

class WrongType(StandardError):
    pass

class ImmutableVaribale(StandardError):
    pass

class SystemStackError(StandardError):
    pass



def app_path():
    return "./"


def dictionary_path():
    app_path() + "word-lists/"


def isnumeric(start):
    return isinstance(start, int) or isinstance(start, float)  # or isinstance(start, long)


        # def current_context():
        # context: tree / per node

        # def javascript:
        # _try(script_block)
        #   __(current_context)=='javascript' ? 'script' : 'java script', 'javascript', 'js'
        #   no_rollback() 10
        #   javascript+=rest_of_line+';'
        #   newline22
        #   return javascript
        #   #if not javascript: block and done
        #


# _try=maybe

def star(lamb):
    global  throwing,nodes
    # checkEnd
    if (len(nodes) > max_depth):
        raise SystemStackError("if(len(nodes)>max_depth)")

    was_throwing = throwing
    throwing = True
    old_state = current_value  # DANGER! must set current_value=None :{
    max = 20  # no list of >100 ints !?! WOW exclude lists!! TODO OOO!
    current = 0
    good = []
    # try:
    old_nodes = list(nodes) #clone
    # entry_node_offset=len(nodes)-1
    # if(entry_node_offset>48)
    # entry_node=last_node
    #
    old=current_token
    # oldstring = the.string
    # last_string = ""
    try:
        while not checkEndOfLine():# many statements, so ';' is ok! but: MULTILINE!?!
            # if the.string == "" or the.string == last_string: break
            # last_string = the.string
            match = lamb() # yield  # <------!!!!!!!!!!!!!!!!!!!
            if not match: break
            old=current_token
            # oldstring = the.string  # (partial)  success
            good.append(match)
            if current > max and throwing: raise " too many occurrences of " + to_source(lamb)

    except NotMatching as e:
        set_token(old)
        # the.string = oldstring  # partially reconstruct
        if very_verbose and not good:
            verbose
            "NotMatching star " + str(e)
            # if tokens and len(tokens)>0: verbose "expected any of "+tokens.to_s
            if verbose: print_pointer

    except EndOfDocument as e:
        # raise e
        verbose("EndOfDocument")
        #break
        #return false
    except IgnoreException as e:
        error(e)
        error("error in star " + to_source(lamb))
        # warn e
    # except Exception as e:
    #     error(e)
    #     raise e

    if len(good) == 1: return good[0]
    if not not good: return good
    # else: restore!
    throwing = was_throwing
    set_token(old)
    # the.string = oldstring
    # invalidate_obsolete(old_nodes)
    nodes = old_nodes
    # cleanup_nodes_till entry_node
    # for i in entry_node_offset...nodes.size:
    #   nodes.delete_at i
    #
    return old_state
    # except
    #
    # use _22
    #def maybe(token):
    #  return token token except True
    #


def ignore_rest_of_line():

    if not re.search("\n",the.string):
        the.string = ""
        return
    return the.string.replace(r'.*?\n', "\n")


def pointer_string():
    if not the.current_token:
        offset=len(the.current_line)
        l=3
    else:
        offset=the.current_offset
        l=the.current_token[3][1]-offset
    return the.current_line[offset:]+"\n"+the.current_line + "\n" + " " * (offset) + "^"*l + "\n"

    offset = len(original_string) - len(the.string)
    if offset < 0: offset = 0
    return original_string + "\n" + " " * (offset) + "^"*l + "\n"


def print_pointer(force=False):
    if(force or the._verbose):
        print(pointer_string())
    return OK


def clean_backtrace(x):
    x = x.select(lambda x: not re.search(r'ruby')).join("\n",x)
    x


def error(e, force=False):
    if isinstance(e, GivingUp): raise e  # hand through!
    if isinstance(e, NotMatching): raise e
    if isinstance(e, str): print(e)
    if isinstance(e, Exception):
        # print(e.str(clazz )+" "+e.str(message))
        # print(clean_backtrace e.backtrace)
        # print(e.str( class )+" "+e.str(message))
        print_pointer()
        if angle.use_tree:
            import TreeBuilder
            TreeBuilder.show_tree()
        if not angle.verbose: raise e  # SyntaxError(e):
        # exit


def warn(e):
    print(e.message)


# def one(*matches):
#
#     oldString = the.string
#     for match in matches:
#         try:
#             the.string = oldString
#             # if match and not isinstance(match, Symbol): return match
#             # if isinstance(match, Symbol): result = send(match)
#             return angel.result  # if result:
#         except NotMatching as e:
#             verbose("NotMatching one " + str(match) + "(" + str(e) + ")")
#             # raise GivingUp.new
#             if not check_rollback_allowed: error
#             return e
#         # except Exception as e:
#         #     error(e)
#         #     return e
#
#     if check_rollback_allowed: the.string = oldString
#     if throwing: verbose
#     "Should have matched one of " + str(matches)
#     raise NotMatching()
    # throw "Should have matched one of "+matches

    # hack for kleene star etc  _22 == maybe(tokens}


# def method_missing(sym, *args, block)  # <- NoMethodError use node.blah to get blah!():
# syms = str(sym)
#     cut = syms[0.. - 2]
#     depth = depth + 1
#     # return send(cut) if(syms.end_with?"!")
#     if (syms.endswith("?")):
#         old_last = last_pattern
#         last_pattern = cut
#         if len(args) == 0: x = maybe(send(cut)}
#         if len(args) == 1: x = maybe(send(cut, args[0])}
#         if len(args) > 1: x = maybe(send(cut, args)}
#         last_pattern = old_last
#         depth = depth - 1
#         return x
#
#     if (syms.endswith("!")):
#         print("DEPRECATED!!")
#         return star(send(cut, args))
#
#     #return star(send(cut)} if(syms.end_with?"*")
#     #return plus{send(cut)} if(syms.end_with?"+")
#     super(sym, *args, block)
#     depth = depth + 1

#
# def __mul__(a):
#     print(a)  # HUH??

def caller():
    import inspect
    curframe = inspect.currentframe()
    calframe = inspect.getouterframes(curframe, 2)
    # calframe_ = calframe[1][3]
    # print('caller name:', calframe_)
    return calframe

def verbose(info):
    if the._verbose:
        print(info)

def info(info):
    if the._verbose:
        print(info)

def error(info):
    # import traceback
    # traceback.print_stack() # backtrace
    # if the.verbose:
    print(info)

def to_source(block):
    return str(block)


def filter_backtrace(e):
    return e

def tokens(tokenz):
    raiseEnd()
    ok=maybe_tokens(tokenz)
    if(ok): return ok
    raise NotMatching(result)

# so much cheaper!!! -> copy to ruby
def maybe_tokens(tokens0):
    for t in flatten(tokens0):
        if t==the.current_word:
            next_token()
            return t
        if " " in t:
            old=the.current_token
            for to in t.split(" "):
                if to!=current_word:
                    t=None
                    break
                else:
                    next_token()
            if not t:
                set_token(old)
                continue
            return t
    return False

def __(x):
    return tokens(x)


# shortcut: method missing (and maybe(}?)
# def maybe_tokens(*x):
#     # DANGER!! Obviously very different semantics from maybe(tokens}!!
#     # remove_tokens x # shortcut
#     return maybe(tokens, x)


# class Parser(object):  # <MethodInterception:
# import
# attr_accessor :lines, :verbose, :original_string

# def __init__():

def next_token(check=True):
    # if check: check_comment()
    the.token_number=the.token_number+1
    if (the.token_number>=len(the.tokenstream)):
        raise EndOfDocument()
    token = the.tokenstream[the.token_number]
    return set_token(token)

def set_token(token):
    global current_token,current_type,current_word,current_line,token_number
    the.current_token= current_token=token
    the.current_type= current_type=token[0]
    the.current_word= current_word=token[1]
    line_number,the.current_offset= token[2]
    end_pointer     = token[3]
    the.current_line= current_line=token[4]
    the.token_number=token_number=token[5]
    the.string=current_word # hack, kinda
    return token[1]


def parse_tokens(s):
    import tokenize
    from io import BytesIO
    the.tokenstream=[]
    def tokeneater(token_type, tokenn, start_row_col, end_row_col, line):
        if token_type!=tokenize.COMMENT:
            the.tokenstream.append((token_type, tokenn, start_row_col, end_row_col, line,len(the.tokenstream)))
    tokenize.tokenize(BytesIO(s.encode('utf-8')).readline,tokeneater) # tokenize the string
    _token.INDENT # not available here :(
    return the.tokenstream

def init(strings):
    # global is ok within one file but do not use it across different files
    global  no_rollback_depth,rollback_depths,line_number,original_string,root,lines,nodes,depth,lhs,rhs,comp
    no_rollback_depth = -1
    rollback_depths=[]
    line_number = 0
    if isinstance(strings, list):
        lines = strings
        parse_tokens("\n".join(strings))
    if isinstance(strings, str):
        lines = strings.split("\n")
        parse_tokens(strings)
    the.token_number=-1
    next_token()
    the.string= lines[0].strip()  # Postpone angel.problem
    original_string = the.string
    root = None
    nodes = []
    depth = 0
    lhs = rhs = comp = None
    for nr in english_tokens.numbers:
        english_parser.token_map[nr]= english_parser.number

    # result           =None NOO, keep old!


def s(s):
    allow_rollback()
    init(s)
    # parser.init the.string


def assert_equals(a, b):
    if a != b: raise NotPassing("#{a} should equal #{b}")


def doassert(x=None, block=None):
    if not x and block: x = block() #yield
    # if not x: raise Exception.new (to_source(block))
    if block and not x: raise NotPassing(to_source(block))
    if not x: raise NotPassing()
    if isinstance(x, str):
        try:
            #if the.string: root
            s(x)
            import english_parser
            ok = english_parser.condition()
        except SyntaxError as e:
            raise e  # ScriptError.new "NOT PASSING: SyntaxError : "+x+" \t("+e.class.to_s+") "+e.to_s
        # except Exception as e:
        #     raise NotPassing("NOT PASSING: " + str(x) + " \t(" + str(type(e)) + ") " + str(e))

        if not ok:
            raise NotPassing("NOT PASSING: " + str(x))
        print(x)

    print("TEST PASSED! " + str(x) + " \t" + to_source(block).to_s)
    return True


def error_position():
    pass


# def interpretation():
#     interpretation.error_position = error_position()
#     return interpretation


# gem 'debugger'
#gem 'ruby-debug19', :require => 'ruby-debug'
#import ruby-debug
#import debugger
#gem 'ParseTree' ruby 1.9 only :{
#import sourcify #http://stackoverflow.com/questions/5774916/print-actual-ruby-code-of-a-block BAD
#import method_source

#gem 'ruby-debug', :platforms => :ruby_18
#gem 'ruby-debug19', :platforms => :ruby_19, :require => 'ruby-debug'

#def maybe(block):
#  return yield except True
#
def raiseEnd():
    if current_type==_token.ENDMARKER:
        raise EndOfDocument()
    if (the.token_number>=len(the.tokenstream)):
        raise EndOfDocument()
    # if not the.string or len(the.string)==0:
    #     if line_number >= len(lines): raise EndOfDocument()
    #     #the.string=lines[++line_number];
    #     raise EndOfLine()

def remove_tokens(*tokenz):
    while(current_word in tokenz):
        next_token()
    # for t in flatten(tokenz):
    #     the.string = the.string.replace(r' *%s *' % t, " ")

def must_contain(*args): # before ;\n
    if isinstance(args[-1], dict):
        return must_contain_before(args[0:-2],args[-1]['before'])
    old=current_token
    while not (checkEndOfLine()):
        for x in flatten(args):
            if current_word==x:
                set_token(old)
                return x
        next_token()
        if current_word==';' or current_word=='\n':
            break
    set_token(old)
    raise NotMatching("must_contain "+str(args))

def must_contain_before(args,before):  #,before():None
    old=current_token
    good=None
    before=flatten(before)
    while not (checkEndOfLine() or current_word in before):
        if current_word in args:
            good=current_word
            break
        next_token()
    set_token(old)
    if not good: raise (NotMatching(args))
    return good

def must_contain_before_old(before, *args):  #,before():None
    raiseEnd()
    good = False
    if before and isinstance(before, str): before = [before]
    if before: before = flatten(before) + [';']
    args = flatten(args)
    for x in flatten(args):
        if re.search(r'^\s*\w+\s*$',x):
            good = good or re.search(r'[^\w]%s[^\w]'%x,the.string)
            if(type(good).__name__=="SRE_Match"):
                good=good.start()
            if good and before and good.pre_match in before and before.index(good.pre_match):
                good = None
        else:  # token
            good = good or re.search(escape_token(x),the.string)
            if(type(good).__name__=="SRE_Match"):
                good=good.start()
            sub=the.string[0:good]
            if good and before and sub in before and before.index(sub):
                good = None
        if good: break

    if not good: raise (NotMatching(x))
    for nl in english_tokens.newline_tokens:
        if nl in str(good): raise (NotMatching(x))  # ;while
        # if nl in str(good.pre_match): raise (NotMatching(x))  # ;while
    return OK


# NOT == starts_with !!!
def look_ahead(x):
    if the.string.index(x):
        return True
    else:
        raise (NotMatching(x))


def _(x):
    return token(x)

def last_try(stack):
    for s in stack:
        if re.search("try",s):
            return s


def caller_name():
    return caller()


# for i in 0..(len(caller)):
#   if not caller[i].match(r'parser'): next
#   name=caller[i].match(r'`(.*)'')[1]
#   if caller[i].index("parser"): return name


def do_interpret():
    global  interpret,interpret_border,did_interpret
    interpret_border = -1
    did_interpret = angle.interpret
    angle.interpret = True


def dont_interpret():
    depth = caller_depth()
    if angle.interpret_border < 0:
        angle.interpret_border = depth
        angle.did_interpret = angle.interpret
    angle.interpret = False


def interpreting(n=0):
    depth = caller_depth()
    if (angle.interpret_border > depth - n):
        angle.interpret = angle.did_interpret
        angle.interpret_border = -1 # remove the border
    return angle.interpret


def check_rollback_allowed():
    c = caller_depth
    throwing = True  #[]
    level = 0
    return c < no_rollback_depth or c > no_rollback_depth + 2


# if no result: same as try but throws


def any(block):
    global throwing
    raiseEnd()
    #if checkEnd: return
    last_try = 0
    #if level>20: throw "Max recursion reached #{to_source(block)}"
    if len(caller()) > 180: raise MaxRecursionReached(to_source(block))
    was_throwing = throwing
    throwing = False
    #throwing[level]=false
    old=current_token
    # oldString = the.string
    result = False
    try:
        result = block() # yield  # <--- !!!!!
        if not result:
            set_token(old)
            # the.string = oldString
            raise NoResult(to_source(block))
        return result
    except EndOfDocument:
        verbose("EndOfDocument")
    except EndOfLine:
        verbose("EndOfLine")
    except GivingUp as e:
        raise e
    except NotMatching:
        verbose("NotMatching")
        #retry
    except IgnoreException as e:
        verbose("Error in %s"%to_source(block))
        error(e)

    if result: verbose("Succeeded with any #{to_source(block)}")
    # if verbose and not result: string_pointer()
    last_token = pointer_string()  #if not last_token:
    if check_rollback_allowed():
        set_token(old)
        # the.string = oldString
    throwing = was_throwing
    #throwing[level]=True
    #level=level-1
    if result: return result
    raise NotMatching(to_source(block))
    #throw "Not matching #{to_source(block)}"


def read_source(x):
    if last_pattern or not x: return last_pattern
    #proc=block.to_source(:strip()_enclosure => True) except "Sourcify::MultipleMatchingProcsPerLineError"
    res = x.source_location[0] + ":" + x.source_location[1].to_s + "\n"
    lines = IO.readlines(x.source_location[0])
    i = x.source_location[1] - 1
    while True:
        res += lines[i]
        if i >= len(lines) or lines[i].match("}") or lines[i].match("end"): break
        i = i + 1
    return res


def caller_depth():
    # c= depth #if angel.use_tree doesn't speed up:
    # if angel.use_tree: c= depth
    c = len(caller())
    if c > max_depth:
        raise SystemStackError("depth overflow")
    return c
    # filter_stack(caller).count #-1


def no_rollback():
    depth =caller_depth()-1
    while len(the.rollback_depths)>0 and the.rollback_depths[-1]>depth:
      the.rollback_depths.pop()
    the.rollback_depths.append(the.no_rollback_depth)
    the.no_rollback_depth =depth


def allow_rollback(n=0):
    if n < 0: the.rollback_depths = []
    if len(the.rollback_depths)>1 :
        the.no_rollback_depth = the.rollback_depths.pop()
    else:
         the.no_rollback_depth = -1

def adjust_rollback(depth=-10):
    try:
        if depth==-10: depth=caller_depth()
        if depth + 2 < the.no_rollback_depth:
            allow_rollback()
    except (Exception,Error) as e:
        error(e)



# todo ? trial and error -> evidence based 'parsing' ?
def invalidate_obsolete(old_nodes):
    #DANGER RETURNING false as VALUE!! use RAISE ONLY todo
            # (nodes - old_nodes).each(lambda n: n.invalid())
            for fuck in old_nodes:
                if fuck in nodes:
                    nodes.remove(fuck)
            for n in nodes:
                n.invalid()
                n.destroy()


# start_block optional !?!
def block():  # type):
    global last_result,original_string
    from english_parser import start_block,statement,end_of_statement,end_block
    start_block()  # NEWLINE ALONE == START!!!?!?!
    start = pointer()
    statements=[statement()]
    # content = pointer() - start
    end_of_block = maybe(end_block)  # ___ done_words
    if not end_of_block:
        end_of_statement()  # danger might act as block end!
        def lamb():
            try:
                print_pointer(True)
                s = statement()
                statements.append(s)
            except NotMatching as e:
                print_pointer(True)
                raise Exception(str(e)+"\nGiving up block\n"+pointer_string())
            # content = pointer() - start
            return end_of_statement()
        star(lamb)
        # _try(end_of_statement)
        end_block()

    the.last_result = the.result
    if interpreting(): return statements[-1]
    if angle.debug:
        print_pointer(True)
    return statements #content
    # if angel.use_tree:
    # p=parent_node()
    # if p: p.content=content
    #   p
    #



def maybe(block):
    if not callable(block): # duck!
        return maybe_tokens(block)
    global original_string, last_node, current_value, depth,nodes,current_node,last_token
    # allow_rollback 1
    depth = depth + 1
    if (caller_depth() > const.max_depth):raise SystemStackError("if(len(nodes)>max_depth)")
    old = current_token
    try:
        old_nodes = list(nodes)#.clone()
        result = block() #yield <<<<<<<<<<<<<<<<<<<<<<<<<<<<
        if angle.debug and (callable(result)):
            raise Exception("returned CALLABLE "+str(result))
        if result or result==0:
            verbose("GOT result from "+str(block)+" : "+str(result))
            adjust_rollback()
        else:
            verbose("No result from "+str(block))
            invalidate_obsolete(old_nodes)
            set_token(old)
            # the.string = old
        last_node = current_node
        return result
    except (NotMatching, EndOfLine) as e:
        if verbose: verbose("Tried "+to_source(block))
        interpreting(2) # remove the border, if above border
        # if verbose: verbose(e)
        # if verbose: string_pointer()
        cc = caller_depth()
        rb = the.no_rollback_depth - 2
        if cc >= rb:
            set_token(old) #OK
            current_value = None
            invalidate_obsolete(old_nodes)
        if cc < rb:  #and not cc+2<rb # not check_rollback_allowed:
            error("NO ROLLBACK, GIVING UP!!!")
            # if angle._verbose:
            #     print(last_token)
            print_pointer()  # ALWAYS!
            if angle.use_tree:
                import TreeBuilder
                TreeBuilder.show_tree()  #Not reached
            ex = GivingUp(to_source(block)+"\n"+pointer_string())
            raise ex
            # error e #exit
            # raise SyntaxError(e)
    except EndOfDocument as e:
        invalidate_obsolete(old_nodes)
        set_token(old)
        verbose("EndOfDocument")
        #raise e
        return False
        #return True
    except GivingUp as e:
        # the.string=old #to mark??
        # maybe => OK !?
        error(e)
        #if not check_rollback_allowed:
        #     if rollback[len(caller)-1]!="NO" #:
    except IgnoreException as e:  # NoMethodError etc
        set_token(old)
        error(e)
        verbose(e)
    except Error as e:
        error(e)
        raise e
    # except Exception as e:
    #     error(block)
    #     import traceback
    #     traceback.print_stack() # backtrace
    #     error(e)
    #     error(block)
    #     print("-------------------------")
    #     quit()
    # finally:
    adjust_rollback()
    depth = depth - 1
    set_token(old) #if rollback:
    nodes = old_nodes  # restore
    return False


def one_or_more(block):
    all = [block()]
    more=star(block)
    if more:
        all.append(more)
    return all


def to_source(block):
    return str(block)

# def many(block): # see star
#     global  old_tree,result
#     while True:
#         try:
#             maybe(comment)
#             old_tree = list(nodes)#.clone
#             result = block() # yield
#             # puts "------------------"
#             #puts nodes-old_tree
#             if(not the.string or len(the.string)==0 ):break  # TODO! loop criterion too week: break
#             if not result or result == []:
#                 raise NotMatching(to_source(block) + "\n" + string_pointer_s())
#         except IgnoreException as e:
#             import traceback
#             traceback.print_stack() # backtrace
#             error(e)

# GETS FUCKED UP BY the.string.strip()! !!! ???
def pointer():
    return current_token[2]
    # global parser
    # if not lines or line_number >= len(lines): return Pointer(line_number, 0, parser)
    # # line_number copy by ref?????????
    # line = lines[line_number] + "$$$"
    # offset = line.find(the.string + "$$$")  # len(original_string)-(the.string or "").length
    # return Pointer(line_number, offset or 0,parser)


def isnumeric(start):
    return start.isdigit()
    # isinstance(start)


def app_path():
    pass
    # File.expand_path(File.dirname(__FILE__)).to_s


class IgnoreException(Exception):
    pass


def parse(s):
    global  last_result,result
    if not s: return
    verbose("PARSING")
    try:
        allow_rollback()
        init(s)
        import english_parser
        the.result=english_parser.rooty()
        if the.result in ['True','true']: the.result=True
        if the.result in ['False', 'false']: the.result=False
        the.last_result = the.result
    # except NotMatching as e:
    #     import traceback
    #     traceback.print_stack() # backtrace
    #     the.last_result = the.result = None
    #     e=filter_backtrace(e)
    #     error(e)
    #     print_pointer(True)
    except IgnoreException as e:
        pass

    verbose("PARSED SUCCESSFULLY!!")
    # show_tree()
    # puts svg
    return english_parser.interpretation()  # # result

    # def start_parser:
    #   a=ARGV[0]  or  app_path+"/../examples/test.e"
    #   if (File.exists? a):
    #     lines=IO.readlines(a)
    #   else:
    #     lines=a.split("\n")
    #
    #   parse lines[0]

def token(t): #_new
    if isinstance(t, list):
        return tokens(t)
    raiseEnd()
    if current_word==t:
        next_token()
        return current_word
    else:
        if throwing: verbose('expected ' + str(result))  #
        print_pointer()
        raise NotMatching(t+"\n"+pointer_string())


def token_old(t):
    global throwing
    if isinstance(t, list): return tokens(t)
    # if checkEnd: return None
    # if t.is_a? Array #HOW TH ?? method_missing: t=t[0]
    the.string = the.string.strip()
    if the.string.startswith('/*'): comment_block()
    raiseEnd()
    if starts_with(t):
        current_value = t.strip()
        the.string = the.string[len(t): - 1]
        if re.match(r'^\w ',the.string) and re.match(r'^\w ',t):
            raise NotMatching(t + " (the.strings needs whitespace, special chars don't)")
        else:
            the.string = the.string.strip()
            return current_value
    else:
        if throwing: verbose('expected ' + str(result))  #
        print_pointer()
        raise NotMatching(t)
        #todo: proper token stream, pre-lex'ed


def flatten(l):
    if isinstance(l,tuple):l=list(l)
    if isinstance(l,str):return [l]
    if isinstance(l,list) and len(l)>0 and not isinstance(l[0],list):
        return l
    if callable(l):l=l()
    from itertools import chain
    return list(chain.from_iterable(l))


def tokens(tokenz):
    raiseEnd()
    ok=maybe_tokens(tokenz)
    if(ok): return ok
    raise NotMatching(str(tokenz)+"\n"+pointer_string())

def tokens_old(*tokenz):
    global  throwing
    # encoding: utf-8
    if isinstance(tokenz,classmethod):
        tokenz=tokenz()
    tokenz=flatten(tokenz)
    raiseEnd()
    if the.string.startswith('/*'): comment_block()
    the.string = the.string.strip() + ' '
    for t in flatten(tokenz):
        # if t.is_a Variable: next
        # if t=='' # todo debug HOW: next
        if (t == "\n" and not the.string): return True
        if re.search(r'^\w',t):
            match = re.search(r'(?im)^\s*'+t,the.string)
            if match and re.search(r'^\w',the.string[match.end():]):
                continue  # next must be space or so!: next
        else:  # special char
            match = re.search(r'(?im)^\s*'+escape_token(t),the.string)
        if match:
            x = current_value = t
            the.string = the.string[match.end():].strip()
            the.string2 = the.string
            return x
    raise NotMatching(result)
    # if throwing:


def escape_token(t):
    z=re.sub(r'([^\w])', "\\\\\\1",t)
    return z


def starts_with(tokenz):
    if checkEndOfLine(): return False
    for t in tokenz:
        if t==the.current_word:
            return t
    return False

def raiseNewline():
    if not the.string: raise EndOfLine()


# see checkEndOfLine
def checkNewline():
    if(current_type==_token.NEWLINE):
        return english_tokens.NEWLINE
    return False

def checkEndOfLine():
    return current_type==_token.NEWLINE or current_type==_token.ENDMARKER or the.token_number>=len(the.tokenstream)
    #if the.string.blank? # no:try,try,try  see raiseEnd: raise EndOfDocument.new
    # return not the.string or len(the.string)==0

def checkEndOfFile():
    return current_type==_token.ENDMARKER or the.token_number>=len(the.tokenstream)
    # return line_number >= len(lines) and not the.string



def newline():
    if checkNewline() == NEWLINE:
        next_token()
        return NEWLINE
    found = tokens(english_tokens.newline_tokens)
    if checkNewline() == NEWLINE:  # get new line: return NEWLINE
        next_token()
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
    current_value =re.search(r'(.*?)([\r\n;]|done)',the.string)[1].strip()
    the.string = the.string[len(current_value):-1]
    return current_value


# todo merge ^> :
def rest_of_line():
    rest=""
    while not checkEndOfLine():
        rest+=next_token(False)+" "
    return rest


def comment_block():
    token('/')
    token('*')
    while True:
        if the.current_word=='*':
            next_token()
            if the.current_word=='/':
                return True
        next_token()

@Starttokens(['//','#','\'','--','/','\''])
def check_comment():
    if the.current_word==None :return
    l = len(the.current_word)
    if l==0: return
    if the.current_type== tokenize.COMMENT:
        next_token()
    # if the.current_word[0]=="#": ^^ OK!
    #        return rest_of_line()
    if(l >1):
        # if current_word[0]=="#": rest_of_line()
        if the.current_word[0:2]=="--": return rest_of_line()
        if the.current_word[0:2]=="//": return rest_of_line()
        # if current_word[0:2]=="' ": rest_of_line() and ...
    # the.string = the.string.replace(r' -- .*', '')
    # the.string = the.string.replace(r'\/\/.*', '')  # todo
    # the.string = the.string.replace(r'#.*', '')
    # if not the.string: checkNewline()

