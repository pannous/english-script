#!/usr/bin/env ruby
require 'test_helper'

$use_tree=false
#$use_tree=true

require_relative '../parser_test_helper'

class ConditionTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_eq
    # @variables['counter']=3
    # assert "counter == 3"
    init 'counter = 3'
    condition
    assert 'counter = 3'
    assert 'counter =3'
    assert 'counter is 3'
    assert 'counter equals 3'
    assert 'counter is the same as 3'
  end

  def test_if_statement
    init 'everything is fine;'
    ok=@parser.block
    assert ok
    p variables
    assert_equals variables['everything'], 'fine'
    init 'if x is smaller than three then everything is fine;'
    @parser.if_then
    parse 'x=2;if x is smaller than three then everything is fine;'
    assert 'everything is fine'
    # parse "x=2;if x is smaller than three everything is fine;" 'then' keyword needed! (why?)
    # assert "everything is fine"
  end

  def test_list_quantifiers
    check=parse 'x is 2; if all 0,1,2 are smaller 3 then increase x'
    assert_equals check, 3
    check=parse 'x=2;if all 0,1,2 are smaller 2 then x++'
    assert_equals check,false # if false then true returns false !
    check=parse 'x=2;if one of 0,1,2 is smaller 3 then x++'
    assert_equals check, 3
    check=parse 'x=2;if many of 0,1,2 are smaller 3 then x++'
    assert_equals check, 3
    check=parse 'x=2;if many of 0,1,2 are smaller 1 then x++'
    assert_equals check,false
    check=parse 'x=2;if none of 0,1,2 is smaller 3 then x++'
    assert_equals check,false
  end


  def test_and
    assert parse 'x=2;if x is smaller 3 and x is bigger 1 then true'
    assert parse 'x=2;if x is smaller 3 but not x is smaller 1 then true'
    assert parse 'x=2;if x is smaller 3 and x is bigger 2 then true'==false
    assert parse 'x=2;if x is smaller 3 and x is bigger 2 then "DONT REACH" else true'==true
  end

  def test_no_rollback
    assert parse 'x=2;if x is smaller 3 and x is bigger 1 then for end'
  end

  def test_it
    assert parse 'x=1+1;if it is 2 then true'
  end

  def test_or
    assert parse 'x=2;if x is smaller 1 or x is bigger 1 then true'
  end

  def test_either_or
    assert parse 'x=2;if either x is smaller 1 or x is bigger 1 then true'
    # assert parse 'x=2;if x is either smaller 1 or bigger 8 then true'
  end

  def test_if_smaller
    parse 'x=2;if x is smaller 3 then x++'
    assert_equals variables['x'], 3
    parse 'x=2;if x is smaller three then x++'
    assert_equals variables['x'], 3
    parse 'x=2;if x is smaller three then x++'
    assert_equals variables['x'], 3
    parse 'x=2;if x is smaller than three then x++'
    assert_equals variables['x'], 3
    parse 'x=2;if x is smaller than three x++'
    assert_equals variables['x'], 3
  end

  def test_if_in_loop
    parse 'c=0;while c<3:c++;if c>1 then beep;done'
  end

  def test_if
    $verbose=true
    init 'if 1>0 then: beep;'
    @parser.if_then
    parse 'if 1>0 then: beep;'
    assert_equals @result, 'beeped'
    init 'one is bigger than zero'
    ok=@parser.condition
    assert_equals ok, true
    assert 'one is bigger than zero'
    parse 'if one is bigger than zero then beep'
    assert_equals @result, 'beeped'
    parse 'if 1>0 then beep'
    assert_equals @result, 'beeped'
    parse 'if 1>0 then: beep'
    assert_equals @result, 'beeped'
    parse 'if 1>0 then: beep;end'
    assert_equals @result, 'beeped'
    parse "if 1>0\n beep\nend"
    assert_equals @result, 'beeped'
    parse 'if 1>0 beep' #optional, remove if test fails
    assert_equals @result, 'beeped'
  end

end

