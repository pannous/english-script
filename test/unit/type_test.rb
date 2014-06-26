#!/usr/bin/env ruby
$use_tree=false
require_relative '../parser_test_helper'

class TypeTest < ParserBaseTest

  include ParserTestHelper

  def test_typed_variable
    parse "Int i=7"
    assert_equals variableTypes("i"),"int"
    # assert_equal variables["i"].type==Int
  end
end
