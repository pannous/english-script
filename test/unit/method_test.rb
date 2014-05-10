#!/usr/bin/env ruby

#$use_tree=true
require_relative '../parser_test_helper'

class MethodTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_result
    parse "how to test:show 3;ok"
    assert @methods.count>0
    assert @methods.last.name=="test"
    parse "test"
    assert @result=="3"
    #assert @variables['x']==3
  end

end


