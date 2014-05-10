#!/usr/bin/env ruby
$use_tree=false
$verbose=false
# $verbose=true
require_relative '../parser_test_helper'

class ListTestParser < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_type0
    init "1 , 2 , 3"
    assert_equals @parser.list,[1, 2, 3]
    init "1,2,3"
    assert_equals @parser.list,[1, 2, 3]
    init "[1,2,3]"
    assert_equals @parser.list,[1, 2, 3]
    init "{1,2,3}"
    assert_equals @parser.list,[1, 2, 3]
    init "1,2 and 3"
    assert_equals @parser.list,[1, 2, 3]
    init "[1,2 and 3]"
    assert_equals @parser.list,[1, 2, 3]
    init "{1,2 and 3}"
    assert_equals @parser.list,[1, 2, 3]
  end


  def test_list_methods
    parse "invert [1,2,3]"
    assert_equals @result, [3,2,1]  # YAY!!!
  end

  def test_error
    assert_has_error "first item in 'hi,'you' is 'hi'" # quote not closed: 'hi,'y...
  end

  def test_select2
    assert "first item in 'hi','you' is 'hi'"
    assert "second item in 'hi','you' is 'you'"
    assert "last item in 'hi','you' is 'you'"
  end

  def test_select3
    assert_equals parse("1st word of 'hi','you'"),"'hi'"
    # assert "2nd word of 'hi','you' is 'you'"
    # assert "3rd word of 'hi','my','friend' is 'friend'"


    assert "1st word of 'hi','you' is 'hi'"
    assert "2nd word of 'hi','you' is 'you'"
    assert "3rd word of 'hi','my','friend' is 'friend'"
  end


  def test_select4
    assert "first word of 'hi','you' is 'hi'"
    assert "second word of 'hi','you' is 'you'"
    assert "last word of 'hi','you' is 'you'"
  end

  def test_select5
    #assert "numbers are 1,2,3. second number is 2"
    #assert "my friends are a,b and c. my second friend is b"
    #assert "first character of 'h','i','v' is 'h'"
    #assert "second character of 'h','i','v' is 'i'"
    #assert "last character of 'h','i' is 'i'"
  end

  def test_list_syntax
    assert("1,2 is [1,2]")
    assert("1,2 is {1,2}")
    assert("1,2 = [1,2]")
    assert("1,2 == [1,2]")
    assert("[1,2] is {1,2}")
  end

  def test_list_syntax2
    assert("1,2 and 3 is [1,2,3]")
    assert("1,2,3 is the same as [1,2,3]")
    assert("1,2 and 3 is the same as [1,2,3]")
    assert("1,2 and 3 are the same as [1,2,3]")
  end

  def test_concatenation
    parse "x is 1,2,3;y=4,5,6"
    assert(variables['x']== [1, 2, 3]);
    assert(variables['y'].count== 3);
    # init "x + y"
    init "x and y"
    @parser.algebra
    z=parse "x + y"
    assert_equals z.length,6
    assert_equals @result.length,6
  end

  def test_concatenation2
    parse "x is 1,2,3;y=4,5,6"
    parse "x + y"
    assert @result.length==6
    parse "x is 1,2
       y is 3,4
       z is x + y"
    assert(variables['z']== [1, 2, 3, 4]);
  end


  def test_concatenation3
    variables['x']= [1, 2];
    variables['y']= [3, 4];
    init "x + y == 1,2,3,4"
    @parser.condition
    assert("x + y == 1,2,3,4");
    assert("x plus y == [1,2,3,4]");
    assert("x and y == [1,2,3,4]")
  end

  def test_concatenation4
    # Ambiguous: 'and' also indicates I don't know what 1 and 1 = 2, NOT [1,1] OK?
    assert("1,2 and 3 == 1,2,3")
    assert_equals(parse("1 and 1"),2)
    assert("1 and 1 == 2")
  end

  def test_type1
    init "class of 1,2,3"
    @parser.evaluate_property
    assert_equals @result,Array
    init "class of [1,2,3]"
    expression0
    assert_equals @result,Array
    parse "class of 1,2,3"
    assert_equals @result,Array
  end


  def test_type2
    parse "x=1,2,3;class of x"
    assert_equals @result,Array
  end


  def test_type
    parse "x=1,2,3;"
    # $verbose=true
    assert "type of x is Array"
  end

  def test_type3
    parse "x be 1,2,3;y= class of x"
    assert variables['y']==Array
    assert_equals variables['x'].type,Array
    assert_equals variables['x'].class,Array
    assert_equals variables['x'].kind,Array
    assert("y is Array")
    assert("y is a Array")
    assert("y is an Array")
    assert("Array == class of x")
    assert("class of x is Array")
    assert("kind of x is Array")
    assert("type of x is Array")
  end

  def test_type4
    variables['x']=[1,2,3]
    assert("class of x is Array")
    assert("kind of x is Array")
    assert("type of x is Array")
  end

  def test_map
    assert("square 1,2 and 3 == 1,4,9")
    assert("square of 1,2 and 3 == 1,4,9")
    assert("square every number in 1,2,3 ==1,4,9")
    assert("add one to every number in 1,2,3 ==2,3,4")
    assert("square every number in 1,'a',3 ==1,9")
  end


end
#
# class ListTest < ParserTest
#
#   def initialize args
#     @testParser=ListTestParser.new
#     super args
#   end
#
#   def test_current
#     @testParser.current
#   end
#
# end
