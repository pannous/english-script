#!/usr/bin/env ruby
$use_tree=false
#$use_tree=true

require_relative '../parser_test_helper'

class LoopTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper


  def _test_forever # OK ;{TRUST ME;}
    init 'beep forever'
    loops
    parse 'beep forever' # OK ;{TRUST ME;}
  end


  def test_loops  #OK
    parse 'beep three times' #OK
    parse "repeat three times: beep; okay" #OK
    parse "repeat three times: beep"       #OK
  end

  def test_try_until
    parse 'repeat while x<4: x++'
    assert_equals @variables[:x],4
    parse 'repeat x++ while x<4'
    assert_equals @variables[:x],4
    parse 'repeat x++ until x>4'
    assert_equals @variables[:x],5
    parse 'repeat until x>4: x++'
    assert_equals @variables[:x],5
    parse 'try until x>4: x++'
    assert_equals @variables[:x],5
    parse 'try while x<4: x++'
    assert_equals @variables[:x],4
    parse "try x++ until x>4"
    assert_equals @variables[:x],5
    parse "try x++ while x<4"
    assert_equals @variables[:x],4
    parse 'increase x until x>4'
    assert_equals @variables[:x],5
  end

  def test_every_date
    parse 'beep every three seconds'
    parse 'every three seconds make a beep'
  end

  def test_expressions
    #s "counter=0"
    #setter
    parse 'counter=1'
    #counter=@variables['counter']
    #@variables['counter']=1
    #parse "counter+1"
    #r=expression0
    assert(@variables['counter']==1)
    parse 'counter++'
    #r=expression0
    assert(@variables['counter']==2)
    #@variables['counter']=2
    parse 'counter+=1'
    #r=plusEqual
    #r=expression0
    assert(@variables['counter']==3)
    parse 'counter=counter+counter'
    #r=setter
    #r=algebra
    #r=expression0
    counter=@variables['counter']
    assert counter==6
  end

  def test_repeat # NEEEEDS blocks!! Parser.new(block)
    parse "counter =0; repeat three times: increase the counter; okay"
    assert_equals @variables['counter'],3
    assert_equals @variables[:counter],3
    assert "counter =3"
    #s "counter=counter+1;"
    #@interpret=false
    #action
    #@interpret=true
    parse 'counter =0; repeat three times: counter=counter+1; okay'
    assert 'counter =3' #if $use_tree # counter=counter+1 not repeatable as string
    parse 'counter =0; repeat three times: counter+=1; okay'
    assert 'counter =3'
    parse 'counter =0; repeat three times: counter++; okay'
    counter=@variables['counter']
    assert 'counter =3'
    #parse "counter =0; repeat three times: increase the counter by two; okay"
    #assert "counter =10"
  end

  def _test_forever # OK ;{TRUST ME;}
    @parser.s 'beep forever'
    @parser.loops
  end
end
