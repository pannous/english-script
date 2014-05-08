#!/usr/bin/env ruby

require_relative "Interpretation"
require_relative "TreeBuilder"
require_relative "CoreFunctions"
require_relative "english-tokens"
require_relative "power-parser"
require_relative "extensions"
require 'linguistics'
require 'wordnet'
#require 'wordnet-defaultdb'
Linguistics.use(:en, :monkeypatch => true)
#http://99designs.com/tech-blog/ More magic

# look at java AST http://groovy.codehaus.org/Compile-time+Metaprogramming+-+AST+Transformations
class EnglishParser < Parser
  include TreeBuilder
  include CoreFunctions
  include EnglishParserTokens # module
  attr_accessor :variables

  def initialize
    super
    @interpret=@did_interpret=true
    @javascript=""
    @context=""
    @variables={}
    @svg=[]
    @ruby_methods=["puts", "print", "svg"] #"puts"=>x_puts !!!
    @core_methods=["show"] #"puts"=>x_puts !!!
    @methods=[]
    @OK="OK"
    @result=""
  end

  # world this method here to resolve the @string
  def init string0
    @line_number=0
    @lines=string0.split("\n")
    @string=@lines[0]
    @original_string=@string
    @root=nil
    @nodes=[]
    @interpret=true
  end


  def interpretation
    @interpretation=Interpretation.new
    i= @interpretation #  Interpretation.new
    super # set tree, nodes
    i.javascript=@javascript
    i.context=@context
    i.methods=@methods
    i.ruby_methods=@ruby_methods
    i.variables=@variables
    i.svg=@svg
    i.result=@result
    i
  end

  def root
    many {#root}
      try { newline } ||
          try { method_definition } ||
          try { statement } ||
          try { ruby_def } ||
          try { block }||
          try { expression0 } ||
          try { context }
    }
  end

  def context
    _ "context"
    @context= word
    newlines
    #NL
    block
    done
  end


  def bracelet
    subnode "brace" => token("(")
    algebra
    subnode "brace" => token(")")
  end

  def operator
    tokens("+", "*", "-", "/")
  end

  # Strange method
  def eval_string x #hackety hack for non-tree mode
    return x.to_path if x.is_a? File
    return x if x.is_a? String and x.index("/") #file, not regex!  ... notodo ...  x.match(/^\/.*[^\/]$/)
    x=x.join(" ") if x.is_a? Array
    do_evaluate x
  end

  def algebra
    must_contain operator
    result=any { try { value } or try{bracelet} }
    star {
      op=operator #operator KEYWORD!?! ==> @string="" BUG
      no_rollback!
      @string=""+@string2 #==> @string="" BUG WHY??
      y=try { value } || bracelet
      if not $use_tree and @interpret
        result=do_send(result, op, y) rescue SyntaxError
      end
      true
    }
    return result
    if @interpret
      @result=parent_node.eval_node @variables if $use_tree #wasteful!!
    end
    $use_tree ? parent_node : @result
  end

  def javascript
    __ @context=="javascript" ? "script" : "java script", "javascript", "js"
    no_rollback! 10
    @javascript+=rest_of_line+";"
    newline?
    return @javascript
    #block and done if not @javascript
  end


  def script_block
    _ "<script>"
    read_until "</script>"
  end


  def block
    start=pointer
    statement
    star {
      newlines
      statement
    }
    newline? # danger might act as block end!
    return parent_node if $use_tree
    return pointer-start if not $use_tree
  end

  #direct_token : WITH space!
  def token t
    #return nil if checkEnd
    @string.strip!
    raiseEnd
    if starts_with? t
      @current_value=t.strip
      @string=@string[t.length..-1].strip
      return @current_value
    else
      verbose "expected "+t.to_s # if @throwing
      raise NotMatching.new(t)
    end
  end

  def tokens *tokenz
    raiseEnd
    string=@string.strip+" "
    for t in tokenz.flatten
      return true if (t=="\n" and @string.empty?)
      if t.match(/\w/)
        match=string.match(/^\s*#{t}/im)
        next if match and not match.post_match.match /[^\w]/ # next must be space or so!
      else #special char
        match=string.match(/^\s*#{escape_token t}/im)
      end
      if match
        x=@current_value=t
        @string=match.post_match.strip
        @string2=@string
        return x
      end
    end
    raise NotMatching.new(tokenz.to_s) #if @throwing
  end

  def escape_token t
    t.gsub(/([^\w])/, "\\\\\\1")
  end

  def starts_with? tokenz
    return false if checkEnd
    string=@string+" " # todo: as regex?
    tokenz=[tokenz] if tokenz.is_a? String
    for t in tokenz
      # RUBY BUG?? @string.start_with?(/#{t}[^\w]/)
      if t.match(/\w/)
        return t if string.match(/^#{t}[^\w]/im)
      else
        return t if string.start_with? t #escape_token []
      end
    end
    return false
  end

  def listSelector
    functionalSelector
  end

  def functionalSelector
    _ "{"
    xs=true_variable
    crit=selector
    _ "}"
    filter(xs, crit)
  end

  def list
    must_contain ","
    start_brace= try { token "[" }
    start_brace= _? "{" if not start_brace
    raise NotMatching.new "not a deep list" if not start_brace and (@inside_list)
    @inside_list=true
    all=[]
    #all<<expression(start_brace)
    all<<endNode
    star {
      tokens(",", "and") # danger: and as plus
      all<<endNode
      #all<<expression
    }
    @inside_list=false
    _ "]" if start_brace=="["
    _ "}" if start_brace=="{"
    all
  end

  def plusEqual
    v=variable
    _ "+="
    e=expression0
    @variables[v]=@result=do_evaluate(v)+e if @interpret
    v
  end


  def plusPlus
    v=variable
    _ "++"
    @variables[v]=@result=do_evaluate(v)+1 if @interpret
    v
  end


  def orEqual
    v=variable
    __ "|=", "||="
    @variables[v]=@result=do_evaluate(v) or (do_evaluate expression0) if @interpret
    v
  end

  def selfModify
    try { plusEqual } ||
        try { plusPlus } ||
        try { orEqual }
    #orEqual
  end

  def expression0
    start=pointer
    ex=any {#expression}
      try { listSelector } ||
      try { evaluate_property } ||
      try { selfModify } ||
      try { list } ||
      try { algebra } ||
      try { endNode }
    }
    return pointer-start if not @interpret
    @result=do_evaluate ex if ex and @interpret rescue SyntaxError
    @result=ex if not @result or @result==SyntaxError and not ex==SyntaxError # keep false
    return @result
  end

  def statement
    raiseNewline
    x=any {#statement}
      return @NEWLINE if checkNewline
      try { loops }||
          try { if_then } ||
          try { once } ||
          try { action } ||
          try { expression0 } # AS RETURN VALUE! DANGER!
    }
    x
    #one :action, :if_then ,:once , :looper
    #any{action || if_then || once || looper}
  end

  def method_definition
    method #  how to
    no_rollback!
    name=verb #  integrate
    obj=try { endNode } # a sine wave
    args=star { arg } # over an interval
    start_block # :
    no_rollback! 10
    @interpret=false
    block
    done
    @interpret=true
    @methods[name]=parent_node rescue nil
    name
  end

  def ruby_action
    _ 'ruby'
    exec(action || quote)
  end


  def bash_action
    must_contain 'bash'
    remove_tokens 'execute', 'command', 'commandline', 'run', 'shell', 'shellscript', 'script', 'bash'
    @command = try { quote } # danger bash "hi">echo
    @command = rest_of_line if not @command
                             #any{ try{  } ||  statements }
    begin
      puts "going to execute " + @command
      result=%x{#{@command}}
      puts "result:"
      puts result
      return result || true
    rescue
      puts "error executing bash_action"
    end

  end



  def condition_tree
    brace=_? "("
    condition_tree if brace
    condition if not brace
    star{
      __ "and","or","xor","nand"
      condition_tree
    }
    _ ")" if brace
  end



  def if_then
    __ if_words
    no_rollback!
    dont_interpret
    c=condition
    _? 'then'
    use_block=start_block?
    b=block if use_block # interferes with @comp/condition
    b=action if not use_block
    done
    return do_execute_block b if check_interpret and check_condition c
    return b
  end

  def once_trigger
    __ once_words
    dont_interpret
    c=condition
    no_rollback!
    _? 'then'
    use_block=start_block?
    b=action and end_expression if not use_block
    b=block and done if use_block
    add_trigger c,b
  end


  def action_once
    must_contain once_words # if not _do and newline
    _do=_? "do"
    dont_interpret
    b=action if not _do
    b=block and done? if _do
    __ once_words
    c=condition
    end_expression
    add_trigger c,b
  end


  def once
#	|| 'as soon as' condition \n block 'ok'
#	|| 'as soon as' condition 'then' action;
    try{once_trigger}||
        action_once
#	|| action 'as soon as' condition
  end

#/*n_times
#	 verb number 'times' preposition nod -> "<verb> <preposition> <nod> for <number> times" 	*/
#/*	 verb number 'times' preposition nod -> ^(number times (verb preposition nod)) # Tree ~= lisp	*/

  def verb_node
    v=verb
    nod
    raise UnknownCommandError.new "no such method: "+v if !@methods.contains(v)
    #end_expression
  end

  def spo
    s=endNoun
    p=verb
    o=nod
    return do_send(s, p, o) if @interpret
  end

  def substitute_variables args
    #args=" "+args+" "
    for variable in @variables.keys
      variable=variable.join(" ") if variable.is_a? Array #HOW!?!?!
      value=@variables[variable]||"nil"
                                                          #args.gsub!(/\$#{variable}/, "#{variable}") # $x => x !!
      args.gsub!(/.\{#{variable}\}/, "#{value}") #  ruby style #{x} ;}
      args.gsub!(/\$#{variable}$/, "#{value}") # php style $x
      args.gsub!(/\$#{variable}([^\w])/, "#{value}\\\1")
      args.gsub!(/^#{variable}$/, "#{value}")
      args.gsub!(/^#{variable}([^\w])/, "#{value}\\1")
      args.gsub!(/([^\w])#{variable}$/, "\\1#{value}")
      args.gsub!(/([^\w])#{variable}([^\w])/, "\\1#{value}\\2")
    end
    #args.strip
    args
  end

  def x_puts x
    if @result
      @result+=x.to_s rescue nil
    else
      @result=x
    end
    puts x
    x
  end

  #def print x
  #  @result+=x.to_s
  #  p x
  #  x
  #end

  def ruby_method_call
    call=tokens? "call", "execute", "run", "start", "evaluate", "invoke"
    if call # remove later
      no_rollback! if call # remove later
    end
    ruby_method=tokens? @ruby_methods
    raise UndefinedRubyMethod.new word if not ruby_method
    ruby_method.gsub!("puts", "x_puts")
    args=substitute_variables rest_of_line
    begin
      the_call=ruby_method+" "+args.to_s
      @result=eval(the_call)||""
      verbose the_call+"  called successfully with result "+@result.to_s
    rescue => e
      puts "\n!!!!!!!!!!!!\n ERROR calling #{the_call}\n!!!!!!!!!!!!\n "
      error $!
      puts "!!!! ERROR calling "+the_call
    end
    checkNewline
    #raiseEnd
    @current_value=ruby_method
    #return @OK # don't return nil!
    return ruby_method
  end


  # Object.constants  :IO, :STDIN, :STDOUT, :STDERR ...:Complex, :RUBY_VERSION ...
  def has_object m
    object_method = Object.method(m) rescue false
    if object_method # Bad approach:  that might be another method Tree.beep!
      return false
                     #method=Object.method(m) # todo : find OTHER! not just Object.
    end
    true
  end

  def has_args m,clazz=Object
    object_method = clazz.method(m) rescue false
    clazz=clazz.class if not clazz.is_a? Class #lol
    # todo : better
    object_method = clazz.method(m) if not object_method rescue false
    object_method = clazz.public_instance_method(m) if not object_method rescue false
    if object_method # Bad approach:  that might be another method Tree.beep!
      return object_method.arity>0
    end
    return true
  end

  def true_method
    v=verb? || tokens?(@methods.names)|| Object.method(word) rescue nil
    raise NotMatching.new "no method found" if not v
    v
  end


  def method_call
    #verb_node
    method=true_method
    obj=nil
    if has_object(method)
      obj=try { nod }
    end
    if has_args(method,obj)
      @current_value=nil
      args=star { arg }
    end
    #end_expression
    if @interpret
      return do_send(obj, method, args)
    end
    return method
  end

  def bla
    @current_value=nil
    star {
      tokens "tell me", "hey", "could you", "give me",
             "i would like to", "can you", "please", "let us", "let's", "can i",
             "can you", "would you", "i would", "i ask you to", "i'd",
             "love to", "like to", "i asked you to", "would you", "could i",
             "i tell you to", "i told you to", "would you", "come on",
             "i wanna", "i want to", "i want", "tell me", "i need to",
             "i need"
    }
    #_? "know" # what is
  end


  #	||'say' x=(.*) -> 'bash "say $quote"'
  def action
    start=pointer
    bla?
    result=any {#action
      try { javascript } ||
          try { bash_action } ||
          try { setter } ||
          try { ruby_method_call } ||
          try { selfModify } ||
          try { method_call } ||
          try { evaluate_property } ||
          try { evaluate } ||
          try { spo }
                #try { verb_node } ||
                #try { verb }
    }
    raise NoResult.new if not result
    newline? #cut rest, BUT:
    return pointer-start if not $use_tree and not @interpret
    return result
  end

  def while_loop
    _ 'while'
    dont_interpret
    no_rollback!
    c=condition
    start_block
    #no_rollback! 13 # arbitrary value ! :{
    a=block
    end_block
    r=do_execute_block a while (check_condition c) if check_interpret
    r
  end

#
#def until_condition
#  action
#  _'until'
#  condition
#end
#
#def while_condition
#  action
#  _'while'
#  condition
#end
#
#def as_long_condition
#  action
#  _'as long'
#  condition
#end
#

  def looped_action
    must_contain 'as long', 'while', 'until'
    dont_interpret
    _? "do"
    _? "repeat"
    a=action
    __ 'as long', 'while', 'until'
    c=condition
    do_execute_block a while (check_condition c) if check_interpret
  end

  # notodo : LTR parser just here!
  def times
    must_contain 'times'
    dont_interpret
    _? "do"
    #_? "repeat"
    a=action
    n=number
    _ 'times'
    end_block
    n.times { do_evaluate a } if check_interpret
  end


# todo : node cache : skip action(X) -> _'forever'  if action was (not) parsed before
  def forever
    must_contain 'forever'
    dont_interpret
    allow_rollback
    a= action
    _ 'forever'
    @forever=true
    do_execute_block a while (@forever) if check_interpret
  end

  def as_long_condition_block
    _ 'as long as'
    c=condition
    start_block
    a=block #  danger, block might contain condition
    end_block
    do_execute_block a while (check_condition c) if check_interpret
  end

  def end_block
    done
  end

  def do_execute_block b
    block_parser=EnglishParser.new
    block_parser.variables=@variables
    @result=block_parser.parse(b.join("\n")).result
    @variables=block_parser.variables
    @result
    #do_evaluate b
  end

  def repeat_n_times
    _ 'repeat'
    n=number
    _ 'times'
    dont_interpret
    start_block
    b=try { action }
    #b=block if not b
    end_block
    n.times { do_execute_block b } if check_interpret
    b
    #parent_node if $use_tree
  end

  def loops
    any {#loops }
      try { repeat_n_times }||
          try { while_loop }||
          try { looped_action }||
          try { times }||
          try { as_long_condition_block }||
          try { forever }
    }
  end


  def end_expression
    checkEnd||newline
  end

#  until_condition ,:while_condition ,:as_long_condition

#  CAREFUL WITH WATCHES!!! THEY manipulate the current system, especially variable
#/*	 let nod be nods */
  def setter
    no_rollback! if let?
    the?
    mod=modifier?
    tokens? 'var', 'val', 'value of'
    mod||=modifier? # ??
    old=@string
    var=variable
    # _?("always") => pointer
    setta=_?("to")or be # or not_to_be 	contain -> add or create
    no_rollback!
    val=expression0
    val=[val].flatten if setta=="are" or setta=="consist of" or setta=="consists of"
    if @interpret and (mod!="default" ) or not @variables.contains(var)
      @variables[var]=val
    end
    end_expression
    return var if @interpret
    return parent_node if $use_tree
    return old-@string if not @interpret # for repeatable, BAD
                                         # ||'to'
                                         #'initial'?	let? the? ('initial'||'var'||'val'||'value of')? variable (be||'to') value
  end

  def variable
    article?
    p=pronoun?
    all=p ? [p] : []
    all+=one_or_more { word }
    all.join(" ")
  end


  def word item=nil
    #danger:greedy!!!
    no_keyword
    raiseNewline
    #raise EndOfDocument.new if @string.blank?
    #return false if starts_with? keywords
    match=@string.match(/^\s*[a-zA-Z]+[\w_]*/)
    if (match)
      @string=@string[match[0].length..-1].strip
      @current_value=match[0].strip
      return match[0]
    end
    #fad35
    #unknown
    noun
  end

  def no_keyword_except except=[]
    bad=starts_with? keywords-except
    raise ShouldNotMatchKeyword.new bad if bad
    return bad
  end

  def no_keyword
    no_keyword_except []
  end

  def constant
    tokens constants
  end

  def value
    @current_value=nil
    no_keyword_except constants+numbers
    @current_value=x=any {
      try { quote }||
          try { number } ||
          try { true_variable } ||
          try { constant }||
          try { nod } ||
          try { nill }
      #rest_of_line # TOOBIG HERE!
    }
    x
  end


  def nod #options{generateAmbigWarnings=false}
    try { number } ||
        try { quote } ||
        try { the_noun_that } #||
        #try { variables_that } # see selectable
  end

  def article
    tokens articles
  end

  def arg
    preposition #  might be superfluous if CALLING!
    endNode # about sex
  end


  def compareNode
    c=comparison
    raise NotMatching.new "compareNode = not allowed" if c=="=" #todo
    endNode # expression
  end

  def whose
    _ 'whose'
    endNoun
    compareNode # is bigger than live
  end

  # things that stink
  # things that move backwards
  # people who move like Chuck
  # the input, which has caused problems
  #images which only vary horizontally
  def that_do
    __ 'that', 'who', 'which'
    star { adverb } # only
    @comp=verb # live
    _? 's' # lives
    star { adverb?||# happily
        preposition? || # in
        endNoun? # africa
    }
  end

  # more easisly
  def more_comparative
    __ "more", "less", "equally"
    adverb
  end


  def as_adverb_as
    _ "as"
    adverb
    _ "as"
  end

  # 50% more
  # "our burgers have more flavor",
  # "our picture is sharper"
  # "our picture runs sharper"
  def null_comparative
    verb
    comparative
    endNode?
    return c if c.starts_with? "more" or c.ends_with? "er"
  end

  #  faster than ever
  #  more funny than the funny cat
  def than_comparative
    comparative
    _ "than"
    adverb? || endNode
  end


  def comparative
    c=more_comparative? or adverb
    @comp=c if c.starts_with? "more" or c.ends_with? "er"
  end


  def that_are
    __ 'that', 'which', 'who'
    be
    try { compareNode }|| # bigger than live
        @comp= adjective? || # simple
            gerund #  whining
  end

  # things that I saw yesterday
  def that_object_predicate
    tokens 'that', 'which', 'who', 'whom'
    pronoun? or endNoun
    verbium
    star {
      adverb? || preposition? || endNoun?
    }
  end


  def that
    filter=any {
      try { that_do } ||
          try { that_are }||
          try { whose }
    }
  end


  def where
    tokens 'where' # NOT: ,'who','whose','which'
    condition
  end

# ambivalent?  delete james from china

  def selector
    return if checkEnd
    x=any {
      try { compareNode }||
          try { where }|| # sql style
          try { that } || # friends that live in africa
          try { token('of') and endNode }|| # friends of africa
          try { preposition and nod } # friends in africa
    }
    $use_tree ? parent_node : @current_value
  end


# preposition nod  # ambivalent?  delete james, from china delete (james from china)

# (who) > run like < rabbits
# contains
  def verb_comparison
    star { adverb }
    @comp=nil
    @comp=verb # WEAK !?
    preposition?
    @comp
  end


  def comparison # WEAK pattern?
    @comp=try { verb_comparison }|| # run like , contains
        try { comparation } # are bigger than
  end


# is more or less
# is neither ... nor ...
  def comparation
    # danger: is, is_a
    eq=tokens? be_words
    tokens? 'either', 'neither'
    @not=tokens? 'not'
    try { adverb } #'quite','nearly','almost','definitely','by any means','without a doubt'
    if (eq) # is (equal) optional
      comp=tokens? true_comparitons
    else
      comp=tokens true_comparitons
      no_rollback!
    end
    tokens? 'and', 'or', 'xor', 'nor'
    tokens? true_comparitons # bigger or equal  != SEE condition_tree
    _? 'than', 'then' #_?'then' ;}
    @comp=comp||eq
  end

  def either_or
    tokens? 'be', 'is', 'are', 'were'
    tokens 'either', 'neither'
    comparation?
    value
    tokens? 'or', 'nor'
    comparation?
    value
  end

  def is_comparator c
    true_comparitons.contains(c) || class_words.contains(c)
  end

  def check_condition cond=nil #later:node?
    begin
      if cond #HAAACK DANGARRR
      #@a,@comp,@b= extract_condition c if c
      evals=""
      @variables.each{|var,val|evals+= "#{var}=#{val};"}
      return @result=eval(evals+cond.join(" "))
      end
      @result=do_compare(@a, @comp, @b) if is_comparator @comp
      @result=do_send(@a, @comp, @b) if not is_comparator @comp
      @result=!@result if @not
      if not @result
        debug "condition not met"
      end
      return @result
    rescue => e
      #debug x #soft message
      error e #exit!
    end
    return false
  end

  def condition
    start=pointer
    brace=_? "("
    no=_? "not"
    not_brace=_? "("
    @a=endNode
    #a=expression
    @not=false
    @comp=use_verb=try { verb_comparison } # run like , contains
    @comp=try { comparation } if not use_verb # are bigger than
    #allow_rollback # upto where??
    #b=expression
    @b=endNode
    _ ")" if brace
    _ ")" if not_brace
    negate = (no||@not)&& !(no and @not)
    subnode negate: negate
    if @interpret
      return negate ? !check_condition  : check_condition # nil
    end
    return start-pointer if not $use_tree
    return parent_node  if $use_tree
  end

# todo  I hate to ...
  def loveHateTo
    _? "would", "wouldn't"
    __? "do", "not", "don't"
    __ ['want', 'like', 'love', 'hate']
    _ 'to'
  end


  def gerundium
    verb
    token 'ing'
  end


  def verbium
    comparison||verb and adverb # be||have||
  end

  def the_noun_that
    the?
    noun
    star { selector }
  end



  #def plural
  #  word #todo
  #end

  def typeName
    tokens type_names
  end


  def gerund
    #'stinking'
    match=@string.match(/^\s*(\w+)ing/)
    return false if not match
    @string=match.post_match
    pr=tokens? prepositions # wrapped in
    endNode? if pr # silver
    @current_value=match[1]
    @current_value
  end

  def postjective # 4 squared , 'bla' inverted, buttons pushed in, mail read by James
    match=@string.match(/^\s*(\w+)ed/)
    return false if not match
    @string=match.post_match
    pr=tokens? prepositions if not checkEnd # wrapped in
    endNode? if pr and not checkEnd # silver
    @current_value=match[1]
    @current_value
  end

  def do_evaluate x
    begin
      return x if x.is_a? Array
      return @variables[x] if @variables.contains x
      return x.eval_node @variables if x.is_a? TreeNode
      return resolve x if x.is_a? String and match_path(x)
      return x.call if x.is_a? Method
      return eval(x) rescue x # system.jpg  DANGER? OK ^^
                              # ... todo METHOD / Function!
    rescue SyntaxError
      return x
    end
  end

  def resolve x
    return Dir.new x if is_dir x
    return File.new x if is_file x
    x
  end

  def do_evaluate_property x, y
    # todo : eval NODE !@!!
    verbose "do_evaluate_property "+x.to_s+" "+y.to_s
    @result=nil #delete old!
    x="class" if x=="type" # !@!@*)($&@) NOO
    x=x.value_string if x.is_a? TreeNode
    x=x.join(" ") if x.is_a? Array
    y=y.to_s #if y.is_a? Array
    all=x.to_s+" of "+y.to_s
    x=x.gsub(" ", " :")
    begin
      @result=eval(y+"."+x) rescue nil
      @result=eval("'"+y+"'."+x) if not @result rescue SyntaxError #string method
                  #@result=eval('"'+y+'".'+x) if not @result  rescue SyntaxError #string method
      @result=eval(all) if not @result rescue SyntaxError
    end
    @result
  end


  def do_send x, op, y
    obj=resolve(x)
    args=eval_string(y)
    return false if not obj
    return false if not op
    if obj.respond_to? op
      # OK
    elsif  obj.respond_to? op+"s"
      op=op+"s"
    elsif  obj.respond_to? op.gsub(/s$/, "")
      op=op.gsub(/s$/, "")
    end
    obj=Object if not obj or not has_object op
    #todo : call FUNCTIONS!
    return @result=obj.send(op) if not has_args op,obj #rescue SyntaxError
    return @result=obj.send(op, args) if has_args op,obj #rescue SyntaxError
  end

  def do_compare a, comp, b
    a=eval_string(a)
    b=eval_string(b)
    if comp=="smaller"||comp=="tinier"||comp=="<"
      return a<b
    elsif comp=="bigger"||comp=="larger"||comp==">"
      return a>b
    elsif class_words.index comp or comp.match(/same/)
      return a.is_a b
    elsif be_words.index comp or comp.match(/same/)
      return a.is b
    else
      begin
        return a.send(comp, b) # raises!
      rescue
        error("ERROR COMPARING "+ a.to_s+" "+comp.to_s+" "+b.to_s)
        return a.send(comp+"?", b)
      end
    end
  end

  def filter list, criterion
    return list if not criterion
    list=eval_string(list)
    list=get_iterator(list) if not list.is_a? Array
    if $use_tree
      method=criterion[:comparative]||criterion[:comparison]||criterion[:adjective]
      args=criterion[:endNode]||criterion[:endNoun]||criterion[:expression0]
    else
      method=@comp
      args=criterion
    end
    list.select { |i|
      do_compare(i, method, args) rescue false #REPORT BUGS!!!
    }
  end

  def selectable
    must_contain "that","whose","which"
    tokens? "every", "all", "those"
    xs=try { endNoun } || true_variable
    s=try { selector }
    x=filter(xs, s) if @interpret rescue xs
    x
  end

  # # || endNode have adjective || endNode attribute || endNode verbTo verb #||endNode auxiliary gerundium
  def endNode
    raiseEnd
    x=any {# NODE }
           #try { plural} ||
          try { rubyThing } ||
          try { fileName } ||
          try { linuxPath } ||
          try { evaluate_property }||
          try { selectable } ||
          try { true_variable } ||
          try { article?; word } ||
          try { article?; typeName } ||
          try { value }
    }
    po=try { postjective } # inverted
    if po and @interpret
      x=@current_value=x.send(po) rescue x #DANGAR!!
    end
    x
  end


  def endNoun include=[]
    article?
    adjs=star { adjective } #  first second ... included
    obj=noun include
    return parent_node if $use_tree
    adjs=' ' + adjs.join(" ") if adjs and adjs.is_a? Array
                            #return adjs.to_s+" "+obj.to_s # hmmm
    return obj.to_s + adjs.to_s # hmmm
  end

  def any_ruby_line
    line=@string
    @string=@string.gsub(/.*/, "")
    checkNewline
    line
  end

  def execute_ruby_block
    #require 'evil'
    lines=ruby_block
    result=eval(lines.join("\n"))
    puts result
    #result=class_eval(lines.join("\n"))
    #p result
    #A.instance_method(:m).force_bind(B.new).call
    #ruby_block_test
  end


  def ruby_block
    block_depth=0
    lines=[]
    star {
      raise EndOfBlock.new if (start_with? "end") and block_depth==0
      line=any_ruby_line
      lines<<line
      line
    }
    lines<<"end" #todo: in any_ruby_line
    @current_value=lines #todo: !?!
    lines
  end

  def ruby_def
    _ "def"
    no_rollback!
    lines=["def "+@string]
    method=word "method"
    #@current_node.value=method #has ruby_block leaf!
    try { arg=word; }
    try { _ "="; defaulter=(quote? or word?) } # or ...!?
    star { _ ","; arg=word; }
    newline
    lines+=ruby_block
    #-- # // Some Ruby coat goes here
    newline?
    done
    begin
      #Redirect output to HTML result
      the_script=lines.join("\n").gsub("puts", "x_puts")
      eval the_script
      @ruby_methods<<method
      @methods<<@current_node # to do : more
      verbose method + " defined successfully !"
    rescue
      error "error in ruby_def block"
      error lines
      error $!
    end
    newline?
    lines
  end


  def start_block
    return @OK if checkNewline
    try { tokens ":", "do", "{", "first you ", "second you ", "then you ", "finally you " }
  end


  def english_to_math s
    s.replace_numerals!
    s.gsub!(" plus ", "+")
    s.gsub!(" minus ", "-")

    s.gsub!(/(\d+) multiply (\d+)/, "\\1 * \\2")
    s.gsub!(/multiply (\d+) with (\d+)/, "\\1 * \\2")
    s.gsub!(/multiply (\d+) by (\d+)/, "\\1 * \\2")
    s.gsub!(/multiply (\d+) and (\d+)/, "\\1 * \\2")
    s.gsub!(/divide (\d+) with (\d+)/, "\\1 / \\2")
    s.gsub!(/divide (\d+) by (\d+)/, "\\1 / \\2")
    s.gsub!(/divide (\d+) and (\d+)/, "\\1 / \\2")
    s.gsub!(" multiplied by ", "*")
    s.gsub!(" times ", "*")
    s.gsub!(" divided by ", "/")
    s.gsub!(" divided ", "/")
    s.gsub!(" with ", "*")
    s.gsub!(" by ", "*")
    s.gsub!(" and ", "+")
    s.gsub!(" multiply ", "*")
    return s
  end

  def evaluate_property
    _? "all" # list properties (all files in x)
    must_contain "of", "in"
    raiseNewline
    x=endNoun type_keywords
    __ "of", "in"
    y=expression0
    return parent_node if not @interpret
    begin #interpret !:
      do_evaluate_property(x, y)
    rescue SyntaxError => e
      verbose "ERROR do_evaluate_property"
      #@result=jeannie all if not @result
    rescue => e
      verbose "ERROR do_evaluate_property"
      verbose e
      error e
      error $!
      #@result=jeannie all if not @result
    end
    return @result
  end


  def jeannie request
    jeannie_api="https://weannie.pannous.com/api?"
    params="login=test-user&out=simple&input="
    #raise "empty evaluation" if @current_value.blank?
    download jeannie_api+params+URI.encode(request)
  end

  #  those attributes. hacky? do better / don't use
  def subnode attributes={}
    return if not $use_tree
     return if not @current_node #raise!
    attributes.each do |name, value|
      @current_node.nodes<<TreeNode.new(name: name, value: value)
      @current_value=value
    end
    return @current_value
  end

  def evaluate
    __ "what is", "evaluate", "how much", "what are", "calculate", "eval"
    no_rollback!
    the_expression= rest_of_line
    subnode statement: the_expression
    @current_value=the_expression
    begin
      @result=eval(english_to_math the_expression) #if @result.blank?
    rescue
      @result=jeannie(the_expression)
    end
    subnode result: @result # todo: via automagic
    @current_value=@result
    @current_value
  end


  def newline?
    try { newline }
  end

  def raiseNewline
    raise EndOfLine.new if @string.blank?
  end

  def checkNewline
    comment if not @string.blank?
    if @string.blank? or @string.strip.blank?
      @line_number=@line_number+1 if @line_number<@lines.count
      @original_string="" if @line_number>=@lines.count #!
      return @NEWLINE if @line_number>=@lines.count
                                                        #raise EndOfDocument.new if @line_number==@lines.count
      @string=@lines[@line_number];
      @original_string=@string
      checkNewline
      return @NEWLINE
    end
  end

  def newline_tokens
    ["\.\n", "\. ", "\n", "\r\n", ";"] #,'\.\.\.' ,'end','done' NO!! OPTIONAL!
  end

  def newline
    return @NEWLINE if checkNewline==@NEWLINE
    found=tokens newline_tokens
    return @NEWLINE if checkNewline==@NEWLINE # get new line
    return found
  end

  def newlines
    #one_or_more{newline}
    star { newline }
  end

  def NL
    tokens '\n', '\r'
  end


  def NLs
    tokens '\n', '\r'
  end


  def rest_of_statement
    @current_value=@string.match(/(.*?)([\r\n;]|done)/)[1].strip
    @string=@string[@current_value.length..-1]
    return @current_value
  end

  def rest_of_line
    if not @string.match(/(.*?)[;\n]/)
      @current_value=@string
      @string=nil
      return @current_value
    end
    @current_value=@string.match(/(.*?)[;\n]/)[1]
    @string=@string[@current_value.length+1..-1]
    @current_value.strip!
    return @current_value
  end

  def comment_block
    token '/*'
    @string.gsub('.*?\*\/', '')
    #token '*/'
    add_tree_node
  end

  def comment
    raiseEnd if @string==nil
    @string.gsub!(/ -- .*/, '');
    @string.gsub!(/\/\/.*/, ''); # todo
    @string.gsub!(/#.*/, '');
    checkNewline if @string.blank?
  end

  def start
    super
    result= "<script>"+ @javascript+"</script>"
    result
  end

  def svg x
    @svg<<x
  end

  def self.start_shell
      if ARGV.count==0 #and not ARGF
        puts "usage: \n ./english-script.sh eval 6 plus six\n ./english-script.sh examples/test.e"
        exit
     end
    a=ARGV[0].to_s
    # read from commandline argument or pipe!!
    @all=ARGF.read||File.read(a) rescue a
    @all=@all.split("\n") if @all.is_a?(String)
    for line in @all
      next if line.blank?
      interpretation=EnglishParser.new.parse line
      puts interpretation.result
    end
  end


end

$testing||=false
EnglishParser.start_shell if ARGV and not $testing
