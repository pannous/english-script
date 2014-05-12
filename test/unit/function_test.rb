#!/usr/bin/env ruby
require 'test_helper'

$use_tree=false

require_relative '../parser_test_helper'

class ConditionTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_basic syntax

  end

  def test_complex syntax
    init " hear is how to define a method: done"
  end

  def test_simple parameters

  end

  def test_to_do_something #at a given point
    #s <name of the test>
  end


  def test_svg
    parse 'svg <circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/>'
    parse 'what is that'
  end

  def test_java_style
    parse "1.add(0)"
  end

  def test_add_to_zero
    # 0->false->"" ERROR!!!
    parse "counter is zero; repeat three times: increase counter by 1; done repeating;"
    assert_equals variables['counter'], 3
    # parse "counter is zero; repeat three times: add 1 to counter; done repeating;"
    assert "the counter is 3"
  end

  def test_add
    parse "counter is one; repeat three times: increase counter; done repeating;"
    assert_equals variables['counter'], 4
  end


  def _test_svg_dom
    init '<svg><circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/></svg>'
    puts @parser.interpretation.svg
    parse "circle.color=green"
    assert_equals("circle.color", "green")
  end


end
