#!/usr/bin/env ruby
require 'test_helper'
#require '../test_helper'

$use_tree=false
#$use_tree=true

#require_relative "../core/english-parser"
require_relative "../../core/english-parser"

class ObserverTestParser<EnglishParser

  def initialize
    @@testing=true
    super
  end

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

  def current
  end

end

class ObserverTest < Test::Unit::TestCase

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
    @testParser=ObserverTestParser.new
    super args
  end

  _test "ALL" do
    @testParser.methods.each{|m|
      if m.to_s.start_with?"test"
        @testParser.send(m)
      end
    }
  end

  test "current" do
    @testParser.current
  end

end
