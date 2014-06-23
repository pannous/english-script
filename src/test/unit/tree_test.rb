#!/usr/bin/env ruby
# encoding: utf-8

$use_tree=true

require_relative '../parser_test_helper'

class TreeTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper


  def test_algebra1
    assert_result_is "3 minus one",2
    init "4½"
    assert_equals @parser.fraction,4.5
    init "4½+3½"
    @parser.do_interpret!
    assert_equals @parser.algebra,8
    assert_result_is "4½+3½","8"
  end


  def test_method4
    init "how to integrate a bug
      test
    ok"
    assert @parser.method_definition
  end



  def _test_block
    init "let the initial value of I be x;\n
      step size is the length of the interval,
      divided by the number of steps\n
      var x = 8;"
    @parser.block
  end

  def _test_while
    @variables[:i]=0;
    @variables[:y]=5;
    parse "while i is smaller or less then y do
        increase i by 4;
      done"
    assert_equals @variables[:i],8
  end

  def _test_while2
    init "while i is smaller or less then y do
 evaluate the function at point I
 add the result to the sum
 increase I by the step size
done"
    @parser.looper
  end

  def _test_setter3
    init "step size is the length of the interval, divided by the number of steps"
    @parser.setter
  end

  def test_looper
    init "while i is smaller or less then y do\nyawn\nend"
    @parser.looper
  end

  def test_method_call
    init "evaluate the function at point I"
    @parser.method_call
    #action
  end

  def test_algebra_NOW
    assert_result_is "1+3/4.0","1¾"
    # 1.0 noo
    assert_result_is "1.0+3/4.0","1¾"
    # 4.0
  end

  def test_algebra
    # s "2* ( 3 + 10 )"
    init "2*(3+10)"
    puts "Parse #{@string} as algebra?"
    ok=parse @string #@parser.algebra
    puts "Parsed input as #{ok}!"
    assert_equals @result,26
    assert @current_node!=nil
    #assert @current_node==@root
    full_value=@current_node.full_value
    val=eval(full_value)
    assert_equals val,26
    val=@current_node.eval_node(@variables)
    assert_equals val,26
  end

end
