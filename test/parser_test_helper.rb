ENV["RAILS_ENV"] = "test"
$testing         =true
# $emit            =true #GLOBAL!
$emit            =false #PER METHOD
$use_tree        ||= $emit
# require "test/unit"
require 'minitest/autorun'
require_relative "../src/core/english-parser"

module ParserTestHelper
  #now in ParserBaseTest
end

class ParserBaseTest <Minitest::Test # Test::Unit::TestCase #< EnglishParser

  include Exceptions
  attr_accessor :variableValues

  def initialize args
    $verbose=false if ENV['TEST_SUITE']
    $emit   =false if $raking #SET per test_method ! OR RUN ALL TEST THROUGH EMITTER PIPELINE!!
    @parser =EnglishParser.new
    super args
  end

  def assert_has_no_error x=nil
    init x
    assert @parser.root
  end

  def assert_has_error x=nil, &block
    begin
      # x=yield if not x and block
      assert x, &block
      puts "TEST NOT PASSED: "+x.to_s+" \t" +@parser.to_source(block).to_s
        # raise ScriptError.new "assert_has_error "
    rescue Exception => e
      puts "TEST PASSED: assert_HAS_error #{e} "+x.to_s+" \t" +@parser.to_source(block).to_s
    end
  end

  def assert_result_is x, r
    assert_equals parse(x), parse(r)
  end

  def assert_equals a, b
    if a==b || a.to_s==b.to_s
      puts "TEST PASSED! #{@parser.original_string}    #{a} == #{b}"
    else
      puts filter_stack(caller)
      assert false, "#{a} should equal #{b}"
      # e= NotPassing.new "#{a} should equal #{b}"
      # e.set_backtrace filter_stack(caller)
      # raise e
    end
  end


  alias_method :original_assert, :assert

  def assert x=nil, msg=nil, &block
    return puts "\nTEST PASSED! #{@parser.original_string}" if x==true
    msg=msg.call if msg.is_a? Proc
    msg||=@parser.to_source(block) if block
    x  =yield if not x and block
    # x=yield if block # enough?
    original_assert false, "#{x} NOT PASSING: #{msg}" if not x
    if x.is_a? String
      begin
        puts "Testing #{x}"
        #root if @string
        init x
        @parser.dont_interpret! if $emit
        ok=@parser.condition
        ok=emit nil, ok if $emit #@parser.interpretation
      rescue SyntaxError => e
        raise e # ScriptError.new "NOT PASSING: SyntaxError : "+x+" \t("+e.class.to_s+") "+e.to_s
      rescue => e
        raise e
        # raise NotPassing.new "NOT PASSING: #{x} #{msg} \t(#{e.class}) #{e}"
      end
      if not ok
        # puts "NOT PASSING: #{x} #{msg}"
        original_assert false, "#{x} NOT PASSING: #{msg}"
        # super.assert(test:false ,"NOT PASSING: #{x} #{msg}")
        # super.assert(test:false ,"NOT PASSING: #{x} #{msg}")
        # raise NotPassing.new "NOT PASSING: #{x} #{msg}"
      end
      # puts x
    end
    puts "TEST PASSED!  #{x} \t" +@parser.to_source(block).to_s
  end


  def NOmethod_missing(sym, *args, &block) # <- use @parser.blah or node.blah to get blah / NoMethodError!
    syms=sym.to_s
    if @parser and @parser.methods.contains(sym) #(syms.end_with?"?")
      x= maybe { @parser.send(sym) } if args.count==0
      x= maybe { @parser.send(sym, args[0]) } if args.count==1
      x= maybe { @parser.send(sym, args) } if args.count>0
      return x
    end
    super(sym, *args, &block)
  end

  def init string
    @parser.allow_rollback -1 #reset
    @parser.init string
  end

  def variables
    @parser.variableValues
  end

  def functions
    @parser.methods
  end

  def methods
    @parser.methods
  end

  def interpretation
    @parser.interpretation
  end

  def result
    @parser.result
  end

  def parse_file file
    parse IO.read(file)
    # lines(file).join("\n")
  end

  def parse_tree x,emit=false
    return x if not x.is_a? String
    @parser.dont_interpret!
    interpretation= @parser.parse x
    @parser.full_tree
    # @parser.show_tree
    if emit
      return emit interpretation, interpretation.root
    else
      return interpretation.evaluate
    end
  end

  def emit interpretation, root
    # require_relative '../src/core/emitters/js-emitter'
    # JavascriptEmitter.new.emit interpretation, root, run: true
    # require_relative '../src/core/emitters/native-emitter'
    # NativeEmitter.new.emit interpretation, run: true
    require_relative '../src/core/emitters/c-emitter'
    NativeCEmitter.new.emit interpretation, run: true
  end

  def parse x, interpret=true
    @parser.do_interpret! if interpret
    return x if not x.is_a? String
    if $emit
      @result =parse_tree x
      # @variableValues     = todo if dynamic!
    else
      @result =@parser.parse x
      @result =@parser.interpretation.result
    end
    @variables      =@parser.interpretation.variables
    @variableValues =@variables.map_values { |v| v.value }
    # @variables=@parser.variables
    # @result=@parser.result
    # return @parser.interpretation if $use_tree
    @result         =false if @result==:false
    @result         =true if @result==:true
    @result
    # @current_value=@parser.interpretation.current_value
    # @current_node=@parser.interpretation.current_node
  end

  def self._test x
    puts "NOT testing "+x.to_s
  end

  def variableTypes v
    @parser.variables[v].type
  end

  def verbose
    return if $raking
    @parser.verbose=true
  end

  # def _test_all
  #   @parser.methods.each { |m|
  #     if m.to_s.start_with? "test"
  #       @parser.send(m)
  #     end
  #   }
  # end

  #   # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #   # Note: You'll currently still have to declare fixtures explicitly in integration tests
  #   # -- they do not yet inherit this setting
  #   fixtures :all

end
