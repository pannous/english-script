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

  def show_node(self):
    # self.value or not self.nodes.empty?
    if node.valid: self.valid and (self.value or not not self.nodes) #

  def find(x):
    return self.nodes[x] if(isinstance(x,Numeric))
    for n in self.nodes:
      if( n.name==x or n.str(name)==str(x))
        if n.value:
          return n.value

        if n.content:
          return n.content

        return n

      ok=n.find x
      if ok: return ok

    # puts "WARN: No such property #{x} in #{self}"
    # raise Exception.new "No such property #{x} in #{self}"
    False

  def all(x):
    all=[]
    for n in self.nodes:
      if (x=="*" or  n.name==x or n.str(name)==str(x)):
        if n.value:
          all.append(n.value)

        all.append( n.all("*"))

      if x!="*": all+=n.all(x)

    all

  def [] x(self):
    find x

  not def(self):
    not show_node

  def is_leaf(self):
    not nodes

  def good_value(self):
    # if self.nodes.count==1: return self.nodes[0].good_value
    if not not self.nodes: return str(self.name)
    return str(self.name) + ":" + str(self.value)

  def full_value(self):
    if value:
      if self.variableValues and (self.variableValues[value]):
        return self.variableValues[value]
      else:
        if isinstance(value,Quote): return "'#{value}'"
        return value

    elsif self.nodes.count>0:
      return self.nodes.map(&:full_value).join(" ")
    else:
      return ""


  def value_string(self):
    if self.nodes.count==0:
      if value and valid #OR NAME ??? !!! CONFUSION!!!: return value.to_s
      return None #no value!!

    r="" # argument hack
    for n in nodes:
      if n.is_leaf and n.value and n.valid: r=n.str(value)+" "+r

    r.strip!
    return r
    #x=x.full_value.flip  # argument hack NEEE color= green  color of the sun => sun.green --

  #BAD method
  def eval_node(variables, fallback):
    self.variableValues or =variables #woot?
    whot           =full_value
    try:
      whot.gsub!("\\", "") # where from?? token?
      res=eval(whot) except fallback ## v0.0
      return res
    except SyntaxError as se:
      return fallback


  str(def)(self):
    good_value

  def destroy(self):
    self.valid=False
    if self.parent: self.parent.nodes.delete(self)

  def __init__(args={}):
    self.parent=None  or  args['parent']
    if self.parent: self.parent.nodes.append(self)
    self.nodes=[]
    self.valid=False
    self.value=None  or  args['value']
    self.name =None  or  args['name']

