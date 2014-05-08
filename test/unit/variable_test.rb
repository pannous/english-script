#!/usr/bin/env ruby

require_relative '../test_helper'

class VariableTestParser < EnglishParser

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

  def current
    test_local_variables_changed_by_subblocks
  end
end


class VariableTest < Test::Unit::TestCase

  def initialize args
    @testParser=VariableTestParser.new
    super args
  end

  def self._test x
    puts "NOT testing "+x.to_s
  end

  def test_all
    @testParser.methods.each { |m|
      if m.to_s.start_with? "test"
        @testParser.send(m)
      end
    }
  end

  def test_current
    @testParser.current
  end
end
