#!/usr/bin/env ruby
$use_tree=false
require_relative '../parser_test_helper'

class TypeTest < ParserBaseTest

  include ParserTestHelper

  def test_typed_variable
    parse "Int i=7"
    assert_equals variableTypes("i"),Integer #should equal Fixnum
    # assert_equal variables["i"].type==Int
  end

  def test_typed_variable2
    parse "int i=7"
    assert_equals variableTypes("i"),"Integer"
    # assert_equal variables["i"].type==Int
  end

  def test_auto_typed_variable
    parse "i=7"
    assert_equals variableTypes("i"),"Fixnum"
    # assert_equals variableTypes("i"),"int"
    # assert_equal variables["i"].type==Int
  end


  def test_type1
    init "class of 1,2,3"
    @parser.evaluate_property
    assert_equals result, Array
    init "class of [1,2,3]"
    @parser.expressions
    assert_equals result, Array
    skip
    parse "class of 1,2,3"
    assert_equals result, Array
  end


  def test_type2
    parse "x=1,2,3;class of x"
    assert_equals result, Array
  end


  def test_type
    parse "x=1,2,3;"
    # $verbose=true
    assert "type of x is Array"
  end

  def test_type3
    parse "x be 1,2,3;y= class of x"
    assert variables['y']==Array
    assert_equals variables['x'].type, Array
    # assert_equals variables['x'].class, Array    Variable
    # assert_equals variables['x'].kind, Array
    # assert_equals variables['y'], Array
    assert_equals variableValues['x'].class, Array
    assert_equals variableValues['x'].kind, Array
    assert_equals variableValues['y'], Array
    assert("y is a Array")
    assert("y is an Array")
    assert("y is Array")
    assert("Array == class of x")
    assert("class of x is Array")
    assert("kind of x is Array")
    assert("type of x is Array")
  end

  def test_type4
    variables['x']=[1, 2, 3]
    assert("class of x is Array")
    assert("kind of x is Array")
    assert("type of x is Array")
  end



  def test_type_cast
    # verbose
    assert_result_is "2.3",2.3
    parse "int z=2.3 as int"
    assert_equals result,2
    # parse "x='5';int z=x as int"
  end

  def test_no_type_cast
    assert_equals parse("2.3 as int").class,Fixnum# Integer
    assert_equals parse("2.3").class,Float
    # assert_equals @parser.do_evaluate("2.3").class,Float
    # assert do_evaluate("2.3 as int").class==Integer
  end
end
