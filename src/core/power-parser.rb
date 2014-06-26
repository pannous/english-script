#!/usr/bin/env ruby
# encoding: utf-8

require_relative "exceptions"

class Quote < String
  def is_a className
    className.downcase!
    return true if className=="quote"
    return className=="string"
  end
  def self.== x
    true if x==String
    x==Quote
  end
end

class Function
  attr_accessor :name, :arguments, :return_type, :scope, :module, :class, :object

  def initialize args
    self.name     =args[:name]
    self.scope    =args[:scope]
    self.class    =args[:class]
    self.module   =args[:module]
    self.object   =args[:object]
    self.arguments=args[:arguments]
    # scope.variables[name]=self
  end
end

class FunctionCall

  attr_accessor :name, :arguments, :scope, :module, :class, :object

  def initialize args
    self.name     =args[:name]
    self.scope    =args[:scope]
    self.class    =args[:class]
    self.module   =args[:module]
    self.object   =args[:object]
    self.arguments=args[:arguments]
  end
end


class Argument
  attr_accessor :name, :type, :position, :default, :preposition, :value

  def initialize args
    self.name       =args[:name]
    self.preposition=args[:preposition]
    self.type       =args[:type]
    self.position   =args[:position]
    self.default    =args[:default]
    self.value      =args[:value]
    # scope.variables[name]=self
  end

  def name_or_value
    self.value||self.name
  end

  def to_sym
    self.name.to_sym
  end
end



class Variable
  attr_accessor :name, :type, :scope, :module, :value, :final, :modifier

  def initialize args
    self.name    =args[:name]
    self.type    =args[:type]
    self.scope   =args[:scope]
    self.final   =args[:final]
    self.value   =args[:value]
    self.module  =args[:module]
    self.modifier=args[:modifier]
    # scope.variables[name]=self
  end
end


class Property < Variable
  attr_accessor :name,:owner
end

class Parser #<MethodInterception
  include Exceptions
  attr_accessor :lines,:verbose,:original_string

  def initialize
    super # needs to be called by hand!
    # @verbose=true
    @verbose          =$VERBOSE||$verbose # false
    @very_verbose     =@verbose
    @original_string  ="" # for string_pointer ONLY!!
    @string           =""
    @last_pattern     =nil
    @rollback         =[]
    @tree             =[]
    @line_number      =0
    @lines            =[]
    @interpret_border =-1
    @no_rollback_depth=-1
    @max_depth        =160
  end

  def s string
    allow_rollback
    init string
    #@@parser.init string
  end

  def assert_equals a, b
    raise NotPassing.new "#{a} should equal #{b}" if a!=b
  end

  def assert x=nil, &block
    x=yield if not x and block
    #raise Exception.new (to_source(block)) if not x
    raise NotPassing.new to_source(block) if block and not x
    raise NotPassing.new if not x
    if x.is_a? String
      begin
        #root if @string
        s x
        ok=condition
      rescue SyntaxError => e
        raise e # ScriptError.new "NOT PASSING: SyntaxError : "+x+" \t("+e.class.to_s+") "+e.to_s
      rescue => e
        raise NotPassing.new "NOT PASSING: "+x.to_s+" \t("+e.class.to_s+") "+e.to_s
      end
      raise NotPassing.new "NOT PASSING: "+x.to_s if not ok
      puts x
    end
    puts "TEST PASSED! " +x.to_s+" \t" +to_source(block).to_s
    return true
  end

  def interpretation
    super #  set properties
    @interpretation.error_position=@error_position
    return @interpretation
  end


  def verbose info
    puts info if @verbose
  end

#gem 'debugger'
#gem 'ruby-debug19', :require => 'ruby-debug'
#require 'ruby-debug'
#require 'debugger'
#gem 'ParseTree' ruby 1.9 only :{
#require 'sourcify' #http://stackoverflow.com/questions/5774916/print-the-actual-ruby-code-of-a-block BAD
#require 'method_source'

