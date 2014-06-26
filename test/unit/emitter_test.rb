#!/usr/bin/env ruby

$use_tree=true
# $verbose=true
$verbose=false

require_relative '../parser_test_helper'
require_relative '../../src/core/emitters/js-emitter'

class EmitterTest < ParserBaseTest

  include ParserTestHelper

  def assert_result_emitted x,r
    assert_equals parse_tree(x),parse_tree(r)
  end

  def test_js_emitter
    # init "increase x"
    # @parser.action
    assert_result_emitted 6,"x=5;increase x"
    # super
  end

  def test_type_cast
    # verbose
    assert_result_is "2.3",2.3
    parse "int z=2.3 as int"
    assert_equals result,2
    # parse "x='5';int z=x as int"
  end


  def test_printf
    skip
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

  def test_function
    assert_result_is "i=7;i minus one",6
    # parse_file "examples/factorial.e"
  end

  def test_setter
    $use_tree=true
    @parser.dont_interpret!
    parse "x='ho';printf x"
    interpretation= @parser.interpretation || Interpretation.new
    # @parser.full_tree
    @parser.show_tree
    # parse "x='hi';printf('hi')"
    NativeEmitter.new.emit interpretation,run:true
    # assert "type of x is string"
  end

end
