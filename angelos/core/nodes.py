
class Quote(str):
  def is_a(className):
    if isinstance(className,Class): isinstance(return,className)
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

  def == x(self):
    if not isinstance(x,Function): return False
    self.name==x.name  and
        self.scope==x.scope  and
        self.clazz==x.clazz  and
        self.object==x.object  and
        self.arguments==x.arguments

  def call(*args):
    # self.parser. self.context.
       EnglishParser.call_function self,args

class FunctionCall:

  #attr_accessor :name, :arguments, :scope, :module, :class, :object

  def __init__(self, **args):
    self.name     =args['name']
    self.scope    =args['scope']
    self.clazz    =args['class']:
    self.clazz   =args['module']:
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
