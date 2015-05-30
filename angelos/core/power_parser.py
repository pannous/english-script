#!/usr/bin/env ruby
# encoding: utf-8
# from TreeBuilder import show_tree
# from english_parser import result, comment, condition, root
import const
import english_tokens
import re
import token as _token
import exceptions
from exceptions import *
from nodes import Pointer
# from exceptions import NotMatching
import nodes
import angel
# from exceptions import *
from english_tokens import NEWLINE
from the import *
import the


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

def star(block):
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
    oldstring = the.string
    last_string = ""
    try:
        while True:
            if the.string == "" or the.string == last_string: break
            last_string = the.string
            match = block() # yield  # <------!!!!!!!!!!!!!!!!!!!
            if not match: break
            oldstring = the.string  # (partial)  success
            good.append(match)
            if current > max and throwing: raise " too many occurrences of " + to_source(block)

    except NotMatching as e:
        the.string = oldstring  # partially reconstruct
        if very_verbose and not good:
            verbose
            "NotMatching star " + str(e)
            # if tokens and len(tokens)>0: verbose "expected any of "+tokens.to_s
            if verbose: string_pointer

    except EndOfDocument as e:
        # raise e
        verbose("EndOfDocument")
        #break
        #return false
    except IgnoreException as e:
        error(e)
        error("error in star " + to_source(block))
        # warn e
    # except Exception as e:
    #     error(e)
    #     raise e

    if len(good) == 1: return good[0]
    if not not good: return good
    # else: restore!
    throwing = was_throwing
    the.string = oldstring
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


def string_pointer_s():
    offset = len(original_string) - len(the.string)
    if offset < 0: offset = 0
    return original_string + "\n" + " " * (offset) + "^^^" + "\n"


def string_pointer():
    if(the.verbose):
        print(string_pointer_s())


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
        string_pointer()
        if angel.use_tree:
            import TreeBuilder
            TreeBuilder.show_tree()
        if not angel.verbose: raise e  # SyntaxError(e):
        # exit


def warn(e):
    print(e.message)


def one(*matches):
    
    oldString = the.string
    for match in matches:
        try:
            the.string = oldString
            # if match and not isinstance(match, Symbol): return match
            # if isinstance(match, Symbol): result = send(match)
            return angel.result  # if result:
        except NotMatching as e:
            verbose("NotMatching one " + str(match) + "(" + str(e) + ")")
            # raise GivingUp.new
            if not check_rollback_allowed: error
            return e
        # except Exception as e:
        #     error(e)
        #     return e

    if check_rollback_allowed: the.string = oldString
    if throwing: verbose
    "Should have matched one of " + str(matches)
    raise NotMatching()
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
    if the.verbose:
        print(info)

def info(info):
    if the.verbose:
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


def maybe_tokens(tokens0):
    return maybe(lambda: tokens(tokens0))
    # return tokens(x)


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

def next_token():
    the.token_number=the.token_number+1
    if (the.token_number>=len(the.tokenstream)):
        raise EndOfDocument()
    token = the.tokenstream[token_number]
    the.current_token= token
    the.current_type= token[0]
    the.current_word= token[1]
    the.current_line= token[4]
    return token[1]


def parse_tokens(s):
    from tokenize import tokenize, untokenize, NUMBER, STRING, NAME, OP
    from io import BytesIO
    def tokeneater(ttype, tokenn, srow_scol, erow_ecol, line):
        the.tokenstream.append((ttype, tokenn, srow_scol, erow_ecol, line))
    tokenize(BytesIO(s.encode('utf-8')).readline,tokeneater) # tokenize the string
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
    if not the.string or len(the.string)==0:
        if line_number >= len(lines): raise EndOfDocument()
        #the.string=lines[++line_number];
        raise EndOfLine()


def checkEndOfLine():
    #if the.string.blank? # no:try,try,try  see raiseEnd: raise EndOfDocument.new
    return not the.string or len(the.string)==0


def checkEndOfFile():
    return line_number >= len(lines) and not the.string


def remove_tokens(*tokenz):
    for t in flatten(tokenz):
        the.string = the.string.replace(r' *%s *' % t, " ")


def must_contain(*args):
    if isinstance(args[-1], dict):
        return must_contain_before(args[-1]['before'], args[0:-2])
    for x in flatten(args):
        if re.search(r'^\s*\w+\s*$',x):
            if re.search(r'[^\w]%s[^\w]'%x," %s "%the.string):
                return True
        else:  # token
            if x in the.string:
                return True

def must_contain_before(before, *args):  #,before():None
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


