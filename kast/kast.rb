# https://docs.python.org/release/2.7.2/library/ast.html#abstract-grammar
# https://docs.python.org/release/3.4.2/library/ast.html#abstract-grammar
# -- ASDL's six builtin types are identifier, int, string, bytes, object, >>> singleton <<< NEW

# require_relative '../extensions.rb'

module Kast

  class Node
    attr_accessor :lineno, :col_offset, :children

    def initialize(attributes={})
      attributes.each_pair { |name, value| instance_variable_set :"@#{name}", value }
      self.children=attributes
    end

    def evaluate(value)
      return nil if not value
      return value.eval if value.is_a? Node
      raise Exception("CANT eval "+x+" "+x.class)
    end

    def interpret
      return children
    end

    def walk(er)
      # yield
      er(self)
      for i in self.children
        next if not i
        i.walk if (i.is_a? Node)
      end
    end

    def dump level=0
      return if not self.children
      print "\t"*level+ self.class.to_s.sub("Kast::", '').sub(/Def$/, '')
      # print "("
      print(":\n")
      z=0
      for k, i in self.children
        next if not i or i.blank?
        if k.to_s=='body'
          level=level-1
        else
          print("\t"*level+" ")
          print(k)
          print("=")

          if i.is_a? String or i.is_a? Numeric
            print i
            print(",") if z>0
            z=z+1
          end
          print("\n")
        end
        next if not i
        i.dump level+1 if (i.is_a? Node)
        i.each do |x|
          x.dump(level+1)
        end if (i.is_a? Array)
        i.each do |x, y|
          if y.is_a?Node
            y.dump(level+1)
          else
            puts "\t"*(level+2)+"#{x}=#{y}"
          end
        end if (i.is_a? Hash)
      end
      return "" #ALREADY DUMPED!!
      # print "\t"*level+")"
      # print("\n")
    end

    def to_s
      type.name
      # dump
    end
  end


# DANGER: CONFLICT if Module not in module (Kast) lol!!
  class Module < Node
    attr_accessor :body

    def interpret
      # return body.map &:interpret
      return body.each { |statement| statement.interpret }
    end
  end

  def Module(body)
    m=Kast::Module.new(body: body)
    # assert(m.body==body)
    m
  end

  class Interactive < Node
    attr_accessor :body
  end

  def Interactive(body)
    Interactive.new({body: body})
  end

  class Expression < Node
    attr_accessor :body
  end

  def Expression(body)
    Expression.new({body: body})
  end


  class Suite < Node
    attr_accessor :body
  end

  def Suite(body)
    Suite.new({body: body})
  end

  class Python3Node < Node
  end

# see class Function !!
  class FunctionDef < Node
    attr_accessor :name, :args, :body, :decorator_list, :returns

    def eval
      define_method(name) do
        super.evaluate(value)
      end
    end
  end

# def FunctionDef(name, args, body=Python3Node, decorator_list, returns)
#   FunctionDef.new({name: name, args: args, body: body, decorator_list: decorator_list, returns: returns})
# end

  def FunctionDef(params={})
    FunctionDef.new(params)
  end

  alias MethodDef FunctionDef
  alias DefDef FunctionDef

  class ClassDef < Node
    attr_accessor :name, :bases, :keywords, :starargs, :kwargs, :body, :decorator_list

    def eval
      # define_class
    end
  end

# def ClassDef(name, bases, keywords=[], starargs=[], kwargs=[], body, decorator_list)
#   ClassDef.new({name: name, bases: bases, keywords: keywords, starargs: starargs, kwargs: kwargs, body: body, decorator_list: decorator_list})
# end
  def ClassDef(params={})
    ClassDef.new(params)
  end

  class Return < Node
    attr_accessor :value

    def eval
      super.evaluate(value)
    end
  end

# def Return(value=nil)
#   Return.new(value: value)
# end

  def Return(params={})
    Return.new(params)
  end


  class Delete < Node
    attr_accessor :targets
  end

  def Delete(targets)
    Delete.new(targets)
  end

  class Assign < Node
    attr_accessor :targets, :value
    alias var targets
    alias vars targets
    alias body value
  end

  # def Assign(targets, value)
  #   Assign.new({targets: targets, value: value})
  # end
  def Assign(params={})
    Assign.new(params)
  end

  # x += 8
  # x *= 8
  class AugAssign < Node
    attr_accessor :targets, :op, :value
  end

  def AugAssign(targets, op, value)
    AugAssign.new({targets: targets, op: op, value: value})
  end

  class While < Node
    attr_accessor :test, :body, :orelse
  end

  def While(test, body, orelse)
    While.new({test: test, body: body, orelse: orelse})
  end

  class If < Node
    attr_accessor :test, :body, :orelse
    alias condition test
    alias then body
    alias else body #DANGER!!
  end

