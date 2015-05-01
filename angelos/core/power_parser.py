#!/usr/bin/env ruby
# encoding: utf-8
from lib2to3.btm_utils import tokens
from TreeBuilder import show_tree
from english_parser import result, maybe, comment, condition

import exceptions
import nodes
import angel
import IO
from exceptions import *
from const import *
from the import *
import the


def app_path():
    return "./"


def dictionary_path():
    app_path() + "word-lists/"


def isnumeric(start):
    return isinstance(start, int) or isinstance(start, float)  # or isinstance(start, long)


def star(block):
    # checkEnd
    if (the.nodes.count > max_depth):
        raise SystemStackError("if(nodes.count>max_depth)")

    was_throwing = the.throwing
    throwing = True
    old_state = the.current_value  # DANGER! must set current_value=None :{
    max = 20  # no list of >100 ints !?! WOW exclude lists!! TODO OOO!
    current = 0
    good = []
    # try:
    old_nodes = the.nodes.clone
    # entry_node_offset=nodes.count-1
    # if(entry_node_offset>48)
    # entry_node=last_node
    #
    oldString = the.string
    last_string = ""
    try:
        while True:
            if the.string == "" or the.string == last_string: break
            last_string = the.string
            match = yield  # <------!!!!!!!!!!!!!!!!!!!
            if not match: break
            oldString = the.string  # (partial)  success
            good.append(match)
            if current > max and the.throwing: raise " too many occurrences of " + to_source(block)

    except NotMatching as e:
        string = oldString  # partially reconstruct
        if very_verbose and not good:
            verbose
            "NotMatching star " + str(e)
            # if tokens and tokens.count>0: verbose "expected any of "+tokens.to_s
            if verbose: string_pointer

    except EndOfDocument as e:
        # raise e
        verbose("EndOfDocument")
        #break
        #return false
    except Exception as e:
        error(e)
        error("error in star " + to_source(block))
        # warn e

    if good.length == 1: return good[0]
    if not not good: return good
    # else: restore!
    the.throwing = was_throwing
    the.string = oldString
    for n in the.nodes - old_nodes:
        n.destroy()

    the.nodes = old_nodes
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
    if not the.string.match("\n"):
        the.string = ""
        return
    return string.replace(r'.*?\n', "\n")


def string_pointer_s():
    offset = original_string.length - string.length
    if offset < 0: offset = 0
    return original_string + "\n" + " " * (offset) + "^^^" + "\n"


def string_pointer():
    print(string_pointer_s())


def clean_backtrace(x):
    x = x.select(lambda x: not x.match(r'ruby')).join("\n")
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
        show_tree()
        if not angel.verbose: raise e  # SyntaxError(e):
        # exit


def warn(e):
    print(e.message)


def one(*matches):
    oldString = the.string
    for match in matches:
        try:
            string = oldString
            # if match and not isinstance(match, Symbol): return match
            # if isinstance(match, Symbol): result = send(match)
            return result  # if result:
        except NotMatching as e:
            verbose("NotMatching one " + str(match) + "(" + str(e) + ")")
            # raise GivingUp.new
            if not check_rollback_allowed: error
            return e
        except Exception as e:
            error(e)
            return e

    if check_rollback_allowed: string = oldString
    if the.throwing: verbose
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
#         if args.count == 0: x = maybe(send(cut)}
#         if args.count == 1: x = maybe(send(cut, args[0])}
#         if args.count > 1: x = maybe(send(cut, args)}
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
    calframe_ = calframe[1][3]
    print('caller name:', calframe_)
    return calframe_


def verbose(info):
    if angel.verbose: print(info)


def error(info):
    if angel.verbose: print(info)


def caller_depth():
    pass


def to_source(block):
    pass


def filter_backtrace(e):
    pass


def maybe_tokens(x):
    return tokens(x)


def __(x):
    return tokens(x)


# shortcut: method missing (and maybe(}?)
def maybe_tokens(*x):
    # DANGER!! Obviously very different semantics from maybe(tokens}!!
    # remove_tokens x # shortcut
    return maybe(tokens, x)


# class Parser(object):  # <MethodInterception:
# import
# attr_accessor :lines, :verbose, :original_string

# def __init__():

def init(strings):
    no_rollback_depth = -1
    line_number = 0
    if isinstance(strings, list): lines = strings
    if isinstance(strings, str): lines = strings.split("\n")
    string = lines[0].strip  # Postpone the problem
    original_string = string
    root = None
    nodes = []
    depth = 0
    lhs = rhs = comp = None
    # result           =None NOO, keep old!


def s(string):
    allow_rollback()
    init(string)
    # parser.init string


def assert_equals(a, b):
    if a != b: raise NotPassing("#{a} should equal #{b}")


