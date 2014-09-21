#!/usr/bin/env ruby

$use_tree=false
# $verbose=false

require_relative '../parser_test_helper'

class SelectorTest < ParserBaseTest

  include ParserTestHelper

  def test_every
    parse "xs= [1,2,3]; increase all xs"
    skip
    parse "xs= [1,2,3]; show all xs" # todo: ruby => rest_of_statement
    parse "xs= [1,2,3]; show every xs"
    parse "friendly numbers= [1,2,3]; show all friendly numbers"
    parse "friendly numbers= [1,2,3]; show every friendly number"
    #p "print every item in [1,2,3]"
    #p "print every number in [1,2,3]"
    #p "friendly numbers= [1,2,3]; friendly numbers which are smaller than three "
  end

  # OK when testing!?!
  # BUG! def pointer.-
  # GETS FUCKED UP BY @string.strip! !!! ???
  def test_selector0
    parse "xs= 2,3,8,9"
    init "xs that are smaller than 7" # BUG 'maller t'
    z=@parser.selectable # BUG! def pointer.-
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
    init " xs that are bigger than one"
    z=@parser.selectable
    assert_equals z,[2,3]
    assert "xs that are bigger than one == [2,3]"
    #s " xs that are bigger than one == [2,3]"
    #condition
    #assert " xs that are bigger than one == [2,3]"
  end

  def test_every_selector
    skip
    parse "friendly numbers= [1,2,3]; show every friendly number that is bigger than one"
    parse "friendly numbers= [1,2,3]; all friendly numbers which are smaller than three == [1,2]"
  end



  def test_selector3
    skip
    assert("every number in 1,'a',3 ==1,3")
    assert("all numbers in 1,'a',3 ==1,3")
    assert("all negative numbers in 1,-2,3,-4 ==-2,-4")
    assert("all numbers in 1,-2,3,-4 that are negative == -2,-4")
  end

end
