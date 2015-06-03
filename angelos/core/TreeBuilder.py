#require File.expand_path(File.dirname(__FILE__) + '/../node.rb')
import tree
import extensions
import angle

class MethodInterception:
  #   def __init__(self):
  #       ["bla", "newlines"]
  # # "subnode",


  def __init__(self):
    super # needs to be called by hand!
    #self.tree=[]
    self.nodes        =[]
    self.tokens       =[]
    self.new_nodes    =[] #  remove after try failed
    self.current_node =None
    self.last_node    =None
    self.root         =None
    self.current_value=""

  def ignore_parent(self):
    ["rest_of_line"]
    # "number",
    # ["integer","real"]#,"expression0"]
    # [    "endNode","integer","real","expression0","value","word"]

  # what exactly machen die??  Eigentlich sollen Sie den Wert an den parent weiterleiten aber das klappt nicht
  def keepers(self):#== ignore_parent , ,"rest_of_line"
    ["token", "number", "tokens", "word", "setter", "variable", "value", "method_call", "object",
     "subnode", "integer", "number_word"]
    #             "number_word","integer",
    #   ,"ruby_method_call"
    #   ,"quote"

  def dont_add_node(self):
    return ["integer"]

  # includes rather than ignore???? or EXPLICIT node construction!!!
  def ignore(self):
    #"newline","newlines","newline22",
    #test_setter Should never be set ("")!?
    #"token","tokens","number",
    # "setter",  "endNode",
    # "rest_of_line","word",
    ignore_parent+#delete+
        ["_", "_22", "interpretation","must_not_match","system_verbs","starts_with","bla", "should_not_match", "do_send",
         "pronouns","is_object_method", "method_tokens",
         "end_expression", "end_of_statement","end_block", "done",
         "do_evaluate", "other_verbs",
         "numbers", "tokens", "current_context", "type_names", "possessive_pronouns",
         "ignore", "initialize", "endNode", "start_block", "OK",
         "bad", "wordnet_is_noun", "true_comparitons", "special_verbs", "wordnet_is_verb",
         "checkNewline", "newline", "wordnet_is_adjective",
         "newline22", "ruby_block_test", "subnode_token", "get_adjective", "get_noun", "get_verb",
         "substitute_variables", "raiseNewline", "any", "initialize", "one_or_more", "expression",
         "the_noun_that", "nod", "star", "action", "parse",
         "allow_rollback", "init", "type_keywords", "articles", "modifiers", "auxiliary_verbs",
         "test_setter", "try_action", "method_missing", "endNode2", "no_rollback11", "raiseEnd",
         "string_pointer", "verbose", "try", "checkEnd", "to_source", "rest", "keywords",
         "starts_with?", "be_words", "no_keyword", "no_keyword_except", "prepositions", "variables_list", "the?",
         "app_path", "escape_token", "operators", "newline_tokens",
         "constants", "comment", "any_ruby_line", "quantifiers", "article"] #"call_is_verb",

  def interpretation(self):
    i      = self.interpretation #  Interpretation.new
    #i.tree=
    i.root =self.root
    i.nodes=self.nodes
    i.tree =self.root #filter_tree(self.root)
    i

  # operator:algebra BUG!?!

  def current_value(x):
    self.current_value=x

  #todo: move to interpretation or tree.full
  def full_tree(node=self.root, tabs=0):
    if not node: return
    if not False==node.value: print " "*tabs + "#{node.name} #{node.value}"
    for n in node.nodes:
      full_tree n, (tabs+1)


  def walk_tree(node, tabs=0):
    if node.show_node: #if node.valid: puts " "*tabs + node.good_value
    for n in node.nodes:
      #if not n.valid: next
      walk_tree n, (tabs+1)

    #if node.nodes.empty? and not node.valid: node.destroy

  def good_node_values(node):
    result=""
    if node.show_node and node.value: result=node.value
    for n in node.nodes:
      result+=good_node_values n

    result

  def flat_tree(node):
    if node.show_node and node.value:
      print node.good_value+" "

    for n in node.nodes:
      flat_tree(n)

    if node.name=="statement" or node.name==angle.statement: print ""

  def flat_tree2(node, collect=[]):
    if node.show_node and node.value:
      print node.good_value
      collect.append(node)

    for n in node.nodes:
      collect.append( flat_tree(n))

    collect

  #todo: move to interpretation or tree.show
  def show_tree(self):
    if not self.root or not angle.use_tree: return
    walk_tree self.root
    print "---------"
    flat_tree self.root

  def bad(name):
    if not angle.use_tree: return True
    if str(name).endswith("_words"): return True
    #if name.to_s.start_with? "test_" # NEEDED for algebra.parent todo!: return True
    #if name.to_s.endswith("?") or bad_name=True:
    ignore.index str(name) # 0 == True ! OK

  def parent_node(self):
    if not angle.use_tree # self.nodes.count==0: return self.original_string-self.string
    for i in 0..(caller.count):
      if not caller[i].match(r'parser'): next
      name=caller[i].match(r'`(.*)'')[1]
      for j in 1..(self.nodes.count):
        node     =self.nodes[-j]
        node_name=node.str(name)
        if (node_name==name):
          return node



    return None

  def before_each_method(name):
    if not bad(name):
      if not keepers.index str(name): self.current_value            =None #
      #parent=self.current_node
      self.current_node             =TreeNode(parent: parent_node, name: name)
      self.current_node.startPointer=pointer
      if self.nodes.count==0: self.root                     =self.current_node
      self.nodes.append(self.current_node #OPTIMISTIC!! not after? noo, then it's a mess! delete in try/star/...)

    #not bad name and
    #if  not keepers.index name.to_s: self.current_value=""
    #p [:before_method, name]

  # not called on error, good. cleanup self.nodes in try/star/...
  def after_each_method(name):
    if not self.current_node #HOOOW?: return
    # if name!="boolean" and not self.current_value: return
    if not bad name:
      if not self.nodes[-1].name==name# keep through parent: self.nodes.pop
      self.current_node=self.nodes[-1]
      if self.current_node:
        content=pointer-self.current_node.startPointer
        if self.current_node.is_leaf: self.current_node.value     =self.current_value # todo KF removed 27.6.
        if self.current_value #and not self.current_node.nodes.blank?: self.current_node.valid     =True
        self.current_node.endPointer=pointer
        self.current_node.content   =content.strip # ||=

      if self.nodes[-1].name==name# keep through parent: self.nodes.pop
      # self.new_nodes<<self.current_node  #if name=="boolean" || self.current_value  # WHAT's THAT?:

    if not keepers.index str(name):
      self.current_value=None

  #
  # def included(self,(base)):
  #   base.extend ClassMethods

  class ClassMethods:

    # self.self.__last_methods_added=[]
    #
    # def method_proxy (name, without, args, block):
    #   before_each_method name
    #   ret           =send without, *args, &block
    #   if not self.current_value #!?!???! TEST!! 7.1.2013: self.current_value=ret
    #   after_each_method name #sets self.current_value None!
    #   #try: except  doesn't work
    #   #if self.current_node whitelist? just return manually? how? parent_node  #!!TEST!! 7.1.2013: ret=self.current_node
    #   return ret
    #
    # def method_added(name):
    #   if name.to_s=="initialize": return True
    #   if not angel.use_tree: return
    #   if self.self.__last_methods_added && self.self.__last_methods_added.include?(name): return
    #   with                   = :"#{name}_with_before_each_method"
    #   without                = :"#{name}_without_before_each_method"
    #   self.self.__last_methods_added = [name, with, without]
    #   define_method with do |*args, &block|
    #     # return method_proxy name,without,args,block Todo
    #     before_each_method name
    #     ret           =send without, *args, &block
    #     if not self.current_value #!?!???! TEST!! 7.1.2013: self.current_value=ret
    #     after_each_method name #sets self.current_value None!
    #     # #try: except  doesn't work
    #     # #if self.current_node whitelist? just return manually? how? parent_node  #!!TEST!! 7.1.2013: ret=self.current_node
    #     return ret
    #
    #   alias_method without, name
    #   alias_method name, with
    #   self.self.__last_methods_added = None
