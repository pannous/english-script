#!/usr/bin/env ruby

$use_tree=false
#$use_tree=true

require_relative '../parser_test_helper'

class ConditionTest  < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_eq
    @variables['counter']=3
    # assert "counter == 3"
    init "counter = 3"
    condition
    assert "counter = 3"
    assert "counter =3"
    assert "counter is 3"
    assert "counter equals 3"
    assert "counter is the same as 3"
  end

  def test_if_statement
    init "everything is fine;"
    ok=@parser.block
    assert ok
    p variables
    assert_equals variables['everything'],'fine'
    init "if x is smaller than three then everything is fine;"
    @parser.if_then
    parse "x=2;if x is smaller than three then everything is fine;"
    assert "everything is fine"
    # parse "x=2;if x is smaller than three everything is fine;" 'then' keyword needed! (why?)
    # assert "everything is fine"
  end

  def test_if_smaller
    parse "x=2;if x is smaller 3 then x++"
    assert_equals variables['x'],3
    parse "x=2;if x is smaller three then x++"
    assert_equals variables['x'],3
    parse "x=2;if x is smaller three then x++"
    assert_equals variables['x'],3
    parse "x=2;if x is smaller than three then x++"
    assert_equals variables['x'],3
    parse "x=2;if x is smaller than three x++"
    assert_equals variables['x'],3
  end

  def test_if_in_loop
    parse "c=0;while c<3:c++;if c>1 then beep;done"
  end

  def test_if
    init "one is bigger than zero"
    ok=condition
    assert_equals ok,true
    assert "one is bigger than zero"
    parse "if one is bigger than zero then beep"
    assert @result=="beeped"
    parse "if 1>0 then beep"
    assert @result=="beeped"
    parse "if 1>0 then: beep"
    assert @result=="beeped"
    parse "if 1>0 then: beep;"
    assert @result=="beeped"
    parse "if 1>0 then: beep;end"
    assert @result=="beeped"
    parse "if 1>0\n beep\nend"
    assert @result=="beeped"
    parse "if 1>0 beep" #optional, remove if test fails
    assert @result=="beeped"
  end

end