def doassert(x=None, block=None):
    if not x and block: x = yield
    # if not x: raise Exception.new (to_source(block))
    if block and not x: raise NotPassing(to_source(block))
    if not x: raise NotPassing()
    if isinstance(x, str):
        try:
            #if string: root
            s(x)
            ok = condition()
        except SyntaxError as e:
            raise e  # ScriptError.new "NOT PASSING: SyntaxError : "+x+" \t("+e.class.to_s+") "+e.to_s
        except Exception as e:
            raise NotPassing("NOT PASSING: " + str(x) + " \t(" + str(type(e)) + ") " + str(e))

        if not ok:
            raise NotPassing("NOT PASSING: " + str(x))
        print(x)

    print("TEST PASSED! " + str(x) + " \t" + to_source(block).to_s)
    return True


def error_position():
    pass


def interpretation():
    interpretation.error_position = error_position()
    return interpretation


# gem 'debugger'
#gem 'ruby-debug19', :require => 'ruby-debug'
#import ruby-debug
#import debugger
#gem 'ParseTree' ruby 1.9 only :{
#import sourcify #http://stackoverflow.com/questions/5774916/print-the-actual-ruby-code-of-a-block BAD
#import method_source

#gem 'ruby-debug', :platforms => :ruby_18
#gem 'ruby-debug19', :platforms => :ruby_19, :require => 'ruby-debug'

#def maybe(block):
#  return yield except True
#
def raiseEnd():
    if not string:
        if line_number >= lines.count: raise EndOfDocument()
        #string=lines[++line_number];
        raise EndOfLine()


def checkEndOfLine():
    #if string.blank? # no:try,try,try  see raiseEnd: raise EndOfDocument.new
    return not string


def checkEndOfFile():
    return line_number >= lines.count and not string


def remove_tokens(*tokenz):
    for t in tokenz.flatten:
        string = string.replace(r' *%s *' % t, " ")


def must_contain(**args):
    if isinstance(args[-1], dict): before = args[-1]['before']
    if before: args = args[0:-2]
    before = before or []
    return must_contain_before(before, args)


def must_contain_before(before, *args):  #,before():None
    raiseEnd()
    good = False
    if before and isinstance(before, str): before = [before]
    if before: before = before.flatten() + [';']
    args = args.flatten()
    for x in args.flatten:
        if x.match(r'^\s*\w+\s*$'):
            good = good or (" #{string} ").match(r'[^\w]#{x}[^\w]')
            if good and before and before.matches(good.pre_match): good = None
        else:  # token
            good = good or string.index(x)
            if good and before and before.matches(string[0:good]): good = None

        if good: break

    if not good: raise (NotMatching(x))
    if str(good).contains(newline_tokens()): raise (NotMatching(x))  # ;while
    if good.pre_match.contains(newline_tokens()): raise (NotMatching(x))  #
    return OK


# NOT == starts_with !!!
def look_ahead(x):
    if string.index(x):
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
        if s.match("try"):
            return s


def caller_name():
    return caller()


# for i in 0..(caller.count):
#   if not caller[i].match(r'parser'): next
#   name=caller[i].match(r'`(.*)'')[1]
#   if caller[i].index("parser"): return name


def do_interpret11():
    interpret_border = -1
    did_interpret = the.interpret
    the.interpret = True


def dont_interpret11():
    if the.interpret_border < 0:
        the.interpret_border = caller_depth
        the.did_interpret = the.interpret
    the.interpret = False


def interpreting(n=0):
    if (the.interpret_border >= caller_depth() - n):
        the.interpret = the.did_interpret
        the.interpret_border = -1
    return the.interpret


def check_rollback_allowed():
    c = caller_depth
    throwing = True  #[]
    level = 0
    return c < no_rollback_depth or c > no_rollback_depth + 2


# if no result: same as try but throws


def any(block):
    raiseEnd()
    #if checkEnd: return
    last_try = 0
    #if level>20: throw "Max recursion reached #{to_source(block)}"
    if caller().count > 180: raise MaxRecursionReached(to_source(block))
    was_throwing = the.throwing
    throwing = False
    #throwing[level]=false
    oldString = the.string
    try:
        result = yield  # <--- !!!!!
        if not result:
            string = oldString
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
    except Exception as e:
        verbose("Error in #{to_source(block)}")
        error(e)

    if result: verbose("Succeeded with any #{to_source(block)}")
    if verbose and not result: string_pointer()
    last_token = string_pointer_s()  #if not last_token:
    if check_rollback_allowed(): string = oldString
    throwing = was_throwing
    #throwing[level]=True
    #level=level-1
    if result: return result
    raise NotMatching(to_source(block))
    #throw "Not matching #{to_source(block)}"


