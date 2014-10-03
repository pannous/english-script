#!/usr/bin/env ruby
# $use_tree=true
require_relative '../parser_test_helper'

class VariableTest  < ParserBaseTest

  include ParserTestHelper

  def test_a_setter_article_vs_variable #
    parse "a=green"
    assert_equals(variables["a"],"green")
    parse "a dog=green"
    assert_equals(variables["dog"],"green")
  end


  def test_variableTypes
    init "an integer i"
    @parser.variable
  end

  def test_variable_type_safety
    parse "int i=3"
    parse "an integer i;i=3"
    parse "int i;i=3"
    parse "char i='c'"
    parse "char i;i='c'"
    assert_has_error "string i=3"
    assert_has_error "int i='hi'"
    assert_has_error "integer i='hi'"
    assert_has_error "an integer i;i='hi'"
    assert_has_error "const i=1;i=2"
    assert_has_error "const i=1;i='hi'"
    assert_has_error "const i='hi';i='ho'"
  end

  def test_vars
    variables['counter']=3
    init "counter=3"
    assert @parser.condition #don't change var!
    assert "counter=3"
    parse "counter =2"
    assert_equals variables['counter'],2
    # fix_variables string->symbol
    assert_equals variables[:counter],2
  end

end

