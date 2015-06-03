import ast
import re
import nodes


class TreeNode:

  #attr_accessor :name
  #attr_accessor :content
  #attr_accessor :value
  #attr_accessor :parent
  #attr_accessor :nodes
  #attr_accessor :valid
  #attr_accessor :startPointer
  #attr_accessor :endPointer
  # self.variableValues
  #attr_accessor :start_line
  #attr_accessor :end_line
  #attr_accessor :start_offset
  #attr_accessor :end_offset
  def __init__(self):
    self.name
    self.content
    self.value
    self.parent
    self.nodes
    self.valid
    self.startPointer
    self.endPointer
    self.alues
    self.start_line
    self.end_line
    self.start_offset
    self.end_offset

  def __init__(self,args={}):
    self.parent=None  or  args['parent']
    if self.parent: self.parent.nodes.append(self)
    self.nodes=[]
    self.valid=False
    self.value=None  or  args['value']
    self.name =None  or  args['name']



  def show_node(self):
    # self.value or not self.nodes.empty?
    if self.node.valid: self.valid and (self.value or not not self.nodes) #

  def find(self,x):
    if(x.isdigit()):return self.nodes[x]
    for n in self.nodes:
      if( n.name==x or n.str(self.name)==str(x)):
        if n.value:
          return n.value

        if n.content:
          return n.content

        return n

      ok=n.find(x)
      if ok: return ok

    # puts "WARN: No such property #{x} in #{self}"
    # raise Exception.new "No such property #{x} in #{self}"
    False

  def all(self,x):
    all=[]
    for n in self.nodes:
      if (x=="*" or  n.name==x or n.str(self.name)==str(x)):
        if n.value:
          all.append(n.value)

        all.append( n.all("*"))

      if x!="*": all+=n.all(x)

    all

  def __index__(self,x):
    return self.find(x)

  def blank(self):
    return not self.show_node()

  def is_leaf(self):
    return not self.nodes

  def good_value(self):
    # if self.nodes.count==1: return self.nodes[0].good_value
    if not not self.nodes: return str(self.name)
    return str(self.name) + ":" + str(self.value)

  def full_value(self):
    if self.value:
      if self.variableValues and (self.variableValues[self.value]):
        return self.variableValues[self.value]
      else:
        if isinstance(self.value, nodes.Quote): return "'#{value}'"
        return self.value

    elif self.nodes.count>0:
      return self.nodes.map(self.full_value).join(" ")
    else:
      return ""


  def value_string(self):
    if self.nodes.count==0:
      if self.value and self.valid : return self.value.to_s
      #OR NAME ??? !!! CONFUSION!!!
      return None #no value!!

    r="" # argument hack
    for n in nodes:
      if n.is_leaf and n.value and n.valid: r=n.str(self.value)+" "+r

    return r.strip()
    #x=x.full_value.flip  # argument hack NEEE color= green  color of the sun => sun.green --

  #BAD method
  def eval_node(self, variables, fallback):
    # self.variableValues  =variables #woot?
    whot           =self.full_value()
    try:
      whot=re.gsub("\\", "",whot) # where from?? token?
      res=eval(whot)# except fallback ## v0.0
      return res
    except SyntaxError as se:
      return fallback


  def __str__(self):
    self.good_value()

  def destroy(self):
    self.valid=False
    if self.parent: self.parent.nodes.delete(self)


def operator_equals(mod):
  op = ast.Add()
  if mod == '|=': op=ast.Or()
  if mod == '||=':op=ast.Or()
  if mod == '&=': op=ast.And()
  if mod == '&&=':op=ast.And()
  if mod == '+=': op=ast.Add()
  if mod == '-=': op=ast.Sub()
  if mod == '*=': op=ast.Mult()
  if mod == '**=':op=ast.Pow()
  if mod == '/=': op=ast.Div()
  if mod == '//=': op=ast.FloorDiv()
  if mod == '%=': op=ast.Mod()
  if mod == '^=': op=ast.BitXor()
  if mod == '<<': op=ast.LShift()
  if mod == '>>': op=ast.RShift()
  return op

def operator(mod):
  op = ast.Add()
  if mod == 'or': op=ast.Or()
  if mod == '|': op=ast.Or()
  if mod == '||':op=ast.Or()
  if mod == 'and': op=ast.And()
  if mod == '&': op=ast.And()
  if mod == '&&':op=ast.And()
  if mod == 'plus': op=ast.Add()
  if mod == '+': op=ast.Add()
  if mod == '-': op=ast.Sub()
  if mod == 'minus': op=ast.Sub()
  if mod == 'times': op=ast.Mult()
  if mod == '*': op=ast.Mult()
  if mod == '**':op=ast.Pow()
  if mod == 'divide': op=ast.Div()
  if mod == 'divided': op=ast.Div()
  if mod == 'divided by': op=ast.Div()
  if mod == '/': op=ast.Div()
  if mod == '//': op=ast.FloorDiv()
  if mod == 'floor div': op=ast.FloorDiv()
  if mod == '%': op=ast.Mod()
  if mod == 'mod': op=ast.Mod()
  if mod == 'modulus': op=ast.Mod()
  if mod == 'modulo': op=ast.Mod()
  if mod == '^': op=ast.BitXor()
  if mod == 'xor': op=ast.BitXor()
  if mod == '<<': op=ast.LShift()
  if mod == '>>': op=ast.RShift()
  return op