#!/usr/bin/env ruby
require 'test_helper'

$use_tree=false
# $use_tree=true

require_relative '../parser_test_helper'


# TESTS in this class are NOT meant to pass yet, they can be read as a to do list to be pasted to other test classes
class FutureTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_false_returns
    assert_result_is "if(1<2) then 3 else 4",3
    assert_result_is "if 1<2 then 5 else 4",5
    assert_result_is "if(3<2) then 3 else 4",4
    assert_result_is "if 3<2 then 5 else 4",4
    assert_result_is "if 1<2 then false else 4","false"
    assert_result_is "if 1<2 then false else 4",:false
    assert_result_is "if 1<2 then false else 4",false
  end

end