def _1(x):
    return look_ahead(x)


def _(x):
    return token(x)


def _2(x):
    return maybe(tokens, x)


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
    did_interpret = angel.interpret
    angel.interpret = True


def dont_interpret():
    if angel.interpret_border < 0:
        angel.interpret_border = caller_depth
        did_interpret = angel.interpret
    angel.interpret = False


def interpreting(n=0):
    if (angel.interpret_border >= caller_depth() - n):
        angel.interpret = did_interpret
        angel.interpret_border = -1
    return angel.interpret


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
    oldString = the.string
    result = False
    try:
        result = block() # yield  # <--- !!!!!
        if not result:
            the.string = oldString
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
    last_token = string_pointer_s()  #if not last_token:
    if check_rollback_allowed(): the.string = oldString
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


def no_rollback11(n=0):
    global depth,no_rollback_depth
    depth = caller_depth() - 1
    while (rollback_depths[-1] or -1) > depth:
        rollback_depths.pop()

    rollback_depths.push(no_rollback_depth)
    no_rollback_depth = depth
    # no_rollback_method=caller #_name


def allow_rollback(n=0):
    global  depth,no_rollback_depth,rollback_depths,original_string
    if n < 0: the.rollback_depths = []
    if len(the.rollback_depths)>1 :
        the.no_rollback_depth = the.rollback_depths.pop()
    else:
         the.no_rollback_depth = -1
    the.original_string = the.string  #if following(no_rollback11):


def adjust_rollback(depth=-10):
    try:
        global  no_rollback_depth
        if depth==-10: depth=caller_depth()
        if depth + 2 < no_rollback_depth:
            no_rollback_depth = rollback_depths.pop() or -1
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



def block():  # type):
    global last_result,original_string
    from english_parser import start_block,statement,end_of_statement,end_block
    start_block()  # NEWLINE ALONE == START!!!?!?!
    original_string = the.string  # _try(REALLY)?
    start = pointer()
    statements=[statement()]
    content = pointer() - start
    end_of_block = maybe(end_block)  # ___ done_words
    if not end_of_block:
        end_of_statement()  # danger might act as block end!
        def lamb():
            statements.append(statement())
            content = pointer() - start
            end_of_statement

        star(lamb)
        # _try(end_of_statement)
        end_of_block = end_block()

    last_result = the.result
    if interpreting(): return statements[-1]
    return content
    # if angel.use_tree:
    # p=parent_node()
    # if p: p.content=content
    #   p
    #

def maybe(block):
    if not callable(block): # duck!
        return maybe_tokens(block)
    global original_string, last_node, current_value, depth,nodes,current_node,last_token
    #if checkEnd: return
    # allow_rollback 1
    depth = depth + 1
    if (caller_depth() > const.max_depth):raise SystemStackError("if(len(nodes)>max_depth)")
    old = the.string  # NOT overwritten, instead of:
    if not original_string: original_string = the.string or ""
    try:
        old_nodes = list(nodes)#.clone()
        result = block() #yield <<<<<<<<<<<<<<<<<<<<<<<<<<<<
        if(callable(result)):
            raise Exception("returned CALLABLE "+str(result))
        if result:
            adjust_rollback()
        else:
            invalidate_obsolete(old_nodes)
            the.string = old

        last_node = current_node
        return result
    except (NotMatching, EndOfLine) as e:
        # old=original_string # REALLY>??
        current_value = None
        the.string = old
        interpreting(2) #?
        # if verbose: verbose(e)
        if verbose: verbose("Tried "+to_source(block))
        # if verbose: string_pointer()
        invalidate_obsolete(old_nodes)
        # (nodes - old_nodes).each(lambda n: n.destroy())  #n.valid=false;
        #caller.index(last_try caller)]
        #puts rollback[len(caller)]
        #puts len(caller)
        #puts rollback
        cc = caller_depth()
        rb = no_rollback_depth - 2
        # DO NOT TOUCH ! Or replace with a less fragile mechanism
        # if cc+1<rb #jumped out OK:
        #   adjust_rollback cc
        #
        if cc < rb:  #and not cc+2<rb # not check_rollback_allowed:
            error("NO ROLLBACK, GIVING UP!!!")
            if verbose: print(last_token or string_pointer())  # ALWAYS!
            if angel.use_tree:
                import TreeBuilder
                TreeBuilder.show_tree()  #Not reached
            # bt = filter_stack()
            ex = GivingUp("Expecting #{m0} in #{m1} ... maybe related: #{attempt}\n#{last_token  or  string_pointer}")
            raise ex
            # error e #exit
            # raise SyntaxError(e)
    except EndOfDocument as e:
        invalidate_obsolete(old_nodes)
        the.string = old
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
        the.string = old
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
    the.string = old  #if rollback:
    nodes = old_nodes  # restore
    return False


