#!/usr/bin/env ruby
# encoding: utf-8
# require 'test_helper'

$use_tree=false

require_relative '../parser_test_helper'

class FunctionTest < ParserBaseTest

  include ParserTestHelper

  def test_basic_syntax
      assert_result_is "print 'hi'",'nill' #hi'
  end

  def test_complex_syntax
    init "here is how to define a method: done"
  end

  def test_block
    # variables[:x]=1
    # variables[:y]=2
    variables["x"]=1
    variables["y"]=2
    assert_equals @parser.variables.count,2
    z=parse("x+y;")
    assert_equals z,3
  end

  def test_params
    parse("how to increase x by y: x+y;")
    g=functions["increase"]
    args=[Argument.new(name: "x", preposition: "", position: 1),Argument.new(name: "y", preposition: "by", position: 2)]
    f=Function.new(name: "increase", body:"x+y;",arguments: args)
    assert_equal f, g
    assert_equals @parser.call_function(f,{x:1,y:2}),3
    # assert_equals @parser.call_function(f,1,2),3
    # assert_equals f.call(1,2),3
  end

  def test_function_object
    parse("how to increase a number x by y: x+y;")
    g=functions["increase"]
    arg1=Argument.new(name: "x",type:"number",preposition: "", position: 1)
    arg2=Argument.new(name: "y",preposition: "by",position: 2)
    f=Function.new(name: "increase", body:"x+y;",object: arg1,arguments:arg2)
    # f=Function.new(name: "increase", body:"x+y;",arguments: [arg1,arg2])
    assert_equal f, g
    assert_equals @parser.call_function(f,{x:1,y:2}),3
    # assert_equals @parser.call_function(f,1,2),3
    # assert_equals f.call(1,2),3
  end

  def test_blue_yay
    assert_result_is "def test{puts 'yay'};test","yay"
  end

  def test_class_method
    parse("how to list all numbers smaller x: [1..x]")
    g=functions["list"]
    f=Function.new(name: "list", body:"[1..x]",object: arg1,arguments:arg2)
    # f=Function.new(name: "increase", body:"x+y;",arguments: [arg1,arg2])
    assert_equal f, g
    assert_equals @parser.call_function(f,4),[1,2,3]
    # assert_equals @parser.call_function(f,1,2),3
    # assert_equals f.call(1,2),3
  end

  def test_simple_parameters
    parse("puts 'hi'")
  end

  def test_to_do_something #at a given point
    #s <name of the test>
  end


  def test_svg
    skip
    parse 'svg <circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/>'
    parse 'what is that'
  end

  def test_java_style
    parse "1.add(0)"
  end

  # def ⦠
  # swift!
  # end

  def test_dot
    parse "x='hi'"
    assert_result_is "reverse of x","ih"
    assert_result_is "x.reverse","ih"
    assert_result_is "reverse x","ih"
  end

  def test_rubyThing
    parse "Math.hypot (3,3)"
    parse "Math.sqrt 8"
    parse "Math.sqrt( 8 )"
    parse "Math.ancestors"
  end

  def test_add_to_zero
    variables['x']=7
    init "x"
    assert_equals @parser.nod, "x" #Variable.new "x"
    # 0->false->"" ERROR!!!
    parse "counter is zero; repeat three times: increase counter by 1; done repeating;"
    assert_equals variables['counter'], 3
    # parse "counter is zero; repeat three times: add 1 to counter; done repeating;"
    assert "the counter is 3"
  end

  def test_array_arg
    assert_equals((parse "rest of [1,2,3]"), [2, 3])
    # assert parse "rest of [1,2,3]"==[2,3]
  end


  def test_array_index
    assert_equals((parse "[1,2,3][2]"), 3) # ruby index: 0,1,2
    assert_equals((parse "x=[1,2,3];x[2]"), 3) # ruby index: 0,1,2
    assert_equals((parse "x=[1,2,3];x[2]=0;x"), [1, 2, 0]) # ruby index: 0,1,2
  end

  def test_natural_array_index
    parse "x=[1,2,3]"
    assert_equals((parse "second element in [1,2,3]"), 2) # english index: 1,2,3 !!!!
    assert_equals((parse "third element in x"), 3) # english index: 1,2,3 !!!!
    assert_equals((parse "set third element in x to 8"), 8) # english index: 1,2,3 !!!!
    assert_equals(parse("x"),[1,2,8])
  end


  def test_array_arg
    assert_equals((parse "rest of [1,2,3]"), [2, 3])
    # assert parse "rest of [1,2,3]"==[2,3]
  end

  def test_add_time
    # parse "now plus 1 minute"
  end

  def test_add
    # parse "counter is one; repeat three times: increase counter; done"
    parse "counter is one; repeat three times: increase counter; done repeating;" #todo done labeled
    assert_equals variables['counter'], 4
  end


  def _test_svg_dom
    init '<svg><circle cx="$x" cy="50" r="$radius" stroke="black" fill="$color" id="circle"/></svg>'
    puts @parser.interpretation.svg
    parse "circle.color=green"
    assert_equals("circle.color", "green")
  end


end
