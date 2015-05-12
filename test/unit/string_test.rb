#!/usr/bin/env ruby

$use_tree=false
# $use_tree=true
$verbose =false

require_relative '../parser_test_helper'

class StringTest < ParserBaseTest

  include ParserTestHelper


  def test_string_methods
    parse "invert 'hi'"
    assert_equals @result, "ih"
  end

  def test_nth_word
    assert "3rd word in 'hi my friend !!!' is 'friend'"
  end


  def _test_advanced_string_methods
    parse "x='hi' inverted"
    assert @result=="ih"
    assert(@variableValues['x']== 'ih');
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
    x=@parser.gerund
    init "gerunded"
    x=@parser.postjective
    x
  end

  def test_concatenation
    @parser.do_interpret!
    parse "x is 'Hi'; y is 'World';z is x plus y"
    assert_equals variables["z"], 'HiWorld'
  end

  def test_concatenation_b
    init "x is 'hi'"
    @parser.setter
    assert(variables['x']== 'hi');
    init "x + ' world'"
    r=@parser.algebra
    assert_equals r,"hi world"
    #statement
    # @parser.root
    parse "x + ' world'"
    assert_equals result,"hi world"

    parse "y is ' world'"
    parse "z is x + y"
    assert_equals(variables['z'],'hi world');
    parse "y is ' you'
       z is x + y"
    assert_equals(variables['z'],'hi you');
  end

  def test_concatenation_b
    init "x is 'hi'"
    @parser.setter
    assert(variables['x']== 'hi');
    init "x + ' world'"
    r=@parser.algebra
    assert_equals r,"hi world"
    #statement
    # @parser.root
    parse "x + ' world'"
    assert_equals result,"hi world"

    parse "y is ' world'"
    parse "z is x + y"
    assert_equals(variables['z'],'hi world');
  end

  def test_concatenation_c
    parse "x is 'hi'"
    parse "y is ' you'"
    parse "z is x + y"
    # parse "y is ' you';
    #    z is x + y"
    assert_equals(variables['z'],'hi you');
  end

  def test_newline_statements
    parse "x is 'hi';
           z='ho'"
    assert_equals(variables['z'],'ho');
  end

  def test_concatenation_c3
    parse "x is 'hi'"
    parse "y is ' you';z is x + y"
    assert_equals(variables['z'],'hi you');
  end


  def DONT_test_concatenation_by_and
    parse("z = x and y");
    assert(variables['z']== 'hi world');
    assert("x and y == 'hi world'");
    parse "z is x and ' ' and y"
    assert("type of z is string or list")
  end


  def dont_test_list_concatenation
    # 'abc' == 'a' 'b' 'c'
    # really ? or 'a' 'b' 'c' == ['a','b','c'] ??
    # really ? or 'a' 'b' 'c' == 'a b c' ??
    init "'hi' ' ' 'world'"
    z=@parser.expressions
    assert_equals z, 'hi world'

    variables['x']='hi'
    variables['y']='world'
    init "z=x ' ' y"
    # z=@parser.expression0
    # assert z=@parser.root #todo ooo
    z=@parser.setter
    assert_equals z, 'hi world'

    parse "x is 'hi'; y is 'world';z is x ' ' y"
    assert("type of z is string or type of z is list")
    assert("type of z is string or list")
    assert_equals variables["z"], 'hi world' #NICE TODO!
    assert("z is 'hi world' OR z is 'hi',' ','world'");
  end

  def test_concatenation2
    parse "x is 'hi'; y = ' world'"
    assert_equals(parse("x + y"), "hi world");
    assert("x plus y == 'hi world'");
  end

  def test_concatenation2b
    assert_equals(parse("'hi'+ ' '+'world'"),'hi world');
    assert_result_is("'hi'+ ' '+'world'","'hi world'");
    parse "x is 'hi'; y is 'world';z is x plus ' ' plus y"
    assert_equals variables["z"], 'hi world'
    assert("z is 'hi world'");
  end

  def test_type
    parse "x='hi'"
    assert_result_is "type of x", String
    assert "type of x is string"
  end

  def test_type3
    parse "x be 'hello world';"
    # assert variables['y']==String
    assert("x is a string")
    assert("type of x is string")
    assert("class of x is string")
    assert("kind of x is string")
    parse "y= class of x"
    assert variables['y']==Quote
    assert("y is string")
    parse "y is type of x"
    assert("y is string")
  end

  def test_type1
    init "class of 'hi'"
    @parser.evaluate_property
    assert_equals result, Quote
    # assert_equals result,String todo!
    init "class of 'hi'"
    @parser.expressions
    assert_equals result, Quote
    # assert_equals result,String
    parse "class of 'hi'"
    assert_equals result, Quote
    # assert result==String
  end


  def test_type2
    parse "x='hi';
      class of x"
    parse "x='hi';class of x"
    assert_equals result, Quote
    # assert result==String
  end


  def test_result
    parse "x be 'hello world';show x;x; class of x"
    assert("type of x is string")
    assert("class of x is string")
    #assert("kind of x is string")
    parse "y is type of x"
    assert("y is string")
  end


end
