#!/usr/bin/env ruby
$use_tree=false

require_relative '../test_helper'

#DIFFERENT TO OTHER TEST: TEST EnglishParser methods DIRECTLY!
class EnglishParserTestParser<EnglishParser
  #@@parser=EnglishParser.new

  def initialize

    super
    #@@parser=EnglishParser.new
  end

  def NOmethod_missing(sym, *args, &block) # <- NoMethodError use node.blah to get blah!
    syms=sym.to_s
    if @@parser and @@parser.methods.contains(sym)#(syms.end_with?"?")
      x= maybe { @@parser.send(sym) } if args.count==0
      x= maybe { @@parser.send(sym,args[0]) } if args.count==1
      x= maybe { @@parser.send(sym, args) } if args.count>0
      return x
    end
    super(sym, *args, &block)
  end

  def test_substitute_variables
    @variables={"x" => 3}
    assert(" 3 "== substitute_variables(' #{x} '))
    assert('"3"'== substitute_variables('"#{x}"'))
    assert(" 3 "== substitute_variables(" $x "))
    assert("'3'"== substitute_variables("'$x'"))
    assert("3"== substitute_variables('#{x}'))
    assert do ("3"== substitute_variables("$x")) end
  end


  def test_default_setter_dont_overwrite
    s "set color to blue; set default color to green"
    setter
    assert(@variables["color"]=="blue")
  end

  def test_default_setter
    s "set the default color to green"
    setter
    assert(@variables.contains("color"))
  end

# grammar : 'hello' QUESTION ('does'| QUESTION)* 'the world'? VERB
  def test_root
    s "hello who does the world end"
    token "hello"
    question
    star {
      maybe { token 'does' } || maybe { question }
    }
    _? 'the world'
    assert verb
    puts "Parsed successfully!"
  end

  def aa
    puts "aa"
  end

  def bb
    raise NotMatching.new(test)
    #throw NotMatching.new NOT rescued!!!
  end

  def cc
    puts "cc"
    return "cc"
  end

  def dd
    puts "dd"
    throw "dd"
  end

  def test_any
    s "a b c d"
    one :aa, :bb, :cc
    assert any {
      maybe { puts "a" }
      maybe { puts "b" }
      maybe { raise NotMatching.new }
      maybe { puts "c" }
      maybe { throw "b" }
      maybe { puts "b" }
    }

  end



  def test_action
    s "eat a sandwich; done"
    #s "bash 'ls'"
    #verb and nod
    assert action
    assert(!string.match("sandwich"))
  end

  def test_methods
    test_method2
    #test_method3
    test_method4
  end

  def test_method
    s "how to integrate a bug do test done"
    assert method_definition
  end

  def test_method2
    s "how to print: eat a sandwich; done"
    assert method_definition
    #any{method_definition}
  end

  def test_method3
    s "how to integrate a bug\ntest\nok"
    assert method_definition
  end

  def test_method4
    s "how to integrate a bug
      test
    ok"
    assert method_definition
  end


  def test_expression
    s "eat a sandwich;"
    assert action
    puts x
  end

  def raise_test
    raise "test"
  end

  def test_block
    s "let the initial value of I be x;\nstep size is the length of the interval,
divided by the number of steps\nvar x = 8;"
    block
  end

  def test_quote
    s 'msg = "heee"'
    setter
  end

  def test_while
    allow_rollback
    s "while i is smaller or less then y do
 evaluate the function at point I
 add the result to the sum
 increase I by the step size
done"
    looper
  end

  def test_setter3
    s "step size is the length of the interval, divided by the number of steps"
    setter
  end

  def test_setter2
    s "var x = 8;"
    setter
  end

  def test_setter
    s "let the initial value of I be x"
    setter
  end

  def test_looper
    s "while i is smaller or less then y do\nyawn\nend"
    looper
  end

  def test_method_call
    s "evaluate the function at point I"
    method_call
    #action
  end

  def test_verb
    s "help"
    verb
  end

  def test_comment
    s "#ok"
    statement
    s "z3=13 //ok"
    assert statement
    s "z4=23 -- ok"
    assert statement
    s "z5=33 # ok"
    assert statement
    s "z6=/* dfsfds */3 "
  end

  def test_js
    s "js alert('hi')"
    assert javascript
    #puts @javascript
  end

  def test_ruby_method_call
    test_ruby_def
    parse "NOW CALL via english"
    s "call ruby_block_test 'yeah'"
    assert ruby_method_call
  end

  def test_ruby_def
    s "def ruby_block_test x='yuhu'
  puts x
  return x+'yay'
end"
    assert ruby_def
    # ^^ defines:
    ruby_block_test
  end

  def test_ruby_all
    s "
def ruby_block_test x='yuhu'
  puts x
  return x+'yay'
end
call ruby_block_test 'yeah'
"
    root
  end

  def test_ruby_variables
    s "x=7;puts x;x+1;"
    root
  end

  def test_ruby
    s "def ruby_block_test
  puts 'ooooo'
  return 'yay'
end"
    execute_ruby_block
    # ^^ defines:
    ruby_block_test
  end

  def test_algebra
    s "2* ( 3 + 10 ) "
    #s "2*(3+10)"
    puts "Parse #{@string} as algebra?"
    tree=algebra
    assert tree
    #assert @result==26
    #assert{@result==26}
    #puts eval good_node_values @root if @root #== @string
  end

  #ScriptError = Class.new StandardError
  def assert x=nil, &block
    x=yield if not x and block
    #raise Exception.new (to_source(block)) if not x
    raise ScriptError.new to_source(block) if not x
    puts x
    puts "!!OK!!"
  end

  #def assert x
  #  raise ScriptError if not x
  #  puts x
  #  puts "!!OK!!"
  #end


  def test_args
    s "eat an mp3"
    assert(endNode)
  end

  def test
    puts "Starting tests!"
    begin
      s "a bug"
      test_method3
      test_method4
      assert endNode
      test_ruby_variables
      test_args
      test_algebra
      test_ruby
      test_ruby_def
      test_ruby_method_call
      test_ruby_all
      #return
      test_js
      test_verb
      test_setter2
      test_setter3
      test_comment
      #star { arg }
      test_block
      test_quote
      test_while
      test_method_call
      #test_methods
      #  test_looper
      show_tree
      puts "++++++++++++++++++\nPARSED successfully!"
    rescue => e
      error e
    end
  end


end


class EnglishParserTest < ParserBaseTest

  @@testParser=EnglishParserTestParser.new

  def initialize args
    @parser=EnglishParserTestParser.new
    super args
  end

  def self._test x
    puts "NOT testing "+x.to_s
  end

  def test_all
    @parser.methods.each{|m|
      if m.to_s.start_with?"test"
        @parser.send(m)
      end
    }
  end

  def test_current
    @parser.test_algebra
    #@testParser.test
  end


  _test "setter" do
    @parser.test_default_setter
    @parser.test_default_setter_dont_overwrite
  end


  _test "substitute_variables" do
    @parser.test_substitute_variables
    #@@testParser.test_substitute_variables
    assert "yay"
  end

  _test "jeannie" do
    r= @parser.jeannie ("3 plus 3")
    puts "jeannie : 3 plus 3 = "+r.to_s
    assert(r=="6")
    puts "OK!!!!!!"
  end

end
