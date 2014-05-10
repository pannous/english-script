#!/usr/bin/env ruby

$use_tree=false
#$use_tree=true
require_relative '../parser_test_helper'

class StringTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper


  def test_string_methods
    parse "invert 'hi'"
    assert_equals @result,"ih"
  end

  def test_nth_word
    assert "3rd word in 'hi my friend !!!' is 'friend'"
  end


  def _test_advanced_string_methods
    parse "x='hi' inverted"
    assert @result=="ih"
    assert(@variables['x']== 'ih');
  end


  def _test_select_character
    assert "first character of 'hi' is 'h'"
    assert "second character of 'hi' is 'i'"
    assert "last character of 'hi' is 'i'"
  end

  def _test_select_word
    assert "first word of 'hi you' is 'hi'"
    assert "second word of 'hi you' is 'you'"
    assert "last word of 'hi you' is 'you'"
  end

  def test_gerunds
    init "gerunding"
    x=gerund
    init "gerunded"
    x=postjective
    x
  end

  def test_concatenation
    init "x is 'hi'"
    setter
    assert(@variables['x']== 'hi');
    init "x + 'world'"
    #algebra
    #statement
    root
    parse "x + ' world'"
    assert @result=="hi world"
    parse "x is 'hi'
       y is ' world'
       z is x + y"
    assert(@variables['z']== 'hi world');
  end

  def test_concatenation2
    # todo !
    assert("z = x and y");
    assert(@variables['z']== 'hi world');
    assert("x and y == 'hi world'");
    assert("x + y == 'hi world'");
    assert("x plus y == 'hi world'");
    assert("'hi'+ ' '+'world' == 'hi world'");
    assert("z is 'hi world'");
    parse "x is 'hi'; y is 'world';z is x ' ' y"
    assert("z is 'hi world'");
    parse "x is 'hi'; y is 'world';z is x plus ' ' plus y"
    assert("z is 'hi world'");
    parse "x is 'hi'; y is 'world';z is x and ' ' and y"
    assert("type of z is string or type of z is list")
    #assert("type of z is string or list") // !+!+!
    assert("z is 'hi world' OR z is 'hi',' ','world'");
  end


  def test_type1
    init "class of 'hi'"
    evaluate_property
    assert @result==String
    init "class of 'hi'"
    expression0
    assert @result==String
    parse "class of 'hi'"
    assert @result==String
  end


  def test_type2
    parse "x='hi';
      class of x"
    parse "x='hi';class of x"
    assert @result==String
  end


  def test_result
    parse "x be 'hello world';show x;x; class of x"
    assert("type of x is string")
    assert("class of x is string")
    #assert("kind of x is string")
    parse "y is type of x"
    assert("y is string")
  end


  def test_type
    parse "x='hi'"
    assert "type of x is string"
  end

  def test_type3
  parse "x be 'hello world';show x;x;y= class of x"
    assert @variables['y']==String
    assert("type of x is string")
    assert("class of x is string")
    assert("kind of x is string")
    parse "y is type of x"
    assert("y is string")
  end

end
