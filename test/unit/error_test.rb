#!/usr/bin/env ruby
# HERE NOT encoding: utf-8

$use_tree=false
$verbose =false
# $verbose=true
require_relative '../parser_test_helper'

class ErrorTest < ParserBaseTest

  include ParserTestHelper

  def test_type #todo
    assert_has_error "x=1,2,y;" # at:3y= in:list type:unknownVariable:y
  end

  def test_variable_type_safety_errors2
    assert_has_no_error "char i='c'"
    assert_has_no_error "char i;i='c'"
  end

  def test_variable_type_safety_errors
    assert_has_no_error "an integer i;i=3"
    assert_has_no_error "int i=3"
    assert_has_no_error "int i;i=3"
    assert_has_error "const i=1;i=2"
    assert_has_error "string i=3"
    assert_has_error "int i='hi'"
    assert_has_error "integer i='hi'"
    assert_has_error "an integer i;i='hi'"
    assert_has_error "const i=1;i='hi'"
    assert_has_error "const i='hi';i='ho'"
  end

  def test_assert_has_error
    begin
      assert_has_no_error "dfsafdsa ewdfsa}{P}{P;@#%"
    rescue
      assert_has_error "dfsafdsa ewdfsa}{P}{P;@#%"
      puts "OK, HAS ERROR"
    end
  end

  def test_type3
    assert_has_error "x be 1,2,3y= class of x" # at:3y= in:list
  end

  def test_map
    assert_has_error("square 1,2 andy 3") # at:andy in:list
  end

  def test_x
    parse "x"
  end

  def test_endNode_as
    init "as"
    @parser.arg rescue
        assert_has_error "as"
  end


  def test_rollback
    assert_has_error('if 1>0 then else');
  end

  def test_endNode
    # init "of"
    # @parser.word
    assert_has_error "of"
  end

  def test_list_concatenation_unknownVariable
    variables['x']='hi'
    variables['y']='world'
    assert_has_error "z=x ' ' w"
    skip #todo
    assert "z=x ' ' y"
    assert_has_error "z=x ' ' y" #tdod NOO
    assert_has_no_error "z=x ' ' y" #setter OK!?!
  end

end
