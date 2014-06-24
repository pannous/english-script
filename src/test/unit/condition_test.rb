#!/usr/bin/env ruby
# require 'test_helper'

$use_tree=$emit
# $use_tree=true
$use_tree=false
# $verbose =true

require_relative '../parser_test_helper'

class ConditionTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_eq
    variables['counter']=3
    assert "counter == 3"
    assert "counter = 3"
    init 'counter = 3'
    @parser.condition
    assert 'counter = 3'
    assert 'counter =3'
    assert 'counter is 3'
    assert 'counter equals 3'
    assert 'counter is the same as 3'
  end

  def test_return
    assert_result_is "if(1<2) then 3 else 4", 3
    assert_result_is "if 1<2 then 5 else 4", 5
    assert_result_is "if(3<2) then 3 else 4", 4
    assert_result_is "if 3<2 then 5 else 4", 4
    assert_result_is "if 1<2 then false else 4", "false"
  end

  def test_else_
    assert_result_is "if(1<2) then 3 else 4", 3
    assert_result_is "if 1<2 then 5 else 4", 5
    assert_result_is "if(3<2) then 3 else 4", 4
    assert_result_is "if 3<2 then 5 else 4", 4
    assert_result_is "if 1<2 then false else 4", "false"
    # assert_result_is "if 1<2 then false else 4",:false
    # assert_result_is "if 1<2 then false else 4",false
  end


  def dont_test_everything_is_fine
    #everything as quantifier!!!
    # TODO: NOTHING! would be dangerous!
    # is "rm -rf /" fine ?? YES, because 'everything is fine'
    init 'everything is fine;'
    ok=@parser.block
    init 'everything is fine'
    @parser.condition
    assert 'everything is fine'
  end

  def test_if_statement
    init 'if x is smaller than three then everything is fine;'
    @parser.if_then
    assert_equals variables['everything'], 'fine'
    parse 'x=2;if x is smaller than three then everything is good;'
    puts variables["everything"]
    assert_equals variables['everything'], 'good'
    # parse "x=2;if x is smaller than three everything is fine;" 'then' keyword needed! (why?)
    # assert "everything is fine"
  end

  def test_list_quantifiers
    check=parse 'x is 5; if all 0,1,2 are smaller 3 then increase x'
    assert_equals check, 6
  end

  def test_list_quantifiers2
    check=parse 'x=2;if all 0,1,2 are smaller 2 then x++'
    assert_equals check, false # if false then true returns false !
    check=parse 'x=2;if one of 0,1,2 is smaller 3 then x++'
    assert_equals check, 3
    check=parse 'x=2;if many of 0,1,2 are smaller 3 then x++'
    assert_equals check, 3
    check=parse 'x=2;if many of 0,1,2 are smaller 1 then x++'
    assert_equals check, false
    check=parse 'x=2;if none of 0,1,2 is smaller 3 then x++'
    assert_equals check, false
  end

  def test_assert
    assert parse "assert 3rd word in 'hi my friend' is 'friend'"
  end

  def test_and
    assert parse 'x=2;if x is smaller 3 and x is bigger 1 then true'
  end


  def test_and1
    assert parse 'x=2;if x is smaller 3 but not x is smaller 1 then true'
  end

  def test_and2
    assert parse 'x=2;if x is smaller 3 and x is bigger 3 then "DONT REACH" else true'
  end

  def test_and22
    # verbose
    assert_result_is 'x=2;if x is smaller 3 and x is bigger 1 then 4 else 5', 4
  end

  def test_and3
    assert_result_is 'x=2;if x is smaller 3 and x is bigger 3 then 4 else 5', 5
  end

  def test_no_rollback
    assert_has_error 'x=2;if x is smaller 3 and x is bigger 1 then for end'
  end

  def test_it_result
    assert parse 'x=1+1;if it is 2 then true'
    assert_result_is 'x=3;it*2', 6
    assert_result_is '3;it*2', 6
    assert_result_is '2*it', 12
    assert_result_is 'it*2', 24
    assert_result_is '6;that*2', 12
    assert_result_is '6;2*result', 12
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


  def test_if_return
    assert_equals parse('if 1>0 then beep'), "beeped"
    assert_equals parse('if 1>0 then beep else 0'), "beeped"
    assert_equals parse('return if 1'), 1 # shorthand for return expression_or_block if expression_or_block != null
  end

  def assert_c_ok
    variables['c']=0
    # @parser.verbose=1
    z             = parse "if c>-1 then beep;"
    assert_equals z, "beeped"
    z= parse "c++;if c>1 then beep;"
    assert_equals z, false
    @parser.do_interpret!
    z= parse "c++;if c>1 then beep;"
    assert_equals z, "beeped"
    init "c++"
    @parser.do_interpret!
    c2=@parser.block
    # c2=@parser.do_execute_block b
    assert_equals c2, 3
    assert_equals variables['c'], 3
  end

  def test_if_in_loop
    assert_c_ok
    assert_equals parse('c=0;while c<3:c++;if c>1 then beep;done'), "beeped"
  end

  def test_rollback
    parse('if 1>0 then else');
  end

  def test_comparisons
    # init '1>0'
    # ok=@parser.condition
    # init '1 is bigger than 0'
    # ok=@parser.condition
    init 'two is bigger than zero'
    ok=@parser.condition
    # init 'one is bigger than zero' #todo quantifier ambivalence!!
    # ok=@parser.condition
    assert_equals ok, true
  end

  def test_if_then
    # $verbose=true
    init 'if 1>0 then: beep;'
    @parser.if_then
    parse 'if 1>0 then: beep;'
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
    parse 'if two is bigger than zero then beep'
    assert_equals @result, 'beeped'
  end

  def test_root
    parse "1==1"
  end

  def test_complicated
    parse "x is 2; if all 0,2,4 are smaller 5 then increase x; assert x equals 3"
    assert @result
  end

end

module EmitterTestHelper
  $emit=true
end

class EmittedConditionTest < ConditionTest

  include EmitterTestHelper

end
