#!/usr/bin/env ruby
# encoding: utf-8

# $use_tree=true
$use_tree=false

require_relative '../parser_test_helper'

class TreeTest < ParserBaseTest

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
    @variableValues[:i]=0;
    @variableValues[:y]=5;
    parse "while i is smaller or less then y do
        increase i by 4;
      done"
    assert_equals @variableValues[:i],8
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
    skip
    parse "i=1;y=2;"
    init "while i is smaller or equal y do\ni++\nend"
    @parser.loops
    init "while i is smaller or equal than y do\ni++\nend"
    @parser.loops
  end

  def test_then_typo
    # parse "i=1;y=2;"
    skip
    # todo 1) throw, don't loop   2) throw yawn UP!
    parse "while i is smaller or equal y then do\nyawn\nend"
    skip
    parse "while i is smaller or equal then y do\nyawn\nend"
  end

  def test_method_call
    skip
    init "evaluate the function at point I"
    # @parser.method_call
    #action
  end

  def test_algebra_NOW
    skip "test_algebra_NOW, DONT SKIP!"
    assert_result_is "1+3/4.0","1¾"
    # 1.0 noo
    assert_result_is "1.0+3/4.0","1¾"
    # 4.0
  end

  def test_algebra
    # s "2* ( 3 + 10 )"
    init "2*(3+10)"
    ok=@parser.algebra
    puts "Parsed input as #{ok}!"
    assert_equals ok,26
    skip if not $use_tree
    current_node=interpretation.root
    full_value=current_node.full_value
    val=eval(full_value)
    assert_equals val,26
    val=current_node.eval_node()
    assert_equals val,26
  end

end
