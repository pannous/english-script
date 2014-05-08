#!/usr/bin/env ruby
require 'test_helper'
$use_tree=false
#$use_tree=true
require_relative "../../core/english-parser"

class SelectorTestParser<EnglishParser
  def current
    test_selector0
  end

  def initialize
    @@testing=true
    super
  end


  def test_every
    parse "friendly numbers= [1,2,3]; show every friendly number"
    parse "friendly numbers= [1,2,3]; show all friendly numbers"
    #p "print every item in [1,2,3]"
    #p "print every number in [1,2,3]"
    #p "friendly numbers= [1,2,3]; friendly numbers which are smaller than three "
  end

  def test_selector0
    s "2,3,8,9"
    list
    #s "xs= 2,3,8,9"
    #setter
    parse "xs= 2,3,8,9"
    s " xs that are smaller than 7 "
    z=selectable
    assert_equals z,[2,3]
    z=parse "let z be xs that are smaller than 7 "
    assert_equals z,[2,3]
    #assert " {xs<7} = 2,3 "
    #s " xs that are smaller than 7 == [2,3]"
    #condition
    #assert " xs that are smaller than 7 == [2,3]"
    #assert "those xs that are smaller than seven are 2,3"
    #assert "those xs that are smaller than seven are the same as 2,3"
  end

  #todo simplify
  # those xs that are smaller than seven are the same as 2,3

  def  test_selector1
    parse "xs= 1,2,3"
    assert " xs that are bigger than one == [2,3]"
    s " xs that are bigger than one"
    z=selectable
    assert_equals z,[2,3]
    #s " xs that are bigger than one == [2,3]"
    #condition
    #assert " xs that are bigger than one == [2,3]"
  end

  def test_every_selector
    parse "friendly numbers= [1,2,3]; show every friendly number that is bigger than one"
    parse "friendly numbers= [1,2,3]; all friendly numbers which are smaller than three == [1,2]"
  end



  def test_selector1
    assert("every number in 1,'a',3 ==1,3")
    assert("all numbers in 1,'a',3 ==1,3")
    assert("all negative numbers in 1,-2,3,-4 ==-2,-4")
    assert("all numbers in 1,-2,3,-4 that are negative == -2,-4")
  end

end

class SelectorTest < Test::Unit::TestCase

  def self._test x
    puts "NOT testing "+x.to_s
  end

  def initialize args
    @testParser=SelectorTestParser.new
    super args
  end

  _test "ALL" do
    @testParser.methods.each { |m|
      if m.to_s.start_with? "test"
        begin
          @testParser.send(m)
        rescue => e
          puts "NOT PASSING: "+m.to_s
          @testParser.error e
        end
      end
    }
  end

  test "current" do
    @testParser.current
  end

end
