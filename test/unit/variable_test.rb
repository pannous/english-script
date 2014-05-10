#!/usr/bin/env ruby

require_relative '../parser_test_helper'

class VariableTest  < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_property_setter
    parse "circle.color=green"
    assert_equals("circle.color","green")
  end

  def test_local_variables_changed_by_subblocks
    parse "x=2;def test\nx=1\nend\ntest"
    assert "x=2 or x=1?"
    parse "x=1;x=2;"
    assert "x=2"
    parse "x=1;while x<2 do x=2;"
    assert "x=2"
    # parse "x=1;try x=2;"
    # assert "x=2"
  end

  def test_vars # NEEEEDS blocks!! Parser.new(block)
    @variables['counter']=3
    s "counter =3"
    condition
    assert "counter =3"
    # @variables[:counter]=3
    # assert "counter =3"
    parse "counter =2"
    assert_equals @variables['counter'],2
    # fix_variables string->symbol
    # assert_equals @variables[:counter],2
  end

end

