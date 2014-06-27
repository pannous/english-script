#!/usr/bin/env ruby
# encoding: utf-8

$use_tree=true
$use_tree=false

require_relative '../parser_test_helper'

class AlgebraTest < ParserBaseTest

  include ParserTestHelper

  def test_algebra1
    assert_result_is "two minus 1½",0.5
    assert_result_is "3 minus one",2
    init "4½"
    assert_equals @parser.fraction,4.5
    init "4½+3½"
    @parser.do_interpret!
    assert_equals @parser.algebra,8
    assert_result_is "4½+3½","8"
  end


  def test_algebra_NOW
    skip "test_algebra_NOW, DONT SKIP!"
    assert_result_is "1+(3/4)","1¾"
    assert_result_is "1+3/4.0","1¾"
    # 1.0 noo
    assert_result_is "1.0+3/4.0","1¾"
    # 4.0
  end

  def test_algebra
    ok=parse "2*(3+10)"
    puts "Parsed input as #{ok}!"
    assert_equals ok,26
    skip
    assert @current_node!=nil
    #assert @current_node==@root
    full_value=@current_node.full_value
    val=eval(full_value)
    assert_equals val,26
    val=@current_node.eval_node(@variableValues)
    assert_equals val,26
  end

end
