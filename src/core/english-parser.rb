#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'Interpretation'
require_relative 'TreeBuilder'
require_relative 'CoreFunctions'
require_relative 'english-tokens'
require_relative 'power-parser'
require_relative 'extensions'
require_relative 'events'

require_relative 'grammar/ruby_grammar'
require_relative 'grammar/loops_grammar'

require_relative 'bindings/shell/betty'
require_relative 'bindings/native/native-scripting'
# require_relative 'bindings/common-scripting-objects'

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
  include LoopsGrammar # while, as long as, ...
  include RubyGrammar # def, ...
  include Betty # convert a.wav to mp3
  include ExternalLibraries

  attr_accessor :methods, :result, :interpretation, :variables, :variableValues, :variableType #remove the later!

  def initialize
    super
    @interpret     =@did_interpret=true
    @javascript    =''
    @context       =''
    @variables     ={}
    @variableTypes ={}
    @variableValues={} #    ={nill: nil}
    @svg           =[]
    # @bash_methods=["say"]
    @c_methods     =['printf']
    @ruby_methods  =['puts', 'print'] #"puts"=>x_puts !!!
    @core_methods  =['show', 'now', 'yesterday', 'help'] #difference?
    @methods       ={} # name->method-node
    @OK            ='OK'
    @result        =''
  end

  def now
    Time.now
  end

  def yesterday
    Time.now-24*60*60
  end


  # world this method here to resolve the @string
  def init strings
    @no_rollback_depth=-1
    @line_number      =0
    @lines            =strings if strings.is_a? Array
    @lines            =strings.split("\n") if strings.is_a? String
    @string           =@lines[0]
    @original_string  =@string
    @root             =nil
    @nodes            =[]
    @result           =nil
  end


  def interpretation
    @interpretation=Interpretation.new
    i              = @interpretation #  Interpretation.new
    super # set tree, nodes
    i.javascript  =@javascript
    i.context     =@context
    i.methods     =@methods
    i.ruby_methods=@ruby_methods
    i.variables   =@variables
    i.svg         =@svg
    i.result      =@result
    i
  end

  # beep when it rains
  # listener
  def add_trigger condition, action
    @listeners<<Observer.new(condition, action)
  end

  def root
    many {#root}
      maybe { newline } ||
          maybe { requirements } ||
          maybe { method_definition } ||
          maybe { assert_that } ||
          maybe { ruby_def } ||
          maybe { block and checkNewline }|| # {x=1;x} todo
          maybe { statement and end_expression } || # x=1+1
          maybe { expressions and end_expression } || # 1+1
          maybe { @result=condition; @comp }|| # 1==1
          maybe { context }
    }
  end

  def set_context context
    @context=context
  end

  def module
    __ %w[module package context gem library] #source
    set_context rest_of_line
  end

  def javascript_require dependency
    require_relative "bindings/js/javascript_auto_libs"
    # require_relative "javascript_auto_libs"
    dependency.gsub!(/.* /, "") # require javascript bla.js
    mapped    =$javascript_libs[dependency]
    dependency=mapped if mapped
    @javascript<<"javascript_require(#{dependency});"
  end

  def includes dependency, type, version
    return javascript_require dependency if dependency.match /\.js$/
    return javascript_require dependency if type and %w[javascript script js].has type
    return ruby_require dependency if not type or %w[ruby gem].has type
  end

  # #{escape_token t}
  def regex x
    match=@string.match(x)
    match||=@string.match(/^\s*#{x}/im)
    raise NotMatching(x) if not match
    @string       =match.post_match.strip
    @current_value=x
  end

  def package_version
    _? 'with'
    c=_? comparison_words
    __ 'v', 'version'
    c||=_? comparison_words
    subnode bigger: c
    # @current_value=
    @result=regex '\d(\.\d)*'
    _? "or later"
  end

  #  (:use [native])
  def requirements
    require_types=%w[javascript script js gcc ruby gem header c cocoa native] # todo c++ c# not tokened!
    type         =__? require_types
    __ 'dependencies', 'dependency', 'depends on', 'depends', 'requirement', 'requirements', 'require', 'required',
       'include', 'using',
       'uses', 'needs', 'requires'
    type||=__? require_types
    __? %w[file script header source src]
    __? 'gem', 'package', 'library', 'module', 'context'
    type      ||= __? require_types
    # source? really?
    dependency=quote?
    no_rollback! 5
    # list_of?{packages}
    dependency||= word #regex "\w+(\/\w*)*(\.\w*)*\.?\*?" # rest_of_line
    version   =package_version?
    includes dependency, type, version if check_interpret
    return {dependency: {type: type, package: dependency, version: version}}
  end

  def context
    _ 'context'
    @context= word
    newlines
    #NL
    block
    done
  end


  def bracelet
    subnode 'brace' => token('(')
    algebra
    subnode 'brace' => token(')')
  end

  def operator
    tokens operators
  end

  # Strange method
  def eval_string x #hackety hack for non-tree mode
    return nil if not x
    return x.to_path if x.is_a? File
    return x if x.is_a? String and x.index('/') #file, not regex!  ... notodo ...  x.match(/^\/.*[^\/]$/)
    # x=x.join(" ") if x.is_a? Array
    return x[0] if x.is_a? Array and x.count==1
    return x if x.is_a? Array
    # return x.to_s if x.is_a? Array
    do_evaluate x rescue x
  end

  def algebra
    must_contain_before [be_words, ',', ';', ':'], operators
    result=value? or bracelet # any { maybe { value } or maybe { bracelet } }
    star {
      op=operator #operator KEYWORD!?! ==> @string="" BUG     4 and 5 == TROUBLE!!!
      no_rollback! if not op=='and'
      # @string=""+@string2 #==> @string="" BUG WHY??
      y=maybe { value } || bracelet
      if check_interpret #and not $use_tree
        y=y.to_f if op == "/" # 3/4==0 ? NOT WITH US!!
        result=do_send(result, op, y) rescue SyntaxError
      end
      result||true # star OK
    }
    return parent_node if $use_tree and not check_interpret
    if @interpret
      @result=result
      tree   =parent_node
      @result=tree.eval_node @variableValues, result if tree and $use_tree rescue result #wasteful!!
    end
    @result
  end

  def current_context
    @context #todo: tree / per node
  end

  # def javascript
  #   script_block?
  #   __ current_context=='javascript' ? 'script' : 'java script', 'javascript', 'js'
  #   no_rollback! 10
  #   @javascript+=rest_of_line+';'
  #   newline?
  #   return @javascript
  #   #block and done if not @javascript
  # end

  def read_block type=nil
    block=[]
    start_block type
    while true do
      break if end_block? type
      block<<rest_of_line
    end
    subnode type||:block => block
  end


  def html_block
    read_block 'html'
  end


  def javascript_block
    block=maybe { read_block('script') } || maybe { read_block('js') } || read_block('javascript')
    @javascript << block.join(";\n")
  end


  def ruby_block
    read_block 'ruby'
  end

  def special_blocks
    html_block? || ruby_block? || javascript_block
  end

  # see read_block for RAW blocks! (</EOF> type)
  # EXCLUDING start_block & end_block !!!
  def block
    start=pointer
    s    =statement
    star {
      newlines
      s2=statement
      s||=s2
    }
    newline? # danger might act as block end!

    return s if check_interpret
    content=pointer-start
    return content if not $use_tree
    # @current_node.content=parent_node.content=content if $use_tree
    return parent_node if $use_tree
    # @current_node.content=content_between startPointer, endPointer
    # return (pointer-start).map &:stripNewline if not $use_tree
  end


  #direct_token: WITH space!
  def token t
    return tokens t if t.is_a? Array
    # encoding: utf-8
    #return nil if checkEnd
    # t=t[0] if t.is_a? Array #HOW TH ?? method_missing
    @string.strip!
    comment_block if @string.start_with? '/*'
    raiseEnd
    if starts_with? t
      @current_value=t.strip
      @string       =@string[t.length..-1]
      if /^\w/.match(@string) and /^\w/.match(t)
        raise NotMatching.new(t+" (strings needs whitespace, special chars don't)")
      else
        @string.strip!
        return @current_value
      end
    else
      verbose 'expected '+t.to_s # if @throwing
      raise NotMatching.new(t)
    end
  end

  def tokens *tokenz
    # encoding: utf-8
    raiseEnd
    comment_block if @string.starts_with? '/*'
    string=@string.strip+' '
    for t in tokenz.flatten
      # next if t.is_a Variable
      next if t=='' # todo debug HOW
      return true if (t=="\n" and @string.empty?)
      if t.match(/^\w/)
        match=string.match(/^\s*#{t}/im)
        next if match and match.post_match.match /^\w/ # next must be space or so!
      else #special char
        match=string.match(/^\s*#{escape_token t}/im)
      end
      if match
        x       =@current_value=t
        @string =match.post_match.strip
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
    string=@string+' ' # todo: as regex?
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

  def nth_item # Also redundant with property evaluation (But okay as a shortcut)
    n=__ numbers+['first', 'last', 'middle']
    _? '.'
    __ ['word', 'item', 'element', 'object'] # noun
    __ ['in', 'of']
    l      =list?||quote
    @result=l.item(n) # -1 AppleScript style !!! BUT list[0] !!!
    return @result
  end

  def listSelector
    return nth_item? || functionalSelector
  end

  # DANGER: INTERFERES WITH LIST?, NAH, NO COMMA: {x > 3}
  def functionalSelector
    _ '{'
    xs  =true_variable
    crit=selector
    _ '}'
    filter(xs, crit)
  end

  def list
    raise NotMatching.new if @string[0]==','
    must_contain_before [be_words, operators-['and']], ',' #,before:
    # +[' '] ???
    start_brace= maybe { token '[' }
    start_brace= _? '{' if not start_brace
    raise NotMatching.new 'not a deep list' if not start_brace and (@inside_list)
    @inside_list=true
    all         =[]
    #all<<expression(start_brace)
    # $verbose=true #debug
    all<<endNode
    star {
      tokens(',', 'and') # danger: and as plus! BAD IDEA!!!
      all<<endNode
      #all<<expression
    }
    @inside_list=false
    _ ']' if start_brace=='['
    _ '}' if start_brace=='{'
    @current_value=all
    all
  end

  def minusMinus
    must_contain '--'
    v=variable
    _ '--'
    @result           =do_evaluate(v,v.type)+1 if @interpret
    @variableValues[v]=v.value=@result
  end

  def plusPlus
    must_contain '++'
    v=variable
    _ '++'
    return parent_node if not @interpret
    @result                =do_evaluate(v,v.type)+1
    @variableValues[v.name]=v.value=@result
  end

  def selfModify
    maybe { plusEqual } ||maybe { plusPlus } || minusMinus
  end

  def plusEqual
    must_contain '|=', '&=', '&&=', '||=', '+=', '-=', '/=', '^=', '%=', '#=', '*=', '**=', '<<', '>>'
    v  =variable
    mod=__ '|=', '&=', '&&=', '||=', '+=', '-=', '/=', '^=', '%=', '#=', '*=', '**=', '<<', '>>'
    val=v.value
    exp=expressions # value
    arg=do_evaluate(exp,v.type)
    return parent_node if not check_interpret
    @result                =val|arg if mod=='|='
    @result                =val||arg if mod=='||='
    @result                =val&arg if mod=='&='
    @result                =val&&arg if mod=='&&='
    @result                =val+arg if mod=='+='
    @result                =val-arg if mod=='-='
    @result                =val*arg if mod=='*='
    @result                =val**arg if mod=='**='
    @result                =val/arg if mod=='/='
    @result                =val%arg if mod=='/='
    @result                =val<<arg if mod=='<<'
    @result                =val>>arg if mod=='>>'
    @variableValues[v.name]=@result
    v.value                =@result
  end

  def swift_hash
    _ '['
    h={}
    star {
      _ ',' if h.length>0 # not h.blank?
      __? '"', "'" # optional quotes
      key=word
      __? '"', "'"
      _ ':'
      @inside_list       =true
      # h[key] = expression0 # no
      h[key.to_s.to_sym] = expressions # no
    }
    _ ']'
    @inside_list=false
    h
  end

  def close_bracket #for nice GivingUp
    _ '}'
  end

  def json_hash
    must_contain ":", "=>", before: "}"
    regular_json_hash? or immediate_json_hash
  end

  # colon for types not Compatible? puts a:int vs puts {a:int} ? maybe egal
  # careful with blocks!! {puts "s"} VS {a:"s"}
  def regular_json_hash
    _ '{'
    _? ':' and no_rollback! #{:a...} Could also mean list of symbols? Nah
    h={}
    star {
      _? ';' or _ ',' if h.length>0 # not h.blank?
      quoted=__? '"', "'" # optional
      key   =word
      __ '"', "'" if quoted
      _? '=>' or _? '=' or #  todo a{b=c} vs a{b:c} Property versus hash !!
          starts_with?("{") or _? '=>' or _ ':'
      @inside_list       =true
      # h[key] = expression0 # no
      h[key.to_s.to_sym] = expressions # no
    }
    # no_rollback!
    close_bracket
    @inside_list=false
    h
  end

  # expensive?
  # careful with blocks/closures ! map{puts it} VS data{a:"b"}
  def immediate_json_hash # a:{b} OR a{b:c}
    # must_contain_before ":{", ":"
    w=word #expensive
    # starts_with?("={") and _? '=' or # todo set a to {b=>c} vs a:{b:c}
    starts_with?("{") or _? '=>' or _ ':'
    no_rollback!
    r=regular_json_hash
    {w.to_sym => r} # AH! USEFUL FOR NON-symbols !!!
  end

  # keyword expression is reserved by ruby/rails!!! => use hax0r writing or plural
  def expressions fallback=nil
    start=pointer
    ex   =any {#expression}
      maybe { algebra } ||
          maybe { json_hash } ||
          maybe { swift_hash } || # really?
          maybe { evaluate_index } ||
          maybe { listSelector } ||
          maybe { list } ||
          maybe { evaluate_property } ||
          maybe { selfModify } ||
          maybe { endNode }
      # ||['one'].has(fallback) ? 1 : false # WTF todo better quantifier one beer vs one==1
    }
    return pointer-start if not @interpret and not $use_tree
    @result=do_evaluate ex if ex and @interpret rescue SyntaxError
    if @result.blank? or @result==SyntaxError and not ex==SyntaxError
      # keep false
    else
      ex=@result
    end

    # NEIN! print 'hi' etc etc
    # more=expression0? if @result.is_a? Quote
    # more||=quote? #  "bla " 7 " yeah"
    # more+=expression0? if more.is_a? Quote rescue ""
    # ex+=more if more
    # subnode expression: ex
    return @result=ex
  end

  def piped_actions
    return false if @in_pipe
    must_contain "|"
    @in_pipe=true
    a       =statement
    _ '|'
    no_rollback!
    c=true_method or bash_action
    args=star { arg }
    do_send(a, c, args) if check_interpret
  end

  def statement
    raiseNewline
    x=any {#statement}
      return @NEWLINE if checkNewline
      maybe { loops }||
          maybe { if_then_else } ||
          # maybe { if_then } ||
          maybe { once } ||
          maybe { piped_actions } ||
          maybe { action } ||
          maybe { expressions } # AS RETURN VALUE! DANGER!
    }
    x
    #one :action, :if_then ,:once , :looper
    #any{action || if_then || once || looper}
  end

  def method_definition
    # annotations=annotations?
    # modifiers=modifiers?
    tokens method_tokens #  how to
    no_rollback!
    name= noun or verb #  integrate
    obj=maybe { endNode } # a sine wave
    _? '('
    arg_nr=1
    args  =star {
      @in_params=true
      a         =arg(arg_nr)
      arg_nr    =arg_nr+1
      _? ','
      a
    } # over an interval
    return_type=__?('as', 'return', 'returns', 'returning') and typeName?
    return_type||=typeName if _? '->' #_? '!' # swift style --
    @in_params =false
    _? ')'
    allow_rollback # for
    b=action_or_block # define z as 7 allowed !!!
    @methods[name]=parent_node||b rescue nil # with args! only in tree mode!!
    # name
    Function.new name: name, arguments: args, return_type: return_type #,modifiers:modifiers,annotations:annotations
  end

  def ruby_action
    _ 'ruby'
    exec(action || quote)
  end

  def bash_action
    require_relative "bindings/shell/bash-commands"
    must_contain ['bash'] + $bash_commands
    remove_tokens 'execute', 'command', 'commandline', 'run', 'shell', 'shellscript', 'script', 'bash'
    @command = maybe { quote } # danger bash "hi">echo
    @command ||= rest_of_line
    subnode bash: @command
    #any{ try{  } ||  statements }
    if check_interpret
      begin
        puts 'going to execute ' + @command
        result=%x{#{@command}}
        puts 'result:'
        puts result
        return result ? result.split("\n") : true
      rescue
        puts 'error executing bash_action'
      end
    end
    false
  end



  def if_then_else
    ok      =maybe{if_then} #todo : if 1 then false else 2 => 2 :(
    ok      ||=action_if
    ok= :false if ok==false
    o       =otherwise? || :false
    @result = ok!="OK" ? ok : o
  end

  def action_if
    must_contain 'if'
    a=expressions
    _ 'if'
    c=condition_tree
    if check_interpret
      if check_condition c
        return do_execute_block a
      else
        return @OK #false but block ok!
      end
    end
    return a
  end

  def if_then
    __ if_words
    no_rollback! # 100
    c=condition_tree
    raise InternalError.new "no condition_tree" if c==nil
    # c=condition
    _? 'then'
    dont_interpret! #if not c  else dont do_execute_block twice!
    b= expression_or_block #action_or_block
    # o=otherwise?
    # b=block if use_block # interferes with @comp/condition
    # b=statement if not use_block
    # b=action if not use_block
    if check_interpret
      if check_condition c
        return do_execute_block b
      else
        return @OK #  o|| false but block ok!
      end
    end
    return b
  end

  def once_trigger
    __ once_words
    dont_interpret!
    c=condition
    no_rollback!
    _? 'then'
    use_block=start_block?
    b=action and end_expression if not use_block
    b=block and done if use_block
    add_trigger c, b
  end

  def action_once
    must_contain once_words # if not _do and newline
    _do=_? 'do'
    dont_interpret!
    b=action if not _do
    b=block and done? if _do
    __ once_words
    c=condition
    end_expression
    add_trigger c, b
  end


  def once
#	|| 'as soon as' condition \n block 'ok'
#	|| 'as soon as' condition 'then' action;
    maybe { once_trigger } || action_once
#	|| action 'as soon as' condition
  end

#/*n_times
#	 verb number 'times' preposition nod -> "<verb> <preposition> <nod> for <number> times" 	*/
#/*	 verb number 'times' preposition nod -> ^(number times (verb preposition nod)) # Tree ~= lisp	*/
  def verb_node
    v=verb
    nod
    raise UnknownCommandError.new 'no such method: '+v if !@methods.contains(v)
    return v
    #end_expression
  end

  def spo
    # NotImplementedError
    return false if not $use_wordnet
    raise NotMatching.new("$use_wordnet==false") if not $use_wordnet
    s=endNoun
    p=verb
    o=nod
    return do_send(s, p, o) if @interpret
  end

  def substitute_variables args
    #args=" "+args+" "
    for variable in @variableValues.keys
      variable=variable.join(' ') if variable.is_a? Array #HOW!?!?!
      value   =@variableValues[variable]||'nil'
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


  # todo : why special? direct eval, rest_of_line
  def ruby_method_call
    call=tokens? 'call', 'execute', 'run', 'start', 'evaluate', 'invoke'
    no_rollback! if call # remove later
    ruby_method=tokens? @ruby_methods
    raise UndefinedRubyMethod.new word if not ruby_method
    args=rest_of_line
    # args=substitute_variables rest_of_line
    if check_interpret
      begin
        the_call       =ruby_method+' '+args.to_s
        print_variables=@variableValues.inject("") { |s, v| "#{v[0]}=#{v[1].is_a(String) ? '"'+v[1]+'"' : v[1]};"+s }
        @result        =eval(print_variables+ the_call)||''
        verbose the_call+'  called successfully with result '+@result.to_s
        return result
      rescue SyntaxError => e
        puts "\n!!!!!!!!!!!!\n ERROR calling #{the_call}\n!!!!!!!!!!!! #{e}\n "
      rescue => e
        puts "\n!!!!!!!!!!!!\n ERROR calling #{the_call}\n!!!!!!!!!!!! #{e}\n "
        error $!
        puts '!!!! ERROR calling '+the_call
      end
    end
    checkNewline
    #raiseEnd
    subnode method: ruby_method #why not auto??
    subnode args: args
    return @current_value=ruby_method
    # return Object.method ruby_method.to_sym
    # return Method_call.new ruby_method,args,:ruby
  end

  def is_object_method m
    object_method = Object.method(m) if Object.method_defined?(m) rescue false
    if object_method
      return object_method
    end
    return false
  end

  # Object.constants  :IO, :STDIN, :STDOUT, :STDERR ...:Complex, :RUBY_VERSION ...
  def has_object m
    object_method = Object.method(m) rescue false
    if object_method # Bad approach:  that might be another method Tree.beep!
      method=Object.method(m) # todo: find OTHER! not just Object.
      # return method # false:  if Object has method assume no object has method BAAAD!!!!
      return false
    end
    return true
  end

  def has_args m, clazz=Object
    clazz         =clazz.class if not clazz.is_a? Class #lol
    object_method = clazz.method(m) if clazz.method_defined?(m) rescue false
    object_method = clazz.public_instance_method(m) if not object_method rescue false
    if object_method # Bad approach:  that might be another method Tree.beep!
      # puts "has_args method.parameters : #{object_method} #{object_method.parameters}"
      #todo MATCH!   [[:req, :x]] -> required: x
      return object_method.arity>0
    end
    return true
  end

  def c_method
    tokens @c_methods
  end

  def builtin_method
    w=word
    m=Object.method(w) rescue nil
    m||=HelperMethods.method(w) rescue nil
    m
    # m ? m.name : nil
  end

  def true_method
    no_keyword
    should_not_match auxiliary_verbs
    v=c_method? || verb? || tokens?(@methods.keys) || builtin_method?
    raise NotMatching.new 'no method found' if not v
    v #.to_s
  end

  def strange_eval obj
    _? '('
    args=star { arg }
    _ ')'
    @result=eval_string("#{obj}(#{args})")
    @result
  end

  def thing_dot_method_call
    must_contain_before ['='], '.' # before...?
    obj=endNode
    return strange_eval obj if _? '(' and check_interpret
    _ '.'
    method_call obj
  end

  # read mail or bla(1) or a.bla(1)  vs ruby_method_call !!
  def method_call obj=nil
    #verb_node
    method=true_method
    brace =_? '('
    no_rollback! if brace
    if is_object_method(method) #todo !has_object(method) is_class_method
      obj||=Object
    else
      obj=maybe { nod || list } # todo: expression
    end
    if has_args(method, obj)
      @current_value=nil
      args          =star { arg }
    end
    _ ')' if brace
    subnode object: obj
    subnode arguments: args
    return FunctionCall.new name: method, arguments: args, object: obj if not check_interpret #parent node!!!
    @result=do_send(obj, method, args)
    return @result
  end

  def bla
    tokens? bla_words
  end

  def applescript
    tokens 'tell application', 'tell app'
    app    =quote
    to     = _? 'to'
    @result="tell application \"#{app}\""
    @result+= ' to '+ @string if to
    if not to #Multiline
      while @string and not @string.contains 'end tell'
        # #TODO deep blocks! simple 'end' : and not @string.contains 'end'
        @result+= rest_of_line() +"\n"
      end
      # tokens? "end tell","end"
      @result+=rest_of_line() # "end tell"
    end
    # -s o /path/to/the/script.scpt
    @current_value = %x{/usr/bin/osascript -ss -e $'#{@result}'} if @interpret
    return @result
  end

  def assert_that
    _ 'assert'
    _? 'that'
    what   =rest_of_line
    @result=assert what
  end

#	||'say' x=(.*) -> 'bash "say $quote"'
  def action
    start=pointer
    bla?
    result=any {#action
      maybe { special_blocks } ||
          maybe { applescript } ||
          maybe { bash_action } ||
          maybe { setter } ||
          maybe { ruby_method_call } ||
          maybe { selfModify } ||
          maybe { thing_dot_method_call } ||
          maybe { method_call } ||
          maybe { evaluate } ||
          maybe { spo }
      #try { verb_node } ||
      #try { verb }
    }
    raise NoResult.new if not result
    ende=pointer
    # newline? #cut rest, BUT:
    return ende-start if not $use_tree and not @interpret
    return result
  end


  def action_or_block # expression_or_block ??
    # dont_interpret  # always?
    a=maybe { action }
    return a if a
    start_block
    b=block if not a
    end_block
    return b
  end

  def expression_or_block # action_or_block
    # dont_interpret  # always?
    a=maybe { action }||maybe { expressions }
    return a if a
    start_block
    b=block if not a
    end_block
    return b
  end

  def end_block type=nil
    done type
  end

  def done type=nil
    return @OK if type and close_tag? type
    return @OK if checkNewline
    ok=tokens done_words
    token type if type #optional?
    ignore_rest_of_line
    ok
  end

# used by done / end_block
  def close_tag type
    _ '</'
    _ type
    _ '>'
  end

  def call_function f
    do_send f.object, f.name, f.arguments
  end


  def do_execute_block b, args={}
    return false if not b
    return call_function b if b.is_a? FunctionCall
    b=b.content if b.is_a? TreeNode
    return b if not b.is_a? String # OR ... !!!
    block_parser               =EnglishParser.new
    block_parser.variables     =@variables
    block_parser.variableValues=@variableValues
    # block_parser.variables+=args
    begin
      @result                    =block_parser.parse(b.join("\n")).result
    rescue
      error $!
    end
    @variableValues            =block_parser.variableValues
    @result
    #do_evaluate b
  end

  def datetime
    # Complicated stuff!
    # later: 5 secs from now  , _ 5pm == AT 5pm
    must_contain time_words
    _kind = tokens event_kinds
    no_rollback!
    __? 'around', 'about'
    # require 'chronic_duration'
    # WAH! every second  VS  every second hour WTF ! lol
    n    =number? || 1 # every [1] second
    _to  = maybe { tokens 'to', 'and' }
    _to  =number if _to
    _unit=__ time_words # +["am"]
    _to  ||= __? 'to', 'and'
    _to  ||=number? if _to
    return Interval.new(_kind, n, _to, _unit)
  end

  def collection
    any {#collection }
      maybe { range } ||
          maybe { variable }
    }
  end


  def for_i_in_collection
    _? 'repeat'
    __('for', 'with')
    _? 'all'
    v=variable # selector !
    __('in', 'from')
    c=collection
    b=action_or_block
    for i in c
      do_execute_block b
    end if check_interpret
  end


  # todo vs checkNewline ??
  def end_expression
    checkEnd?||newline
  end

#  until_condition ,:while_condition ,:as_long_condition

  def assure_same_type_overwrite var, val
    oldType=var.type
    raise WrongType.new if not val.type.is_a oldType
    raise ImmutableVaribale.new if var.final and var.value and not val.value==var.value
    var.value=val
  end

  def boolean
    b      =tokens 'true', 'false'
    @result=b=='true'
    # @OK
  end

#  CAREFUL WITH WATCHES!!! THEY manipulate the current system, especially variable
#/*	 let nod be nods */
  def setter
    must_contain_before ['>', '<', '+', '-', '|', '/', '*'], be_words+['set']
    _let=no_rollback! if let?
    a   =the?
    mod =modifier?
    tokens? 'var', 'val', 'value of'
    mod  ||=modifier? # public static ...
    old  =@string
    var  =variable a
    # _?("always") => pointer
    setta=_?('to') || be # or not_to_be 	contain -> add or create
    val  =adjective? || expressions
    no_rollback!
    val=[val].flatten if setta=='are' or setta=='consist of' or setta=='consists of'
    assure_same_type_overwrite var, val if _let
    var.type||=val.class #eval'ed! also x is an integer
    if not @variableValues.contains(var.name) or mod!='default' and @interpret
      @variableValues[var.name] =val
    end
    var.value    =val
    var.final    =const.contains(mod)
    var.modifier =mod
    @result      =val
    # end_expression via statement!
    # return var if @interpret

    return val if @interpret
    return var
    # return parent_node if $use_tree
    # return old-@string if not @interpret # for repeatable, BAD
    # ||'to'
    #'initial'?	let? the? ('initial'||'var'||'val'||'value of')? variable (be||'to') value
  end

# a=7
# a dog=7
# Int dog=7
# my dog=7
# a green dog=7
# an integer i
  def variable a=nil
    a  ||=article?
    a  =nil if a!='a' #hack for a variable
    typ=typeName?
    p  =__? possessive_pronouns
    all=p ? [p] : []
    all+=one_or_more { word } rescue (a=='a' ? all=[a] : (raise NotMatching))
    name=typ||all.length==1 ? all.join(' ') : all[1..-1].join(' ')
    if (typ||all.length>1) # todo UNHACK ^^
      @variableTypes[name]=typ||all[0]
    end
    # {variable:{name:name,type:typ,scope:@current_node,module:current_context}}
    return @variables[name] if @variables[name]
    @result         =Variable.new name: name, type: typ, scope: @current_node, module: current_context
    @variables[name]=@result
  end

  def word include=[]
    #danger:greedy!!!
    no_keyword_except include
    raiseNewline
    #raise EndOfDocument.new if @string.blank?
    #return false if starts_with? keywords
    match=@string.match(/^\s*[a-zA-Z]+[\w_]*/)
    if (match)
      @string       =@string[match[0].length..-1].strip
      @current_value=match[0].strip
      return match[0]
    end
    #fad35
    #unknown
    # noun
  end

  def should_not_match words
    bad=starts_with? words
    raise ShouldNotMatchKeyword.new bad if bad
    return @OK
  end

  def no_keyword_except except=[]
    should_not_match keywords-except
  end

  def no_keyword
    no_keyword_except []
  end

  def constant
    tokens constants
  end

  def it
    __ result_words
    return @result
  end

  def value
    @current_value=nil
    no_keyword_except constants+numbers+result_words+nill_words
    @result=@current_value=x=any {
      maybe { quote }||
          maybe { nill } ||
          maybe { number } ||
          maybe { true_variable } ||
          maybe { boolean }||
          maybe { constant }||
          maybe { it }||
          maybe { nod }
      #rest_of_line # TOOBIG HERE!
    }
    x
  end


  def nod #options{generateAmbigWarnings=false}
    maybe { number } ||
        maybe { quote } ||
        maybe { true_variable } ||
        maybe { the_noun_that } #||
    #try { variables_that } # see selectable
  end

  def article
    tokens articles
  end

  def arg position=1 # about sex
    pre=preposition? ||"" #  might be superfluous if calling "BY"
    article? #todo use a vs the ?
    a=variable?
    return Argument.new name: a.name, type: a.type, preposition: pre, position: position if a
    type=typeName?
    v   =endNode
    name=pre+ (a ? a.name : "")
    Argument.new name: name, type: type, preposition: pre, position: position, value: v
  end


# BAD after filter, ie numbers [ > 7 ]
# that_are bigger 8
# whose z are nonzero
  def compareNode
    c=comparison
    raise NotMatching.new "NO comparison" if not c
    raise NotMatching.new 'compareNode = not allowed' if c=='=' #todo
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
    __ 'more', 'less', 'equally' # comparison_words
    adverb
  end


  def as_adverb_as
    _ 'as'
    adverb
    _ 'as'
  end

# 50% more
# "our burgers have more flavor",
# "our picture is sharper"
# "our picture runs sharper"
  def null_comparative
    verb
    comparative
    endNode?
    return c if c.start_with? 'more' or c.ends_with? 'er'
  end

#  faster than ever
#  more funny than the funny cat
  def than_comparative
    comparative
    _ 'than'
    adverb? || endNode
  end


  def comparative
    c=more_comparative? or adverb
    @comp=c if c.start_with? 'more' or c.ends_with? 'er'
  end


  def that_are
    __ 'that', 'which', 'who'
    be
    maybe { compareNode }|| # bigger than live
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
      maybe { that_do } ||
          maybe { that_are }||
          maybe { whose }
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
      maybe { compareNode }||
          maybe { where }|| # sql style
          maybe { that } || # friends that live in africa
          maybe { token('of') and endNode }|| # friends of africa
          maybe { preposition and nod } # friends in africa
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
    @comp=maybe { verb_comparison }|| # run like , contains
        maybe { comparation } # are bigger than
  end


# is more or less
# is neither ... nor ...
# Comparison phrase
  def comparation
    # danger: is, is_a
    start=pointer
    eq=tokens? be_words
    tokens? 'either', 'neither'
    @not=tokens? 'not'
    maybe { adverb } #'quite','nearly','almost','definitely','by any means','without a doubt'
    if (eq) # is (equal) optional
      comp=tokens? comparison_words
    else
      comp=tokens comparison_words
      no_rollback!
    end
    _? 'to' if eq
    tokens? 'and', 'or', 'xor', 'nor'
    tokens? comparison_words # bigger or equal  != SEE condition_tree
    _? 'than', 'then' #_?'then' ;}
    subnode comparation: pointer-start
    @result=@comp=pointer-start #comp||eq
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
    comparison_words.contains(c) || class_words.contains(c)
  end


  def check_list_condition quantifier
    # return true if not @a.is_a?Array # every one is evil
    # see quantifiers
    begin
      count=0
      for item in @a
        @result=do_compare(item, @comp, @b) if is_comparator @comp
        @result=do_send(item, @comp, @b) if not is_comparator @comp
        break if !@result and ['all', 'each', 'every', 'everything', 'the whole'].matches quantifier
        break if @result and ['either', 'one', 'some', 'few', 'any'].contains quantifier
        if @result and ['no', 'not', 'none', 'nothing'].contains quantifier
          @not=!@not
          break
        end
        count=count+1 if @result # "many", "most" : continue count
      end

      min    =@a.length/2
      @result=count>min if quantifier=='most'||quantifier=='many'
      @result=count>=1 if quantifier=='at least one'
      # todo "at least two","at most two","more than 3","less than 8","all but 8"
      @result=!@result if @not
      if not @result
        verbose "condition not met #{@a} #{@comp} #{@b}"
      end
      return @result
    rescue => e
      #debug x #soft message
      error e #exit!
    end

    return false
  end

  def check_condition cond=nil, negate=false #later:node?
    return true if cond==true #EVALUATED BEFORE!!!
    return false if cond==false #EVALUATED BEFORE!!!
    begin
      # else use state variables todo better!
      if cond.is_a? TreeNode
        @a   =cond[:expressions]
        @b   =cond.all(:expressions).reject { |x| x==false }[-1]
        @comp=cond[:comparation]
      end
      c=@comp
      result=do_compare(@a, @comp, @b) if is_comparator @comp
      result=do_send(@a, @comp, @b) if not is_comparator @comp
      # if !result and not cond.blank? #HAAACK DANGARRR
      #   #@a,@comp,@b= extract_condition c if c
      #   evals=''
      #   @variables.each { |var, val| evals+= "#{var}=#{val};" }
      #   result=eval(evals+cond.join(' ')) #dont set @result here (i.e. while(...)last_result )
      # end
      result=!result if @not
      result=!result if negate # XOR result=result ^ negate
      if not result
        verbose "condition not met #{cond} #{@a} #{@comp} #{@b}"
      end
      return result
    rescue => e
      #debug x #soft message
      error e #exit!
    end
    return false
  end

  def condition
    start     =pointer
    brace     =_? '('
    negated   =_? 'not'
    brace     ||=_? '(' if negated
    # @a=endNode # NO LISTS (YET)! :(
    quantifier=maybe { tokens quantifiers } # vs selector!
    # __? noun _? "in" all even numbers in [1,2,3,4] -> selector!
    _? 'of' if quantifier # all of
    @a   =expressions quantifier
    @not =false
    @comp=use_verb=maybe { verb_comparison } # run like , contains
    @comp=maybe { comparation } unless use_verb # are bigger than
    allow_rollback # upto where??
    @b   =expressions #if @comp
    # @b=endNode
    _ ')' if brace
    negate = (negated||@not)&& !(negated and @not)
    subnode negate: negate
    # return  negate ? !@a : @a if not @comp
    if @interpret
      return negate ? (!check_list_condition(quantifier)) : check_list_condition(quantifier) if quantifier
      return negate ? (!check_condition) : check_condition # nil
    end
    return start-pointer if not $use_tree
    return parent_node if $use_tree
  end


  def condition_tree recurse=true
    brace=_? '('
    _? 'either' # todo don't match 'either of'!!!
    # negate=_? "neither"
    c=condition_tree false if brace and recurse
    c=condition if not brace
    star {
      op=__ 'and', 'or', 'nor', 'xor', 'nand', 'but'
      c2=condition_tree false if recurse
      return @current_node if not check_interpret # or $use_tree
      c||= c2 if op=='or'
      #NIL c = c or c2 if op=='or' RUBY BUG!?!?!
      # c =c and c2 if op=='and' || op=='but'
      c&&= c2 if op=='and' || op=='but'
      c&&= !c2 if op=='nor'
      return c||false
    }
    _ ')' if brace
    c
  end

  def otherwise
    newline?
    must_contain 'else', 'otherwise'
    __? 'else', 'otherwise'
    # else if ... ! OK?
    e=expressions
    __? 'else', 'otherwise' and newline
    e
  end

# todo  I hate to ...
  def loveHateTo
    _? 'would', "wouldn't"
    __? 'do', 'not', "don't"
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
    pr     =tokens? prepositions # wrapped in
    endNode? if pr # silver
    @current_value=match[1]
    @current_value
  end

  def postjective # 4 squared , 'bla' inverted, buttons pushed in, mail read by James
    match=@string.match(/^\s*(\w+)ed/)
    return false if not match
    @string=match.post_match
    pr     =tokens? prepositions if not checkEnd # wrapped in
    endNode? if pr and not checkEnd # silver
    @current_value=match[1]
    @current_value
  end

  # see resolve ???
  def do_evaluate x,type=nil #  #WHAT, WHY?
    return x if not check_interpret
    begin
      return x.value || @variableValues[x.name] if x.is_a? Variable
      return x.to_f if x.is_a? String and type and type.is_a?Numeric
      return @variableValues[x] if @variableValues.contains x
      return x if x.is_a? Quote #why not just String???
      return x if x.is_a? Class
      return x if x.is_a? Hash
      return x.to_f if x.is_a? String and type and type.is_a?Fixnum
      return x if x.is_a? Numeric
      return x if x.is_a? String
      return eval(x[0]) if x.is_a? Array and x.length==1
      return x if x.is_a? Array and x.length!=1
      return x.eval_node @variableValues if x.is_a? TreeNode
      return resolve x if x.is_a? String and match_path(x)
      return x.call if x.is_a? Method #Whoot
      return eval(x) # rescue x # system.jpg  DANGER? OK ^^
        # ... todo METHOD / Function!
    rescue TypeError, SyntaxError => e
      puts "ERROR #{e} in do_evaluate #{x}"
      return x
    end
  end

  # see do_evaluate ! merge
  def resolve x
    return Dir.new x if is_dir x
    return File.new x if is_file x
    return x.value if x.is_a? Variable
    return @variableValues[x] if @interpret and @variableValues[x]
    x
  end

  def do_evaluate_property x, y
    # todo: REFLECTION / eval NODE !@!!
    return false if x.nil?
    verbose 'do_evaluate_property '+x.to_s+' '+y.to_s
    @result=nil #delete old!
    x      ='class' if x=='type' # !@!@*)($&@) NOO
    x      =x.value_string if x.is_a? TreeNode
    return @result=do_send(y, x, nil) rescue nil #try 1
    return @result=eval(y+'.'+x) rescue nil #try 1
    x=x.join(' ') if x.is_a? Array
    return @result=eval(y+'.'+x) rescue nil #try 2
    y=y.to_s #if y.is_a? Array
    return @result=eval(y+'.'+x) rescue nil #try 3
    all=x.to_s+' of '+y.to_s
    x  =x.gsub(' ', ' :')
    begin
      @result=eval(y+'.'+x) rescue nil
      @result=eval("'"+y+"'."+x) if not @result rescue SyntaxError #string method
      #@result=eval('"'+y+'".'+x) if not @result  rescue SyntaxError #string method
      @result=eval(all) if not @result rescue SyntaxError
    end
    @result
  end

  def self.self_modifying method
    method=='increase' || method=='decrease' || method.match(/\!$/)
  end

#
  def self_modifying method
    EnglishParser.self_modifying method # -lol
  end

# INTERPRET only,  todo cleanup method + argument matching + concept
  def do_send obj0, method, args0
    return false if not method
    # try direct first!
    # y=y[0] if y.is_a? Array and y.count==1 # SURE??????? ["noo"].length
    if @methods.contains method
      return do_execute_block @methods[method], args
    end

    obj =resolve(obj0) rescue obj0
    args=args0
    args=args.name_or_value if args.is_a? Argument
    args=args.map &:name_or_value if args.is_a? Array and args[0].is_a? Argument
    args=eval_string(args) rescue NoMethodError
    args.replace_numerals! if args and args.is_a? String

    method=method.name.to_s if method.is_a? Method #todo bettter
    if obj.respond_to? method
      # OK
    elsif  obj.respond_to? method+'s'
      method=method+'s'
    elsif  obj.respond_to? method.gsub(/s$/, '')
      method=method.gsub(/s$/, '')
    end

    if not obj
      obj=args0
      @result=Object.send(method, args) rescue NoMethodError #.new("#{obj}.#{op}")
      @result=args.send(method) rescue NoMethodError #.new("#{obj}.#{op}")
      @result=args[1].send(method) if has_args method, obj if (args[0]=='of') rescue NoMethodError #rest of x
    else
      @result=obj.send(method) if not has_args method, obj rescue NoMethodError #.new("#{obj}.#{op}") #SyntaxError,
      @result=obj.send(method, args) if has_args method, obj rescue NoMethodError #SyntaxError,
    end
    #todo: call FUNCTIONS!
    # puts object_method.parameters #todo MATCH!

    # => selfModify todo
    if obj0||args and self_modifying method
      name                  =(obj0||args).to_sym.to_s #
      @variables[name].value=@result #rescue nil
      @variableValues[name] =@result
    end rescue nil

    puts "ERROR CALLING #{obj}.#{method}(#{args}) : NoMethodError" if not @result
    # raise SyntaxError.new("ERROR CALLING #{obj}.#{op}(#{args}) : NoMethodError")
    return @result
  end

  def do_compare a, comp, b
    a=eval_string(a) # NOT: "a=3; 'a' is 3" !!!!!!!!!!!!!!!!!!!!   Todo ooooooo!!
    b=eval_string(b)
    a=a.to_f if b.is_a? Numeric
    b=b.to_f if a.is_a? Numeric
    if comp=='smaller'||comp=='tinier'||comp=='comes before'||comp=='<'
      return a<b
    elsif comp=='bigger'||comp=='larger'||comp=='comes after'||comp=='>'
      return a>b
    elsif class_words.index comp or comp.match(/same/)
      return a.is_a b
    elsif be_words.index comp or comp.match(/same/)
      return a.is b
    else
      begin
        return a.send(comp, b) # raises!
      rescue
        error('ERROR COMPARING '+ a.to_s+' '+comp.to_s+' '+b.to_s)
        return a.send(comp+'?', b)
      end
    end
  end

  def filter liste, criterion
    return liste if not criterion
    list=eval_string(liste)
    list=get_iterator(list) if not list.is_a? Array
    if $use_tree
      method=criterion[:comparative]||criterion[:comparison]||criterion[:adjective]
      args  =criterion[:endNode]||criterion[:endNoun]||criterion[:expressions]
    else
      method=@comp
      args  =criterion
    end
    list.select { |i|
      do_compare(i, method, args) rescue false #REPORT BUGS!!!
    }
  end

  def selectable
    must_contain 'that', 'whose', 'which'
    tokens? 'every', 'all', 'those'
    xs=maybe { endNoun } || true_variable
    s =maybe { selector }
    x =filter(xs, s) if @interpret rescue xs
    x
  end

  def range
    return false if @in_params
    must_contain 'to'
    _? 'from'
    a=number
    _ 'to'
    b=number
    a..b # (a..b).to_a
  end

# # || endNode have adjective || endNode attribute || endNode verbTo verb #||endNode auxiliary gerundium
  def endNode
    raiseEnd
    x=any {# NODE }
      #try { plural} ||
      maybe { rubyThing } ||
          maybe { fileName } ||
          maybe { linuxPath } ||
          maybe { quote } || #redundant with value !
          maybe { evaluate_property }||
          maybe { selectable } ||
          maybe { true_variable } ||
          maybe { article?; word } ||
          maybe { article?; typeName } ||
          maybe { range } || # not params!
          maybe { value } ||
          maybe { list } ||
          maybe { token 'a' } # variable 'a' not as article DANGER!
    }

    po=maybe { postjective } # inverted
    if po and @interpret
      x=@current_value=x.send(po) rescue x #DANGAR!!
    end

    x
  end


  def endNoun include=[]
    article?
    adjs=star { adjective } #  first second ... included
    obj =maybe { noun include }
    if not obj
      if adjs and adjs.join(' ').is_noun # KIND as adjective or noun??
        return adjs.join(' ')
      else
        raise NotMatching.new 'no endNoun'
      end
    end
    return obj if $use_tree # parent_node
    #return adjs.to_s+" "+obj.to_s # hmmm  hmmm   hmmm  W.T.F.!!!!!!!!!!!!!?????
    adjs=' ' + adjs.join(' ') if adjs and adjs.is_a? Array
    return obj.to_s + adjs.to_s # hmmm hmmm   hmmm  W.T.F.!!!!!!!!!!!!!????? ( == todo )
  end

  def any_ruby_line
    line   =@string
    @string=@string.gsub(/.*/, '')
    checkNewline
    line
  end

  def start_block type=nil
    if type
      xmls=_? '<'
      _ type
      _ '>' if xmls
    end
    return @OK if checkNewline
    maybe { tokens ':', 'do', '{', 'first you ', 'second you ', 'then you ', 'finally you ' }
  end


  def english_to_math s
    s.replace_numerals!
    s.gsub!(' plus ', '+')
    s.gsub!(' minus ', '-')

    s.gsub!(/(\d+) multiply (\d+)/, "\\1 * \\2")
    s.gsub!(/multiply (\d+) with (\d+)/, "\\1 * \\2")
    s.gsub!(/multiply (\d+) by (\d+)/, "\\1 * \\2")
    s.gsub!(/multiply (\d+) and (\d+)/, "\\1 * \\2")
    s.gsub!(/divide (\d+) with (\d+)/, "\\1 / \\2")
    s.gsub!(/divide (\d+) by (\d+)/, "\\1 / \\2")
    s.gsub!(/divide (\d+) and (\d+)/, "\\1 / \\2")
    s.gsub!(' multiplied by ', '*')
    s.gsub!(' times ', '*')
    s.gsub!(' divided by ', '/')
    s.gsub!(' divided ', '/')
    s.gsub!(' with ', '*')
    s.gsub!(' by ', '*')
    s.gsub!(' and ', '+')
    s.gsub!(' multiply ', '*')
    return s
  end

  def evaluate_index
    must_contain '[', ']'
    v=endNode # true_variable
    _ '['
    i=endNode
    _ ']'
    set    =_? '='
    set    =expressions if set
    # @result=v.send :index,i if check_interpret
    @result=v.send :[], i if check_interpret #old value
    @result=v.send :[]=, i, set if set and check_interpret
    # @result=do_evaluate "#{v}[#{i}]" if check_interpret
    @result
  end

  def evaluate_property
    _? 'all' # list properties (all files in x)
    must_contain_before '(', ['of', 'in', '.']
    raiseNewline
    x=endNoun type_keywords
    __ 'of', 'in'
    y=expressions
    return parent_node if not @interpret
    begin #interpret !:
      do_evaluate_property(x, y)
    rescue SyntaxError => e
      verbose 'ERROR do_evaluate_property'
        #@result=jeannie all if not @result
    rescue => e
      verbose 'ERROR do_evaluate_property'
      verbose e
      error e
      error $!
      #@result=jeannie all if not @result
    end
    return @result
  end


  def jeannie request
    jeannie_api='https://weannie.pannous.com/api?'
    params     ='login=test-user&out=simple&input='
    #raise "empty evaluation" if @current_value.blank?
    download jeannie_api+params+URI.encode(request)
  end

#  those attributes. hacky? do better / don't use
  def subnode attributes={}
    return if not $use_tree
    return if not @current_node #raise!
    attributes.each do |name, value|
      node=TreeNode.new(name: name, value: value)
      @nodes<<node
      @current_node.nodes<<node
      @current_value=value
    end
    return @current_value
  end

  def evaluate
    __ 'what is', 'evaluate', 'how much', 'what are', 'calculate', 'eval'
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
    maybe { newline }
  end

  def raiseNewline
    raise EndOfLine.new if @string.blank?
  end

  def checkNewline
    comment if not @string.blank?
    if @string.blank? or @string.strip.blank?
      @line_number    =@line_number+1 if @line_number<@lines.count
      @original_string='' if @line_number>=@lines.count #!
      return @NEWLINE if @line_number>=@lines.count
      #raise EndOfDocument.new if @line_number==@lines.count
      @string=@lines[@line_number];
      @original_string=@string||''
      checkNewline
      return @NEWLINE
    end
  end

  def newline_tokens
    ["\.\n", "\. ", "\n", "\r\n", ';'] #,'\.\.\.' ,'end','done' NO!! OPTIONAL!
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
    @string       =@string[@current_value.length..-1]
    return @current_value
  end

  def rest_of_line
    if not @string.match(/(.*?)[;\n]/)
      @current_value=@string
      @string       =nil
      return @current_value
    end
    @current_value=@string.match(/(.*?)[;\n]/)[1]
    @string       =@string[@current_value.length+1..-1]
    @current_value.strip!
    return @current_value
  end

  def comment_block
    token '/*'
    while not @string.match /\*\//
      rest_of_line
      newline? #weg?
    end
    @string.gsub('.*?\*\/', '')
    #token '*/'
    # add_tree_node
  end

  def comment
    raiseEnd if @string==nil
    @string.gsub!(/ -- .*/, '');
    @string.gsub!(/\/\/.*/, ''); # todo
    @string.gsub!(/#.*/, '');
    checkNewline if @string.blank?
  end

  def svg x
    @svg<<x
  end

  def self.load_history_why? history_file
    histSize = 100
    begin
      history_file = File::expand_path(history_file)
      if File::exists?(history_file)
        lines = IO::readlines(history_file).collect { |line| line.chomp }
        Readline::HISTORY.push(*lines)
      end
      Kernel::at_exit do
        lines = Readline::HISTORY.to_a.reverse.uniq.reverse
        lines = lines[-histSize, histSize] if lines.count > histSize
        File::open(history_file, File::WRONLY|File::CREAT|File::TRUNC) { |io| io.puts lines.join("\n") }
      end
    rescue => e
      puts "Error when configuring history: #{e}"
    end
  end

  def self.start_shell
    $verbose=false
    if ARGV.count==0 #and not ARGF
      puts 'usage:'
      puts "\t./angle 6 plus six"
      puts "\t./angle examples/test.e"
      puts "\t./angle (no args for shell)"
      @parser=EnglishParser.new
      require 'readline'
      load_history_why?('~/.english_history')
      # http://www.unicode.org/charts/PDF/U2980.pdf
      while input = Readline.readline('⦠ ', true)
        # while input = Readline.readline('angle-script⦠ ', true)
        # Readline.write_history_file("~/.english_history")
        # while true
        #   print "> "
        #   input = STDIN.gets.strip
        begin
          interpretation= @parser.parse input
          puts interpretation.tree if $use_tree
          puts interpretation.result
        rescue NotMatching
          puts 'Syntax Error'
        rescue GivingUp
          puts 'Syntax Error'
        rescue
          puts $!
        end
      end
      exit
    end
    @all=ARGV.join(' ')
    a   =ARGV[0].to_s
    # read from commandline argument or pipe!!
    @all=ARGF.read||File.read(a) rescue a
    @all=@all.split("\n") if @all.is_a?(String)
    # puts "parsing #{@all}"
    for line in @all
      next if line.blank?
      interpretation=EnglishParser.new.parse line.encode('utf-8')
      puts interpretation.result
    end
  end

# def variables
#   @variables
# end
#
# def result
#   @result
# end
end

$testing||=false
EnglishParser.start_shell if ARGV and not $testing and not $commands_server #and not $raking
