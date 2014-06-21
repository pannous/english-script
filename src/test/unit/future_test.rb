#!/usr/bin/env ruby
# require 'test_helper'

$use_tree=false
# $use_tree=true

require_relative '../parser_test_helper'


# TESTS in this class are NOT meant to pass yet,
# they can be read as a to do list,
# to play with or
# to be pasted to other test classes
class FutureTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def dont_yet_test_false_returns
    assert_result_is "if 1<2 then false else 4",:false
    assert_result_is "if 1<2 then false else 4",false
  end

end
