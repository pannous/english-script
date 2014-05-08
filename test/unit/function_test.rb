#!/usr/bin/env ruby
require 'test_helper'

$use_tree=false
require_relative "../../core/english-parser"
#
#class FunctionTest #< Test::Unit::TestCase
#  # test "the truth" do
#  #   assert true
#  # end
#  def s x
#
#  end
#
#  test "basic syntax" do
#
#  end
#
#  test "complex syntax" do
#    s " hear is how to define a method: done"
#  end
#
#  test "simple parameters" do
#
#  end
#
#  test "to do something at a given point" do
#        #s <name of the test>
#  end
#
#  def parse x
#    s x
#    root
#  end
#
#  def parse x,&block
#    s x
#    root
#  end
#
#  test "svg return object" do
#    parse 'svg <circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/>'
#    parse 'what is that'
#  end
#
#
#  test "svg dom" do
#    s '<svg><circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/></svg>'
#    @@parser.svg
#    parse "circle.color=green"
#    prove("circle.color==green")
#  end
#
#  test "if" do
#    parse "x=2;if x is smaller than three everything is fine;"
#    a "everything is fine"
#  end
#
#end