def one_or_more(block):
    all = [block()]
    current_value = []
    return all + [star(block)].flatten()


def to_source(block):
    return str(block)

def many(block):
    global  old_tree,result
    while True:
        try:
            maybe(comment)
            old_tree = list(nodes)#.clone
            result = block() # yield
            # puts "------------------"
            #puts nodes-old_tree
            if(not the.string or len(the.string)==0 ):break  # TODO! loop criterion too week: break
            if not result or result == []:
                raise NotMatching(to_source(block) + "\n" + string_pointer_s())
        except IgnoreException as e:
            import traceback
            traceback.print_stack() # backtrace
            error(e)

# GETS FUCKED UP BY the.string.strip()! !!! ???
def pointer():
    global  parser
    if not lines or line_number >= len(lines): return Pointer(line_number, 0, parser)
    # line_number copy by ref?????????
    line = lines[line_number] + "$$$"
    offset = line.find(the.string + "$$$")  # len(original_string)-(the.string or "").length
    return Pointer(line_number, offset or 0,parser)


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
        last_result = the.result
    except IgnoreException as e:
        import traceback
        traceback.print_stack() # backtrace
        last_result = result = None
        e=filter_backtrace(e)
        error(e)

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

def token_new(t):
    if isinstance(t, list):
        return tokens(t)
    raiseEnd()
    if current_word==t:
        next_token()
        return current_word
    else:
        if throwing: verbose('expected ' + str(result))  #
        string_pointer()
        raise NotMatching(t)


def token(t):
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
        string_pointer()
        raise NotMatching(t)
        #todo: proper token stream, pre-lex'ed


def flatten(l):
  if callable(l):l=l()
  if isinstance(l,tuple):
      l=list(l)
  if not isinstance(l,list):
      l=l()
  from itertools import chain
  return list(chain.from_iterable(l))

def tokens(*tokenz):
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
    the.string = the.string + ' '  # todo: as regex?
    if isinstance(tokenz, str): tokenz = [tokenz]
    for t in tokenz:
        # RUBY BUG?? the.string.start_with?(r'#{t}[^\w]')
        if re.search(r'\w',t):
            if re.search(r'(?im)^%s[^\w]'%t,the.string): return t
        else:
            if the.string.startswith(t): return t  # escape_token []

    return False


def stripNewline():
    pass


def newline22():
    maybe(newline)


def raiseNewline():
    if not the.string: raise EndOfLine()


def checkNewline():
    global  line_number,original_string
    if the.string!="": comment()
    if not the.string or not the.string.strip():
        if line_number < len(lines): line_number = line_number + 1
        if line_number >= len(lines):
            original_string = ''
            the.string = ''  #done!
            return english_tokens.NEWLINE

        #if line_number==len(lines): raise EndOfDocument.new
        the.string = lines[line_number].strip()  #LOOSE INDENT HERE!!!
        the.string = re.sub(r'\/\/.*', "",the.string)  # todo : Grab comment()
        original_string = the.string or ''
        checkNewline()
        return english_tokens.NEWLINE


def newline():
    if checkNewline() == NEWLINE: return NEWLINE
    found = tokens(english_tokens.newline_tokens)
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
    current_value =re.search(r'(.*?)([\r\n;]|done)',the.string)[1].strip()
    the.string = the.string[len(current_value):-1]
    return current_value


# todo merge ^> :
def rest_of_line():
    if not re.search(r'(.*?)[;\n]',the.string):
        current_value = the.string
        the.string = None
        return current_value

    match = re.search(r'(.*?)([;\n].*)',the.string)  # Need to preserve ;\n Characters for 'end of statement'
    current_value = match.groups()[0]
    the.string = match.groups()[1]
    current_value = current_value.strip()
    return current_value


def comment_block():
    token('/*')
    while not re.search(r'\*\/',the.string):
        rest_of_line()
        newline22()  #_try(weg)
    the.string.gsub('.*?\*\/', '')
    #token '*/'
    # add_tree_node


def comment():
    if the.string == None: raiseEnd()
    # if current_type == _token.SLASH
    the.string = the.string.replace(r' -- .*', '')
    the.string = the.string.replace(r'\/\/.*', '')  # todo
    the.string = the.string.replace(r'#.*', '')
    if not the.string: checkNewline()
