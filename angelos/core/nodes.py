# import core.the
# from import *
# import the
from the import *

class Condition(object):
  def __init__(self, **kwargs): #ruby : initialize
    self.lhs = kwargs['lhs']
    self.comp= kwargs['comp']
    self.rhs = kwargs['rhs']

class Quote(str):
  def is_a(className):
    # if isinstance(className,type): isinstance(return,className)
    if isinstance(className,str): className=className.lower()
    if className=="quote": return True
    return className=="string"

  def isa(self, x):
    if str(x).lower()=="string": return True
    if str(x).lower()=="quote": return True
    False

  # todont!!
  def __eq__(self, x):
    # if x.name==String: True
    if str(x)=="String": return True
    if str(x)=="Quote": return True
    return False

  def value(self):
    return self.quoted()

class Function:
  #attr_accessor :name, :arguments, :return_type, :scope, :module, :clazz, :object, :body

  def __init__(self, **args):
    self.name     =args['name']
    self.body     =args['body']
    self.scope    =args['scope']
    self.clazz    =args['clazz'] or type(object)
    self.clazz   =args['module']
    self.object   =args['object']
    self.arguments=args['arguments'] or []

    # integrate a function between x and y => object = a function (class)
    # if(self.arguments.count>0 and not self.object)
    #   if(arguments[0].preposition.empty?)
    #     self.object=arguments[0]
    #     arguments.shift
    #   
    # 
    # scope.variables[name]=self

  def argc(self):
    self.arguments.count

  def __eq__(self, x):
    if not isinstance(x,Function): return False
    return self.name==x.name  and\
        self.scope==x.scope  and\
        self.clazz==x.clazz  and\
        self.object==x.object  and\
        self.arguments==x.arguments

  # def call(*args):
    # self.parser. self.context.
    #    EnglishParser.call_function self,args

class FunctionCall:

  #attr_accessor :name, :arguments, :scope, :module, :class, :object

  def __init__(self, **args):
    self.name     =args['name']
    self.scope    =args['scope']
    self.clazz    =args['class']
    self.clazz   =args['module']
    self.object   =args['object']
    self.arguments=args['arguments']


class Argument:
  #attr_accessor :name, :type, :position, :default, :preposition, :value

  def __init__(self, **args):
    self.name       =args['name']
    self.preposition=args['preposition']
    self.type       =args['type']
    self.position   =args['position']
    self.default    =args['default']
    self.value      =args['value']
    # scope.variables[name]=self

  def __eq__(self,x):
     return self.name == x.name  and\
        self.preposition== x.preposition  and\
        self.type == x.type  and\
        self.position == x.position  and\
        self.default == x.default  and\
        self.value == x.value

  def name_or_value(self):
    self.value or self.name

  # str(def)ym(self):
  #   str(self.name)ym


class Variable:
  # attr_accessor :name, :type,:owner, :value, :final, :modifier     # :scope, :module, << owner

  def __init__(self,**args):
    self.name    =args['name']
    self.type    =args['type']
    self.owner    =args['owner']
    self.scope   =args['scope']
    # self.class  =args[:module]
    self.final   =args['final']
    self.value   =args['value']
    self.modifier=args['modifier']
    # scope.variables[name]=self

  def c(self): #unwrap, for optimization):
    # if type==Numeric: return "NUM2INT(#{name})"
    # if type==Fixnum: return "NUM2INT(#{name})"
    return self.name

  def wrap(self):
    return self.name

  # str(def)(self):
  #    "Variable #{type} #{name}=#{value}"

  def increase(self):
    self.value = self.value+1
    self.value

  def __eq__(self, x):
    if not isinstance(x,Variable): return self.value == x
    super == x
    # self.name == x.name &&
    #     self.preposition== x.preposition &&
    #     self.type == x.type &&
    #     self.position == x.position &&
    #     self.default == x.default &&
    #     self.value == x.value

class Property(Variable):
    pass
  # attr_accessor :name, :owner


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
        if isinstance(start,int):
            p = self.clone()
            p.offset -= start.length
            if p.offset < 0: p.offset = 0
            return p

        if start > self.content_between(self,start):
            return start
        return self.content_between(start,self)


    def __gt__(self, x):
        if(isinstance(x,list)):return True
        return self.line_number >= x.line_number and self.offset > x.offset()


    def __init__(self, line_number, offset, parser):
        self.line_number = line_number
        self.parser = parser
        self.offset = offset
        if line_number >= len(parser['lines']): offset = 0
        # if line_number >= len(parser.lines): offset = 0


    def content_between(self,start_pointer, end_pointer):
        line = start_pointer.line_number
        all = []
        if len(lines)==0: return all #WTF!!
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
        # stripNewline()
        if all.length == 1: return all[0]
        return all

