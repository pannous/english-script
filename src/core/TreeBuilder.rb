#require File.expand_path(File.dirname(__FILE__) + '/../node.rb')
require_relative "treenode"
require_relative "extensions"

#class MethodInterception
module TreeBuilder

  def initialize
    super # needs to be called by hand!
    #@tree=[]
    @nodes        =[]
    @tokens       =[]
    @new_nodes    =[] #  remove after try failed
    @current_node =nil
    @last_node    =nil
    @root         =nil
    @current_value=""
  end

  def ignore_parent
    ["rest_of_line"]
    # "number",
    # ["integer","real"]#,"expression0"]
    # [    "endNode","integer","real","expression0","value","word"]
  end

  # what exactly machen die??  Eigentlich sollen Sie den Wert an den parent weiterleiten aber das klappt nicht
  def keepers #== ignore_parent , ,"rest_of_line"
    ["token", "number", "tokens", "word", "setter", "variable", "value", "method_call", "object",
     "subnode", "integer", "number_word"]
    #             "number_word","integer",
    #   ,"ruby_method_call"
    #   ,"quote"
  end

  def dont_add_node
    ["integer"]
  end

  def delete
    ["bla", "newlines"]
    # "subnode",
  end

  # includes rather than ignore???? or EXPLICIT node construction!!!
  def ignore
    #"newline","newlines","newline?",
    #test_setter Should never be set ("")!?
    #"token","tokens","number",
    # "setter",  "endNode",
    # "rest_of_line","word",
    ignore_parent+#delete+
        ["_", "_?", "interpretation","must_not_match","system_verbs","starts_with","bla", "should_not_match", "do_send",
         "pronouns",
         "end_expression",
         "do_evaluate", "other_verbs",
         "numbers", "tokens", "current_context", "type_names", "possessive_pronouns",
         "ignore", "initialize", "endNode", "start_block", "OK",
         "bad", "wordnet_is_noun", "true_comparitons", "special_verbs", "wordnet_is_verb",
         "checkNewline", "newline", "wordnet_is_adjective",
         "newline?", "ruby_block_test", "subnode_token", "get_adjective", "get_noun", "get_verb",
         "substitute_variables", "raiseNewline", "any", "initialize", "one_or_more", "expression",
         "the_noun_that", "nod", "star", "action", "parse",
         "allow_rollback", "init", "type_keywords", "articles", "modifiers", "auxiliary_verbs",
         "test_setter", "try_action", "method_missing", "endNode2", "no_rollback!", "raiseEnd",
         "string_pointer", "verbose", "try", "checkEnd", "to_source", "rest", "keywords",
         "starts_with?", "be_words", "no_keyword", "no_keyword_except", "prepositions", "variables_list", "the?",
         "app_path", "escape_token", "operators", "newline_tokens",
         "constants", "comment", "any_ruby_line", "quantifiers", "article"] #"call_is_verb",
  end


  def interpretation
    i      = @interpretation #  Interpretation.new
    #i.tree=
    i.root =@root
    i.nodes=@nodes
    i.tree =@root #filter_tree(@root)
    i
  end


  # operator:algebra BUG!?!

  def current_value= x
    @current_value=x
  end

  #todo: move to interpretation or tree.full
  def full_tree node=@root, tabs=0
    return if not node
    puts " "*tabs + "#{node.name} #{node.value}" if not false==node.value
    for n in node.nodes
      full_tree n, (tabs+1)
    end
  end

  def walk_tree node, tabs=0
    puts " "*tabs + node.good_value if node.show_node #if node.valid
    for n in node.nodes
      #next if not n.valid
      walk_tree n, (tabs+1)
    end
    #node.destroy if node.nodes.empty? and not node.valid
  end

  def good_node_values node
    result=""
    result=node.value if node.show_node and node.value
    for n in node.nodes
      result+=good_node_values n
    end
    result
  end

  def flat_tree node
    if node.show_node and node.value
      print node.good_value+" "
    end
    for n in node.nodes
      flat_tree(n)
    end
    puts "" if node.name=="statement" or node.name==:statement
  end

  def flat_tree2 node, collect=[]
    if node.show_node and node.value
      puts node.good_value
      collect<<node
    end
    for n in node.nodes
      collect<< flat_tree(n)
    end
    collect
  end

  #todo: move to interpretation or tree.show
  def show_tree
    return if not @root or not $use_tree
    walk_tree @root
    puts "---------"
    flat_tree @root
  end

  def bad name
    return true if not $use_tree
    return true if name.to_s.end_with? "_words"
    #return true if name.to_s.start_with? "test_" # NEEDED for algebra.parent todo!
    #bad_name=true if name.to_s.end_with?("?") or
    ignore.index name.to_s # 0 == true ! OK
  end

  def parent_node
    return @original_string-@string if not $use_tree # @nodes.count==0
    for i in 0..(caller.count)
      next if not caller[i].match(/parser/)
      name=caller[i].match(/`(.*)'/)[1]
      for j in 1..(@nodes.count)
        node     =@nodes[-j]
        node_name=node.name.to_s
        if (node_name==name)
          return node
        end
      end
    end
    return nil
  end

  def before_each_method name
    if not bad name
      @current_value            =nil # if not keepers.index name.to_s
      #parent=@current_node
      @current_node             =TreeNode.new(parent: parent_node, name: name)
      @current_node.startPointer=pointer
      @root                     =@current_node if @nodes.count==0
      @nodes<<@current_node #OPTIMISTIC!! not after? noo, then it's a mess! delete in try/star/...
    end
    #not bad name and
    #@current_value="" if  not keepers.index name.to_s
    #p [:before_method, name]
  end

  # not called on error, good. cleanup @nodes in try/star/...
  def after_each_method name
    return if not @current_node #HOOOW?
    # return if name!="boolean" and not @current_value
    if not bad name
      @nodes.pop if not @nodes[-1].name==name# keep through parent
      @current_node=@nodes[-1]
      if @current_node
        content=pointer-@current_node.startPointer
        @current_node.value     =@current_value # todo KF removed 27.6. if @current_node.is_leaf
        @current_node.valid     =true if @current_value #and not @current_node.nodes.blank?
        @current_node.endPointer=pointer
        @current_node.content   =content.strip # ||=
      end
      @nodes.pop if @nodes[-1].name==name# keep through parent
      # @new_nodes<<@current_node  #if name=="boolean" || @current_value  # WHAT's THAT?
    end
    if not keepers.index name.to_s
      @current_value=nil
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    @@__last_methods_added=[]

    def TreeBuilder.method_proxy name, without, *args, &block
      before_each_method name
      ret           =send without, *args, &block
      @current_value=ret if not @current_value #!?!???! TEST!! 7.1.2013
      after_each_method name #sets @current_value nil!
      #begin rescue  doesn't work
      #ret=@current_node if @current_node whitelist? just return manually? how? parent_node  #!!TEST!! 7.1.2013
      return ret
    end

    def method_added name
      return true if name.to_s=="initialize"
      return if not $use_tree
      return if @@__last_methods_added && @@__last_methods_added.include?(name)
      with                   = :"#{name}_with_before_each_method"
      without                = :"#{name}_without_before_each_method"
      @@__last_methods_added = [name, with, without]
      define_method with do |*args, &block|
        # return method_proxy name,without,args,block Todo
        before_each_method name
        ret           =send without, *args, &block
        @current_value=ret if not @current_value #!?!???! TEST!! 7.1.2013
        after_each_method name #sets @current_value nil!
        # #begin rescue  doesn't work
        # #ret=@current_node if @current_node whitelist? just return manually? how? parent_node  #!!TEST!! 7.1.2013
        return ret
      end
      alias_method without, name
      alias_method name, with
      @@__last_methods_added = nil
    end

  end

end