def to_source(x):
    if last_pattern or not x: return last_pattern
    #proc=block.to_source(:strip_enclosure => True) except "Sourcify::MultipleMatchingProcsPerLineError"
    res = x.source_location[0] + ":" + x.source_location[1].to_s + "\n"
    lines = IO.readlines(x.source_location[0])
    i = x.source_location[1] - 1
    while True:
        res += lines[i]
        if i >= lines.length or lines[i].match("}") or lines[i].match("end"): break
        i = i + 1
    return res


def caller_depth():
    # c= depth #if angel.use_tree doesn't speed up:
    # if angel.use_tree: c= depth
    c = caller.count
    if c > max_depth:
        raise SystemStackError("depth overflow")
    return c
    # filter_stack(caller).count #-1


def no_rollback11(n=0):
    depth = caller_depth - 1
    while (rollback_depths[-1] or -1) > depth:
        rollback_depths.pop()

    rollback_depths.push(the.no_rollback_depth)
    no_rollback_depth = depth
    # no_rollback_method=caller #_name


def allow_rollback(n=0):
    if n < 0: rollback_depths = []
    no_rollback_depth = rollback_depths.pop or -1
    original_string = string  #if following(no_rollback11):


def adjust_rollback(depth=caller_depth):
    if depth + 2 < the.no_rollback_depth:
        no_rollback_depth = rollback_depths.pop or -1


# todo ? trial and error -> evidence based 'parsing' ?
def maybe(block):
    #if checkEnd: return
    # allow_rollback 1
    depth = the.depth + 1
    if (caller_depth > max_depth):
        raise SystemStackError("if(nodes.count>max_depth)")

    old = the.string  # NOT overwritten, instead of:
    if not the.original_string: original_string = the.string or ""
    try:
        old_nodes = the.nodes.clone
        result = yield
        if result:
            adjust_rollback()
        else:
            #DANGER RETURNING false as VALUE!! use RAISE ONLY todo
            (the.nodes - old_nodes).each(lambda n: n.invalid())
            string = old

        last_node = the.current_node
        return result
    except (NotMatching, EndOfLine) as e:
        # old=original_string # REALLY>??
        verbose(e)
        current_value = None
        string = old
        interpreting()()
        if verbose: verbose("Tried #{to_source(block)}")
        if verbose: string_pointer()
        (the.nodes - old_nodes).each(lambda n: n.destroy())  #n.valid=false;
        #caller.index(last_try caller)]
        #puts rollback[caller.count]
        #puts caller.count
        #puts rollback
        cc = caller_depth()
        rb = no_rollback_depth - 2
        # DO NOT TOUCH ! Or replace with a less fragile mechanism
        # if cc+1<rb #jumped out OK:
        #   adjust_rollback cc
        #
        if cc < rb:  #and not cc+2<rb # not check_rollback_allowed:
            error("NO ROLLBACK, GIVING UP!!!")
            if verbose: print(the.last_token or string_pointer())  # ALWAYS!
            show_tree()  #Not reached
            attempt = str(e).gsub("[", "").gsub("]", "")
            from0 = 0  #e.backtrace.count-no_rollback_depth-2
            bt = e.backtrace
            bt = bt[from0:-1]  #if from>10:
            # bt = filter_stack()
            m0 = bt[0].match(r'`.*')  #except "XX"
            m1 = bt[1].match(r'`.*')  #except "YY"
            ex = GivingUp(
                "Expecting #{m0} in #{m1} ... maybe related: #{attempt}\n#{last_token  or  string_pointer}")
            ex.set_backtrace(bt)
            raise ex
            # error e #exit
            # raise SyntaxError(e)

    except EndOfDocument as e:
        (the.nodes - old_nodes).each(lambda n: n.destroy())
        string = old
        verbose("EndOfDocument")
        #raise e
        return False
        #return True
    except GivingUp as e:
        # string=old #to mark??
        # maybe => OK !?
        error(e)
        #if not check_rollback_allowed:
        #     if rollback[caller.count-1]!="NO" #:
    except Exception as e:  # NoMethodError etc
        string = old
        error(e)
        verbose(e)
    finally:
        adjust_rollback()
    depth = depth - 1
    string = old  #if rollback:
    nodes = old_nodes  # restore
    return False


def one_or_more(block):
    all = [block()]
    current_value = []
    all + [star(block)].flatten()


def to_source(block):
    pass


def many(block):
    while True:
        try:
            maybe(comment)
            old_tree = nodes.clone
            result = yield
            # puts "------------------"
            #puts nodes-old_tree
            if not string:  # TODO! loop criterion too week: break
                if not result or result == []:  #or string==""
                    raise NotMatching(to_source(block) + "\n" + string_pointer_s())
                    #exit
        except Exception as e:
            error(e)


