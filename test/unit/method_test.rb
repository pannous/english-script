#!/usr/bin/env ruby

#$use_tree=true
require_relative '../parser_test_helper'

class MethodTest < ParserBaseTest

  include ParserTestHelper

  def test_result
    parse "show 3"
    assert_equals result,"3"
    parse "how to test:show 3;ok"
    assert methods.count>0
    assert_equals methods["test"].body,"show 3;"
    parse "test"
    assert_equals result,"3"
    #assert @variables['x']==3
  end

end