# def If(test, body, orelse)
#   If.new({test: test, body: body, orelse: orelse})
# end
  def If(params={})
    params[:orelse]||=params[:else] # DANGER KEYWORD!
    If.new(params)
  end

  class For < Node
    attr_accessor :target, :iter, :body, :orelse
  end

  def For(target, iter, body, orelse)
    For.new({target: target, iter: iter, body: body, orelse: orelse})
  end


  class With
    attr_accessor :items, :body
  end

  def With(items, body)
    With.new({items: items, body: body})
  end


  class Raise < Node
    attr_accessor :exc, :cause
  end

  def Raise(exc=nil, cause=nil)
    Raise.new({exc: exc, cause: cause})
  end

  class Try < Node
    attr_accessor :body, :handlers, :orelse, :finalbody
  end

  def Try(body, handlers, orelse, finalbody)
    Try.new({body: body, handlers: handlers, orelse: orelse, finalbody: finalbody})
  end

  class Assert < Node
  end

  def Assert(test, msg='')
    Assert.new({test: test, msg: msg})
  end


  class Import < Node
    attr_accessor :names

    def interpret
      return body.map &:interpret
    end
  end

  def Import(names)
    Import.new({names: names}) #.names=names
  end

  class ImportFrom < Node
  end

  def ImportFrom(module_=nil, names=nil, level=0)
    ImportFrom.new({module_: module_, names: names, level: level})
  end

  class None<NilClass;
  end
  class True<TrueClass;
  end
  class False<FalseClass;
  end
# True =true
# None =nil
# False=false
# False=FalseClass

  class Global < Node
    attr_accessor :names
  end

  def Global(names)
    Global.new({names: names}) #.names=names
  end

  class Nonlocal < Node
    attr_accessor :names
  end

  def Nonlocal(names)
    Nonlocal.new({names: names}) #.names=names
  end


  class Expr < Node
    attr_accessor :value
  end

  def Expr(value)
    Expr.new({value: value})
  end

  class Pass<Node
  end

  def Pass
    Pass.new
  end

  class Break<Node
  end

  def Break
    Break.new
  end

  class Continue<Node
  end

  def Continue
    Continue.new
  end


  class BoolOp < Node
    attr_accessor :op, :values
  end

  def BoolOp(op, values)
    BoolOp.new({op: op, values: values})
  end

  class BinOp < Node
    attr_accessor :left, :op, :right

    def interpret
      left.interpret.send(op.to_s, right.interpret)
    end
  end

  def BinOp(left, op, right)
    BinOp.new({left: left, op: op, right: right})
  end

  class UnaryOp < Node
    attr_accessor :op, :operand
  end

  def UnaryOp(op, operand)
    UnaryOp.new({op: op, values: operand})
  end

  class Lambda < Node
    attr_accessor :args, :body
  end

  def Lambda(args, body)
    Lambda.new({args: args, body: body})
  end

# != IF !!!
  class IfExp < Node
    attr_accessor :test, :body, :orelse
  end

  def IfExp(test, body, orelse)
    IfExp.new({test: test, body: body, orelse: orelse})
  end


  class Dict < Node
    attr_accessor :keys, :values
  end

  def Dict(keys, values)
    Dict.new({keys: keys, values: values})
  end


