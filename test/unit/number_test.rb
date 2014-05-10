#!/usr/bin/env ruby

# $use_tree=true
$use_tree=false

# $verbose=true

require_relative '../parser_test_helper'

class NumberTest  < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_type1
    puts parse "class of 1"
    assert_equals @result,Fixnum
    parse "class of 3.3"
    assert @result==Float
  end

  def test_type2
    assert "3.2 is a Numeric"
    assert "3.2 is a Float"
    assert "3.2 is a float"
    assert "3.2 is a real"
    assert "3.2 is a float number"
    assert "3.2 is a real number"
    # assert "3.2 is not an integer"
  end

  def test_type3
    assert "3 is a Fixnum"
    assert "3 is a Numeric"
    assert "3 is a Integer"
    assert "3 is a Number"
  end

  def test_english_number_types
    # todo !
    assert "3.2 is a number"
    assert "3.2 is a real number"
    assert "3.2 is a real"
    assert "3.2 is a float"
    assert "3.2 is a float number"
    assert "3 is a number"
    assert "3 is a integer"
    assert "3 is an integer"
  end

  def _test_int_methods
    parse "invert 3"
    assert @result=="1/3"
  end

  def current
    # test_failing
    test_type1
    # test_type2
    # test_type3
  end

end