#gem 'ruby-debug', :platforms => :ruby_18
#gem 'ruby-debug19', :platforms => :ruby_19, :require => 'ruby-debug'

#def maybe &block
#  return yield rescue true
#end

  def raiseEnd
    if @string.blank?
      raise EndOfDocument.new if @line_number>=@lines.count
      #@string=@lines[++@line_number];
      raise EndOfLine.new
    end
  end

  def checkRaiseEnd
    #raise EndOfDocument.new if @string.blank? # no:try,try,try
    return @string.blank?
  end


  def checkEnd
    #raise EndOfDocument.new if @string.blank? # no:try,try,try
    return @string.blank?
  end


  def __ *x
    tokens x
  end

  def remove_tokens *tokenz
    for t in tokenz.flatten
      @string.gsub!(/ *#{t} */, " ")
    end
  end


  # shortcut: method missing (and maybe{}?)
  def __? *x
    # DANGER!! Obviously very different semantics from maybe{tokens}!!
    # remove_tokens x # shortcut
    maybe { tokens x }
  end


  def must_contain *args
    before=args[-1][:before] if args[-1].is_a? Hash
    args  =args[0..-2] if before
    before||=[]
    must_contain_before before, args
  end

  def must_contain_before before, *args #,before:nil
    raiseEnd
    good  =false
    before=[before] if before and before.is_a? String
    before=before.flatten+[';'] if before
    args.flatten!
    for x in args.flatten
      if x.match(/^\s*\w+\s*$/)
        good||=(" #{@string} ").match(/[^\w]#{x}[^\w]/)
        good=nil if good and before and before.matches(good.pre_match)
      else # token
        good||=@string.index(x)
        good=nil if good and before and before.matches(@string[0..good])
      end
      break if good
    end
    raise(NotMatching.new(x)) if not good
    raise(NotMatching.new(x)) if good.to_s.contains newline_tokens # ;while
    raise(NotMatching.new(x)) if good.pre_match.contains newline_tokens rescue nil
    @OK
  end

  # NOT == starts_with !!!
  def look_ahead x
    @string.index(x) ? true : raise(NotMatching.new(x))
  end

  def _! x
    look_ahead x
  end

  def _ x
    token x
  end

  def _? *x
    maybe { tokens x }
  end


  def last_try stack
    for s in stack
      if s.match("`try'")
        return s
      end
    end
  end

  def caller_name
    for i in 0..(caller.count)
      next if not caller[i].match(/parser/)
      name=caller[i].match(/`(.*)'/)[1]
      return name if caller[i].index("parser")
    end
  end


  def no_rollback! n=0
    depth             =caller_depth-1
    @old_rollback_depth=@no_rollback_depth
    @no_rollback_depth=depth
    # @no_rollback_method=caller #_name
  end

  def do_interpret!
    @interpret_border=-1
    @did_interpret   =@interpret
    @interpret       =true
  end

  def dont_interpret!
    if @interpret_border<0
      @interpret_border= caller_depth
      @did_interpret   =@interpret
    end
    @interpret=false
  end

  def check_interpret n=0
    if (@interpret_border>=caller_depth-n)
      @interpret       = @did_interpret
      @interpret_border=-1
    end
    @interpret
  end

  def allow_rollback n=0
    @old_rollback_depth=-1 if @no_rollback_depth==-1 || n<0
    @no_rollback_depth=@old_rollback_depth||-1
  end

  def check_rollback_allowed
    c=caller_depth
    return c<@no_rollback_depth || c>@no_rollback_depth+2
  end

  # same as try but throws if no result
  @throwing=true #[]
  @level   =0

  def any(&block)
    raiseEnd
    #return if checkEnd
    last_try=0
    #throw "Max recursion reached #{to_source block}" if @level>20
    raise MaxRecursionReached.new(to_source block) if caller.count>180
    was_throwing=@throwing
    @throwing   =false
    #@throwing[@level]=false
    oldString   =@string
    begin
      result=yield # <--- !!!!!
      if not result
        @string=oldString
        raise NoResult.new(to_source block)
      end
      return result
    rescue EndOfDocument
      verbose "EndOfDocument"
    rescue EndOfLine
      verbose "EndOfLine"
    rescue GivingUp => e
      raise e
    rescue NotMatching
      verbose "NotMatching"
        #retry
    rescue => e
      verbose "Error in #{to_source block}"
      error e
    end
    verbose "Succeeded with any #{to_source block}" if result
    string_pointer if @verbose and not result
    @last_token=string_pointer_s #if not @last_token
    @string  =oldString if check_rollback_allowed
    @throwing=was_throwing
    #@throwing[@level]=true
    #@level=@level-1
    return result if result
    raise NotMatching.new(to_source block)
    #throw "Not matching #{to_source block}"
  end

  def to_source x
    return @last_pattern if @last_pattern or not x
    #proc=block.to_source(:strip_enclosure => true) rescue "Sourcify::MultipleMatchingProcsPerLineError"
    res  =x.source_location[0]+":"+x.source_location[1].to_s+"\n"
    lines=IO.readlines(x.source_location[0])
    i    =x.source_location[1]-1
    while true
      res+= lines[i]
      break if i>=lines.length or lines[i].match "}" or lines[i].match "end"
      i=i+1
    end
    res
  end

  def caller_depth
    # c= @depth #if $use_tree doesn't speed up
    # c= @depth if $use_tree
    # c = @depth #for mruby
    c = caller.count rescue @depth #for mruby
    c
    # filter_stack(caller).count #-1
  end

  def adjust_rollback depth=caller_depth
    # if depth+3<@no_rollback_depth
    #   @no_rollback_depth=depth
    # end
    if depth+2<@no_rollback_depth #todo: nested no_rollback!
      @no_rollback_depth=-1#depth#-3
    end
  end

  # todo ? trial and error -> evidence based 'parsing' ?
  def maybe(&block)
    #return if checkEnd
    # allow_rollback 1
    @depth=@depth+1
    old=@string
    if (caller_depth>@max_depth)
      raise SystemStackError.new "if(@nodes.count>@max_depth)"
    end

    @original_string=@string||"" if @original_string.blank?
    begin
      old_nodes=@nodes.clone
      result   = yield
      if result
        adjust_rollback
      else
        #DANGER RETURNING false as VALUE!! use RAISE ONLY todo
        (@nodes-old_nodes).each { |n| n.valid=false }
        @string=old
      end
      @last_node=@current_node
      return result
    rescue NotMatching, EndOfLine => e
      verbose e
      @current_value=nil
      @string       =old
      check_interpret 2
      verbose "Tried #{to_source block}"
      verbose e
      string_pointer if @verbose
      (@nodes-old_nodes).each { |n|
        n.destroy
      } #n.valid=false;
      #caller.index(last_try caller)]
      #puts @rollback[caller.count]
      #puts caller.count
      #puts rollback
      cc=caller_depth
      rb= @no_rollback_depth-2
      # DO NOT TOUCH ! Or replace with a less fragile mechanism
      if cc<rb and not cc+2<rb # not check_rollback_allowed
        error "NO ROLLBACK, GIVING UP!!!"
        puts @last_token || string_pointer # ALWAYS! if @verbose
        show_tree #Not reached
        attempt=e.to_s.gsub("[", "").gsub("]", "")
        from=0# e.backtrace.count-@no_rollback_depth-2
        bt     =e.backtrace
        bt     =bt[from..-1] #if from>10
        bt     =filter_stack bt
        m0     =bt[0].match(/`.*/) rescue "XX"
        m1     =bt[1].match(/`.*'/) rescue "YY"
        ex     =GivingUp.new("Expecting #{m0} in #{m1} ... maybe related: #{attempt}\n#{@last_token || string_pointer}")
        ex.set_backtrace(bt)
        raise ex
        # error e #exit
        # raise SyntaxError.new(e)
      end
    rescue EndOfDocument => e
      (@nodes-old_nodes).each { |n|
        n.destroy
      } #n.valid=false;
      @string=old
      verbose "EndOfDocument"
      #raise e
      return false
        #return true
    rescue GivingUp => e
      # @string=old #to mark??
      # maybe => OK !?
      error e #if not check_rollback_allowed
        #     if @rollback[caller.count-1]!="NO" #
    rescue => e # NoMethodError etc
      @string=old
      error e
      verbose e
    ensure
      adjust_rollback
      @depth=@depth-1
    end
    @string=old #if rollback
    @nodes =old_nodes # restore
    return false
  end

  def one_or_more(&block)
    all           =[yield]
    @current_value=[]
    all+[star { yield }].flatten
  end

  def many(&block)
    while true
      begin
        comment?
        old_tree=@nodes.clone
        result  =yield
        #puts "------------------"
        #puts @nodes-old_tree
        break if @string.blank? # TODO! loop criterion too week
        if not result or result==[] #or @string==""
          raise NotMatching.new to_source(block)+"\n"+string_pointer_s
          #exit
        end
      rescue => e
        error e
      end
    end
  end


  def pointer
    #@line_number copy by ref?????????
    Pointer.new @line_number, @original_string.length-(@string||"").length, self
  end

  class Pointer
    attr_accessor :line_number, :offset, :parser

    def - start
      return offset-=start.length if start.is_a? String
      return content_between self, start if start>self
      return content_between start, self
    end

    def > x
      line_number>=x.line_number and offset>x.offset
    end

    def initialize line_number, offset, parser
      @line_number=line_number
      offset      =0 if line_number>=parser.lines.count
      @offset     =offset
      @parser     =parser
    end

    def to_s
      @line_number.to_s+" "+@offset.to_s #+" "+@parser.lines[@line_number][@offset]
    end

    def content_between start_pointer, end_pointer
      line=start_pointer.line_number
      all =[]
      return all if line>=@parser.lines.count
      if line==end_pointer.line_number
        return @parser.lines[line][start_pointer.offset..end_pointer.offset-1]
      else
        all<<@parser.lines[line][start_pointer.offset..-1]
      end
      line=line+1
      while line<end_pointer.line_number and line<@parser.lines.count
        all<<@parser.lines[line]
        line=line+1
      end
      chars=end_pointer.offset-1
      all<<@parser.lines[line][0..chars] if line<@parser.lines.count and chars>0
      all.map &:stripNewline
      return all[0] if all.length==1
      all
    end

  end

  def star(&block)
    #checkEnd
    if (@nodes.count>@max_depth)
      raise SystemStackError.new "if(@nodes.count>@max_depth)"
    end

    was_throwing=@throwing
    @throwing   =true
    old_state   =@current_value # DANGER! must set @current_value=nil :{
    max         =20 # no list of >100 ints !?! WOW exclude lists!! TODO OOO!
    current     =0
    good        =[]
    # begin
    old_nodes   =@nodes.clone
    # entry_node_offset=@nodes.count-1
    # if(entry_node_offset>48)
    # entry_node=@last_node
    # end

    oldString   =@string
    last_string =""
    begin
      while true
        break if @string=="" or @string==last_string
        last_string=@string
        match      =yield # <------!!!!!!!!!!!!!!!!!!!
        break if match.blank?
        oldString=@string # (partial)  success
        good<< match
        throw " too many occurrences of "+ to_source(block) if current>max and @throwing
      end
    rescue NotMatching => e
      @string=oldString # partially reconstruct
      if @very_verbose and not good
        verbose "NotMatching star "+ e.to_s
        #verbose "expected any of "+tokens.to_s if tokens and tokens.count>0
        string_pointer if @verbose
      end
    rescue EndOfDocument => e
      #raise e
      verbose "EndOfDocument"
        #break
        #return false
    rescue => e
      error e
      error "error in star "+ to_source(block)
      #warn e
    end
    return good[0] if good.length==1
    return good if not good.blank?
    #else restore!
    @throwing=was_throwing
    @string  =oldString
    for n in @nodes-old_nodes do
      n.destroy
    end
    @nodes=old_nodes
    # cleanup_nodes_till entry_node
    # for i in entry_node_offset...@nodes.size
    #   @nodes.delete_at i
    # end
    return old_state
    # rescue
    # end
  end


# use _?
#def maybe token
#  return token token rescue true
#end


  def ignore_rest_of_line
    @string.gsub!(/.*?\n/, "\n")
  end


  def string_pointer_s
    offset=@original_string.length-@string.length rescue 0
    offset=0 if offset<0
    @original_string+"\n"+" "*(offset) + "^^^"+"\n"
  end

  def string_pointer
    puts string_pointer_s
  end

  def clean_backtrace x
    x=x.select { |x| not x.match(/ruby/) }.join("\n")
    x
  end

  def error e, force=false
    raise e if e.is_a? GivingUp # hand through!
    raise e if e.is_a? NotMatching
    puts e if e.is_a? String
    if e.is_a? Exception
      puts e.class.to_s+" "+e.message.to_s
      puts clean_backtrace e.backtrace
      puts e.class.to_s+" "+e.message.to_s
      string_pointer
      show_tree
      raise e if not $verbose # SyntaxError.new(e)
      #exit
    end
  end


  def warn e
    puts e.message
  end


  def one *matches
    oldString=@string
    for match in matches
      begin
        @string=oldString
        return match if match and not match.is_a? Symbol
        result =send(match) if match.is_a? Symbol
        return result #if result
      rescue NotMatching => e
        verbose "NotMatching one "+match.to_s+"("+e.to_s+")"
        #raise GivingUp.new
        error e if not check_rollback_allowed
      rescue => e
        error e
      end
    end
    @string=oldString if check_rollback_allowed
    verbose "Should have matched one of "+matches.to_s if @throwing
    raise NotMatching.new
    #throw "Should have matched one of "+matches
  end


  # hack for kleene star etc  _? == maybe{tokens}
  def method_missing(sym, *args, &block) # <- NoMethodError use node.blah to get blah!
    syms=sym.to_s
    cut =syms[0..-2]
    @depth=@depth+1
    #return send(cut) if(syms.end_with?"!")
    if (syms.end_with? "?")
      old_last     =@last_pattern
      @last_pattern=cut
      x            = maybe { send(cut) } if args.count==0
      x            = maybe { send(cut, args[0]) } if args.count==1
      x            = maybe { send(cut, args) } if args.count>1
      @last_pattern=old_last
      @depth=@depth-1
      return x
    end
    if (syms.end_with? "!")
      puts "DEPRECATED!!"
      return star { send(cut, args) }
    end
    #return star{send(cut)} if(syms.end_with?"*")
    #return plus{send(cut)} if(syms.end_with?"+")
    super(sym, *args, &block)
    @depth=@depth+1
  end

  def *(a)
    puts a
  end

  def app_path
    File.expand_path(File.dirname(__FILE__)).to_s
  end

  def dictionary_path
    app_path + "word-lists/"
  end

  def parse string
    verbose "PARSING"
    begin
      allow_rollback
      init string
      root
      @last_result=@result
    rescue => e
      @last_result=@result=nil
      filter_backtrace e
      error e
    end
    verbose "PARSED SUCCESSFULLY!!"
    show_tree
    #puts @svg
    return interpretation # self# @result
  end

  # def start_parser
  #   a=ARGV[0] || app_path+"/../examples/test.e"
  #   if (File.exists? a)
  #     @lines=IO.readlines(a)
  #   else
  #     @lines=a.split("\n")
  #   end
  #   parse @lines[0]
  # end

end
