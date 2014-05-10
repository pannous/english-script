#!/usr/bin/env ruby

$use_tree=false
#$use_tree=true

require_relative '../parser_test_helper'

class ObserverTest  < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_whenever
    parse "beep whenever x is 5"
    parse "beep once x is 5"
    parse "once x is 5 do beep"
    parse "once x is 5 beep "
    parse "x is 5"
    parse "beep whenever that clock shows five seconds"
    parse "whenever that clock shows five seconds do beep"
    #parse "whenever that clock shows five seconds beep"
    assert @result=="1/3"
  end

end
