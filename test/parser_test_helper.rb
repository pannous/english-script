ENV["RAILS_ENV"] = "test"
$testing=true

require "test/unit"
require_relative "../core/english-parser"

module ParserTestHelper
  include Exceptions

  def initialize args
    @parser=EnglishParser.new
    super args
  end

  def assert_has_error x=nil, &block
    begin
      # x=yield if not x and block
      assert x, &block
      raise ScriptError.new "assert_has_error "
    rescue
      puts "TEST PASSED: assert_HAS_error "+x.to_s+" \t" +@parser.to_source(block).to_s
    end
  end

  def assert_equals a, b
    if a==b
      puts "TEST PASSED! #{a} == #{b}"
    else
      raise NotPassing.new "#{a} should equal #{b}"
    end
  end

  def assert x=nil, &block
    return puts "\nTEST PASSED! " if x==true
    x=yield if not x and block
    #raise Exception.new (to_source(block)) if not x
    raise NotPassing.new to_source(block) if block and not x
    raise NotPassing.new if not x
    if x.is_a? String
      begin
        puts "Testing #{x}"
        #root if @string
        init x
        ok=@parser.condition
      rescue SyntaxError => e
        raise e # ScriptError.new "NOT PASSING: SyntaxError : "+x+" \t("+e.class.to_s+") "+e.to_s
      rescue => e
        raise NotPassing.new "NOT PASSING: "+x.to_s+" \t("+e.class.to_s+") "+e.to_s
      end
      if not ok
        raise NotPassing.new "NOT PASSING: "+x.to_s
      end
      puts x
    end
    puts "\nTEST PASSED! " +x.to_s+" \t" +@parser.to_source(block).to_s
  end


  def NOmethod_missing(sym, *args, &block) # <- NoMethodError use node.blah to get blah!
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
    @parser.allow_rollback
    @parser.init string
  end

  def variables
    @parser.variables
  end

  def parse x
    @parser.parse x
    # @variables=@parser.variables
    # @result=@parser.result
    @variables=@parser.interpretation.variables
    @result=@parser.interpretation.result
    # @current_value=@parser.interpretation.current_value
    # @current_node=@parser.interpretation.current_node
  end

  def self._test x
    puts "NOT testing "+x.to_s
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
