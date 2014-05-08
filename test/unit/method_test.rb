#!/usr/bin/env ruby

#$use_tree=true

require_relative '../test_helper'

class StringTestParser<EnglishParser

  def initialize

    super
  end

  def test_result
    parse "how to test:show 3;ok"
    assert @methods.count>0
    assert @methods.last.name=="test"
    parse "test"
    assert @result=="3"
    #assert @variables['x']==3
  end

  def test
    puts "Starting tests!"
    begin
      test_result
      show_tree
      puts "++++++++++++++++++\nPARSED successfully!"
    rescue => e
      error e
    end
  end

end


class StringTestTest < Test::Unit::TestCase

  def initialize args
    @testParser=StringTestParser.new
    super args
  end

  def self._test x
    puts "NOT testing "+x.to_s
  end

  test "ALL" do
    @testParser.methods.each{|m|
      if m.to_s.start_with?"test"
        @testParser.send(m)
      end
    }
  end

end