# GETS FUCKED UP BY string.strip! !!! ???
def pointer():
    if not lines or line_number >= lines.size: return Pointer(line_number, 0, )
    # line_number copy by ref?????????
    line = lines[line_number] + "$$$"
    offset = line.offset(string + "$$$")  # original_string.length-(string or "").length
    Pointer(line_number, offset or 0, )


def isnumeric(start):
    isinstance(start)


def app_path():
    pass
    # File.expand_path(File.dirname(__FILE__)).to_s


def parse(string):
    if not string: return
    verbose
    "PARSING"
    try:
        allow_rollback()
        init(string)
        root()
        last_result = the.result
    except Exception as e:
        last_result = result = None
        filter_backtrace(e)
        error(e)

    verbose("PARSED SUCCESSFULLY!!")
    show_tree()
    # puts svg
    return interpretation  # # result

    # def start_parser:
    #   a=ARGV[0]  or  app_path+"/../examples/test.e"
    #   if (File.exists? a):
    #     lines=IO.readlines(a)
    #   else:
    #     lines=a.split("\n")
    #
    #   parse lines[0]


def newline_tokens():
    return ["\.\n", "\. ", "\n", "\r\n", ';']  # ,'\.\.\.' ,'end','done' NO!! OPTIONAL!
    # direct_token: WITH space!
    #todo: proper token stream, pre-lex'ed


def token(t):
    if isinstance(t, list): return tokens(t)
    # if checkEnd: return None
    # if t.is_a? Array #HOW TH ?? method_missing: t=t[0]
    string = the.string.strip()
    if string.startswith('/*'): comment_block()
    raiseEnd()
    if starts_with(t):
        current_value = t.strip
        string = string[t.length: - 1]
        if r'^\w '.match(string) and r'^\w '.match(t):
            raise NotMatching(t + " (strings needs whitespace, special chars don't)")
        else:
            the.string = string.strip()
            return current_value

    else:
        if the.throwing: verbose('expected ' + str(result))  #
        raise NotMatching(t)
        #todo: proper token stream, pre-lex'ed


def tokens(*tokenz):
    # encoding: utf-8
    raiseEnd()
    if the.string.startswith('/*'): comment_block()
    string = the.string.strip + ' '
    for t in tokenz.flatten:
        # if t.is_a Variable: next
        # if t=='' # todo debug HOW: next
        if (t == "\n" and not string): return True
        if t.match(r'^\w'):
            match = string.match(r'(?im)^\s*#{t}')
            if match and match.post_match.match(r'^\w'):
                continue  # next must be space or so!: next
        else:  # special char
            match = string.match(r'(?im)^\s*#{escape_token t}')

        if match:
            x = current_value = t
            string = match.post_match.strip
            string2 = string
            return x
    raise NotMatching(result)
    # if throwing:


def escape_token(t):
    return t.replace(r'([^\w])', "\\\\\\1")


def starts_with(tokenz):
    if checkEndOfLine(): return False
    string = the.string + ' '  # todo: as regex?
    if isinstance(tokenz, str): tokenz = [tokenz]
    for t in tokenz:
        # RUBY BUG?? string.start_with?(r'#{t}[^\w]')
        if t.match(r'\w'):
            if string.match(r'(?im)^#{t}[^\w]'): return t
        else:
            if string.startswith(t): return t  # escape_token []

    return False


class Pointer:
    # def parser():
    #     self.parser
    # attr_accessor(line_number,offset,parser)

    def __str__(self):
        print("<Pointer #{line_number} #{offset} '#{parser.lines[line_number][offset..-1]}'>")

    # def to_s:
    #   line_number.to_s+" "+offset.to_s #+" "+parser.lines[line_number][offset]
    #
    def __sub__(self, start):
        if isinstance(start, str): start = start.length
        if isnumeric(start):
            p = self.clone()
            p.offset -= start.length
            if p.offset < 0: p.offset = 0
            return p

        if start > self.content_between(): return
        start
        return self.content_between()
        start,

    def __gt__(self, x):
        return self.line_number >= x.line_number and self.offset > x.offset()


    def __init__(self, line_number, offset, parser):
        line_number = line_number
        self.parser = parser
        self.offset = offset
        if line_number >= parser.lines.count: offset = 0


    def content_between(start_pointer, end_pointer):
        line = start_pointer.line_number
        all = []
        if line >= lines.count: return all
        if line == end_pointer.line_number:
            return lines[line][start_pointer.offset:end_pointer.offset - 1]
        else:
            all.append(lines[line][start_pointer.offset: - 1])

        line = line + 1
        while line < end_pointer.line_number and line < lines.count():
            all.append(lines[line])
            line = line + 1

        chars = end_pointer.offset - 1
        if line < lines.count and chars > 0: all.append(lines[line][0..chars])
        all.map
        stripNewline()
        if all.length == 1: return all[0]
        return all

