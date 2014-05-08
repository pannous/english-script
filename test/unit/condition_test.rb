#!/usr/bin/env ruby

$use_tree=false
#$use_tree=true

require_relative '../test_helper'

class ConditionTestParser<EnglishParser
  def current
    test_if_in_loop
    #test_loops
    #test_forever
    #test_expressions
    #test_if
  end
  def test_if_in_loop
    parse "c=0;while c<3:c++;if c>1 then beep;done"
  end

  def test_if
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

    parse "if one is bigger than zero then beep"
    assert @result=="beeped"
    #parse "if 1>0 beep"
    #assert @result=="beeped"
  end

end


class ConditionTest < Test::Unit::TestCase

  def self._test x
    puts "NOT testing "+x.to_s
  end

  def initialize args
    @testParser=ConditionTestParser.new
    super args
  end

  def test_all
    @testParser.methods.each { |m|
      if m.to_s.start_with? "test"
        @testParser.send(m)
      end
    }
  end

  # def test_current
  #   @testParser.current
  # end

end
