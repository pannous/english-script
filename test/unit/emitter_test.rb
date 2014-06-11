#!/usr/bin/env ruby

$use_tree=true
$verbose=true

require_relative '../parser_test_helper'

class EmitterTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_printf
    $use_tree=true
    @parser.dont_interpret!
    # parse "printf 'hi' "
    # parse "printf hello world"
    parse "printf 'hello world'"
    # parse "print 'hello world'"
    # parse "printf('hi')"
    # parse "x=nil;printf 'hi'"
    # parse "x=7"#";printf 'hi'"
    # parse "x=false"#";printf 'hi'"
    interpretation= @parser.interpretation || Interpretation.new
    @parser.full_tree
    # @parser.show_tree
    # parse "x='hi';printf('hi')"
    NativeEmitter.new.emit interpretation,run:true
    # assert "type of x is string"
  end

end
