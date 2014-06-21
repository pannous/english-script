ENV["RAILS_ENV"] = "test"
$testing=true

require "test/unit"
require_relative "../core/english-parser"

# use as MODULE!
class ParserBaseTest < Test::Unit::TestCase
  include Exceptions

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
        puts
        #root if @string
        init x
        ok=@parser.condition
      rescue SyntaxError => e
        raise e # ScriptError.new "NOT PASSING: SyntaxError : "+x+" \t("+e.class.to_s+") "+e.to_s
      rescue => e
        raise NotPassing.new "NOT PASSING: "+x.to_s+" \t("+e.class.to_s+") "+e.to_s
      end
      raise NotPassing.new "NOT PASSING: "+x.to_s if not ok
      puts x
    end
    puts "\nTEST PASSED   " +x.to_s+" \t" +@parser.to_source(block).to_s
  end


  def NOmethod_missing(sym, *args, &block) # <- NoMethodError use node.blah to get blah!
    syms=sym.to_s
    if @parser and @parser.methods.contains(sym)#(syms.end_with?"?")
      x= maybe { @parser.send(sym) } if args.count==0
      x= maybe { @parser.send(sym,args[0]) } if args.count==1
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
    @variables=@parser.variables
    @result=@parser.result
  end


  def self._test x
    puts "NOT testing "+x.to_s
  end

  def global_variables
    @parser.variables
  end

  def _test_all
    @parser.methods.each { |m|
      if m.to_s.start_with? "test"
        @parser.send(m)
      end
    }
  end

  def test_current
    current
  end

  #   # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #   # Note: You'll currently still have to declare fixtures explicitly in integration tests
  #   # -- they do not yet inherit this setting
  #   fixtures :all

end