# DANGER: CONFLICT if Set not in module (Kast)
  class Set < Node # NOT ASSIGN!!!!!!!!!!
    attr_accessor :elts

    def initialize(elts)
      self.elts=elts
    end
  end

  def Set(elts)
    # Set.new({elts:elts})
    Set.new(elts)
  end

  alias Let Set

  class SetComp < Node
    attr_accessor :elt, :generators
  end

  def SetComp(elt, generators)
    SetComp.new({elt: elt, generators: generators})
  end

  class ListComp < Node
    attr_accessor :elt, :generators
  end

  def ListComp(elt, generators)
    ListComp.new({elt: elt, generators: generators})
  end

  class DictComp < Node
    attr_accessor :keys, :values, :generators
  end

  def DictComp(keys, values, generators)
    DictComp.new({keys: keys, values: values, generators: generators})
  end

  class GeneratorExp < Node
    attr_accessor :elt, :generators
  end

  def GeneratorExp(elt, generators)
    GeneratorExp.new({elt: elt, generators: generators})
  end


  class Yield < Node
    attr_accessor :value
  end

  def Yield(value=nil)
    Yield.new(value)
  end

  class YieldFrom< Node
    attr_accessor :value
  end

  def YieldFrom(value)
    YieldFrom.new(value)
  end

  class Compare< Node
    attr_accessor :left, :ops, :comparators
  end

  def Compare(left, ops, comparators)
    Compare.new({left: left, ops: ops, comparators: comparators})
  end


  class Call < Node
    attr_accessor :func, :args, :keywords, :starargs, :kwargs
    alias method func
    alias function func
    alias arg args
    alias arguments args
    alias argument args

  end
# def Call(func, args, keywords, starargs=[], kwargs=[], body, decorator_list)
#   Call.new({func: func, args: args, keywords: keywords, starargs: starargs, kwargs: kwargs})
# end

  def Call(params={})
    # params[:keywords]||=[]
    Call.new(params)
  end

  alias Construct Call
# alias Constructor Call


  class Num < Node
    attr_accessor :n

    def interpret
      n.to_i # or to_f ??
    end
  end

  def Num(n)
    Num.new(n: n)
  end

  class Str < Node
    attr_accessor :s

    def interpret
      s
    end
  end

  def Str(s)
    Str.new(s: s)
  end

  class Bytes < Node
    attr_accessor :s
  end

  def Bytes(s)
    Bytes.new(s: s)
  end

  class NameConstant< Node
    attr_accessor :value
  end

  def NameConstant(value)
    NameConstant.new({value: value})
  end

  class Ellipsis < Node
  end

  def Bytes()
    Bytes.new()
  end


  class Attribute< Node
    attr_accessor :value, :attr, :expr_context
  end

  def Attribute(value, attr, expr_context)
    Attribute.new({value: value, attr: attr, expr_context: expr_context})
  end

  class Subscript< Node
    attr_accessor :value, :slice, :ctx
  end

  def Subscript(value, slice, ctx)
    Subscript.new({value: value, slice: slice, ctx: ctx})
  end

  class Starred< Node
    attr_accessor :value, :ctx
  end

  def Starred(value, ctx)
    Starred.new({value: value, ctx: ctx})
  end

  class Name< Node
    attr_accessor :id, :ctx
  end

  def Name(id, ctx)
    Name.new({id: id, ctx: ctx})
  end


  class List< Node
    attr_accessor :elts, :ctx
  end

  def List(elts, ctx)
    List.new({elts: elts, ctx: ctx})
  end

  class Tuple< Node
    attr_accessor :elts, :ctx
  end

  def Tuple(elts, ctx)
    Tuple.new({elts: elts, ctx: ctx})
  end

# class None< NilClass;
# end

  class ExceptionContext <Node;
  end
  class Load < ExceptionContext;
  end
  class Store < ExceptionContext;
  end
  class Del < ExceptionContext;
  end
  class AugLoad < ExceptionContext;
  end
  class AugStore < ExceptionContext;
  end
  class Param < ExceptionContext;
  end

  def Load()
    ; Load.new
  end

  def Store()
    ; Store.new
  end

  def Del()
    ; Del.new
  end

  def AugLoad()
    ; AugLoad.new
  end

  def AugStore()
    ; AugStore.new
  end

  def Param()
    ; Param.new
  end


# alias = (identifier name, identifier? asname)
  class Alias < Node
    attr_accessor :names, :asname
  end

  def Alias(name, asname=nil)
    Alias.new({name: name, asname: asname}) #.names=names
  end

  class Index< Node
    attr_accessor :value
  end
