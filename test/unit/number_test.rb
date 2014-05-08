#!/usr/bin/env ruby

# $use_tree=true
$use_tree=false
# $verbose=true

require_relative '../test_helper'
# require 'test_helper'


class NumberTestParser<EnglishParser

  def initialize

    super
  end

  def test_failing
    # Copy stuff hear for faster debugging
  end

  def test_type1
    puts parse "class of 1"
    assert_equals @result,Fixnum
    parse "class of 3.3"
    assert @result==Float
  end

  def test_type2
    assert "3.2 is a Numeric"
    assert "3.2 is a Float"
    assert "3.2 is a float"
    assert "3.2 is a real"
    assert "3.2 is a float number"
    assert "3.2 is a real number"
    # assert "3.2 is not an integer"
  end

  def test_type3
    assert "3 is a Fixnum"
    assert "3 is a Numeric"
    assert "3 is a Integer"
    assert "3 is a Number"
  end

  def test_english_number_types
    # todo !
    assert "3.2 is a number"
    assert "3.2 is a real number"
    assert "3.2 is a real"
    assert "3.2 is a float"
    assert "3.2 is a float number"
    assert "3 is a number"
    assert "3 is a integer"
    assert "3 is an integer"
  end

  def _test_int_methods
    parse "invert 3"
    assert @result=="1/3"
  end

  def current
    # test_failing
    test_type1
    # test_type2
    # test_type3
  end

end

class NumberTest < Test::Unit::TestCase

  def NOmethod_missing(sym, *args, &block) # <- NoMethodError use node.blah to get blah!
    syms=sym.to_s
    if @testParser and @testParser.methods.contains(sym)#(syms.end_with?"?")
      x= try { @testParser.send(sym) } if args.count==0
      x= try { @testParser.send(sym,args[0]) } if args.count==1
      x= try { @testParser.send(sym, args) } if args.count>0
      return x
    end
    super(sym, *args, &block)
  end

  def self._test x
    puts "NOT testing "+x.to_s
  end

  def initialize args
    @testParser=NumberTestParser.new
    super args
  end

  def test_current
      @testParser.current
  end

  def test_all
    @testParser.methods.each{|m|
      if m.to_s.start_with?"test"
        @testParser.send(m)
      end
    }
  end


  # def test_all
  #   @testParser.methods.each{|m|
  #     if m.to_s.start_with?"test"
  #       @testParser.send(m)
  #     end
  #   }
  # end
  #
  # def test_current
  #   @testParser.current
  # end

end
