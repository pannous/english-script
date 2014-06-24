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


  def test_repeat_until
    parse 'repeat until x>4: x++'
    assert_equals variables["x"], 5
  end

  def test_try_until
    parse 'try until x>4: x++'
    assert_equals variables["x"], 5
    parse 'try while x<4: x++'
    assert_equals variables["x"], 4
    parse "try x++ until x>4"
    assert_equals variables["x"], 5
    parse "try x++ while x<4"
    assert_equals variables["x"], 4
    parse 'increase x until x>4'
    assert_equals variables["x"], 5
  end

  # (beep three) times
  def test_loops #OK
    parse 'beep three times' #OK
    parse "repeat three times: beep; okay" #OK
    parse "repeat three times: beep" #OK
  end

  def test_action_n_times
    parse "2 times say 'hello'"
    parse "say 'hello' 2 times"
    parse "puts 'hello' 2 times"
  end

end