#           Index(expr value)
  def Index(value)
    Index.new(value: value)
  end


  class Slice< Node
    attr_accessor :lower, :upper, :step
  end

  def Slice(lower, upper, step)
    Slice.new(lower: lower, upper: upper, step: step)
  end

  class ExtSlice< Node
    attr_accessor :dims
  end

  def ExtSlice(dims)
    ExtSlice.new({dims: dims})
  end

  class And< BoolOp;
  end
  class Or< BoolOp;
  end

  def And;
    And.new
  end

  def Or;
    Or.new
  end

  class Operator <Node
  end
  class Add < Operator
    def to_s
      '+'
    end
  end
  class Sub < Operator
    def to_s
      '-'
    end
  end
  class Mult < Operator
    def to_s
      '*'
    end
  end
  class Div < Operator
  end
  class Mod < Operator
  end
  class Pow < Operator
  end
  class LShift < Operator
  end
  class RShift < Operator
  end
  class BitOr < Operator
  end
  class BitXor < Operator
  end
  class BitAnd < Operator
  end
  class FloorDiv < Operator
  end

  def Add;
    Add.new
  end

  def Sub;
    Sub.new
  end

  def Mult;
    Mult.new
  end

  def Div;
    Div.new
  end

  def Mod;
    Mod.new
  end

  def Pow;
    Pow.new
  end

  def LShift;
    LShift.new
  end

  def RShift;
    RShift.new
  end

  def BitOr;
    BitOr.new
  end

  def BitXor;
    BitXor.new
  end

  def BitAnd;
    BitAnd.new
  end

  def FloorDiv;
    FloorDiv.new
  end

  class Invert < UnaryOp;
  end
  class Not < UnaryOp;
  end
  class UAdd < UnaryOp;
  end
  class USub < UnaryOp;
  end

  class ComparatorOp < Node;
  end
  class Eq < ComparatorOp;
  end
  class NotEq < ComparatorOp;
  end
  class LtE < ComparatorOp;
  end
  class GtE < ComparatorOp;
  end
  class Is < ComparatorOp;
  end
  class IsNot < ComparatorOp;
  end
  class In < ComparatorOp;
  end
  class NotIn < ComparatorOp;
  end

  def Eq;
    Eq.new
  end

  def NotEq;
    NotEq.new
  end

  def LtE;
    LtE.new
  end

  def GtE;
    GtE.new
  end

  def Is;
    Is.new
  end

  def IsNot;
    IsNot.new
  end

  def In;
    In.new
  end

  def NotIn;
    NotIn.new
  end

# comprehension = (expr target, expr iter, expr* ifs)


  class ExceptHandler < Node
    attr_accessor :type, :name, :body
  end

  def ExceptHandler(type, name, body)
    ExceptHandler.new({type: type, name: name, body: body})
  end

# attributes (int lineno, int col_offset)

  class Arguments < Node
    attr_accessor :args, :vararg, :kwonlyargs, :kw_defaults, :kwarg, :defaults
  end

  def arguments (args, vararg=nil, kwonlyargs=[], kw_defaults=[], kwarg=nil, defaults=nil)
    Arguments.new(args: args, vararg: vararg, kwonlyargs: kwonlyargs, kw_defaults: kw_defaults, kwarg: kwarg, defaults: defaults)
  end

# arguments = (arg* args, arg? vararg, arg* kwonlyargs, expr* kw_defaults,  arg? kwarg, expr* defaults)

# arg = (identifier arg, expr? annotation)
  class Arg< Node
    attr_accessor :arg, :annotation
  end

  def arg(arg, annotation)
    Arg.new(arg: arg, annotation: annotation)
  end


# -- import name with optional 'as' alias.
# alias = (identifier name, identifier? asname)

# -- keyword arguments supplied to call
  class Withitem< Node
    attr_accessor :context_expr, :optional_vars
  end

  def withitem(context_expr, optional_vars)
    Withitem.new({context_expr: context_expr, value: optional_vars})
  end


# -- keyword arguments supplied to call
  class Keyword < Node
    attr_accessor :arg, :value
  end

  def keyword(arg, value)
    Keyword.new({arg: arg, value: value})
  end


# self.value=Call(func=Name(id='print',ctx=Load()), args=values,keywords=[], starargs=None, kwargs=None)
  class Print < Node
    attr_accessor :dest, :values, :nl

    def interpret
      puts(values.interpret)
      # print(values.interpret)
    end
  end

  def Print dest=nil, values=nil, nl=True
    Print.new dest: dest, values: values, nl: nl
  end

  class Condition<Expression
  end

  def Condition(body)
    Condition.new({body: body})
  end

  class Value<Expression
  end

  def Value(body)
    Value.new({body: body})
  end


end
