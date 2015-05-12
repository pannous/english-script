#!/usr/bin/env ruby

$use_tree=true
# $verbose=true
$verbose=false

require_relative '../parser_test_helper'
# require_relative '../../src/core/emitters/js-emitter'
require_relative '../../src/core/emitters/c-emitter'

class EmitterTest < ParserBaseTest

  def init
    $use_tree=true
  end
  def initialize
    $use_tree=true
  end

  include ParserTestHelper

  def last_result x
    x.split("\n")[-1]
  end

  def assert_result_emitted x,r
    # $use_tree=true
    # @parser.dont_interpret!
    # parse x
    # interpretation= @parser.interpretation || Interpretation.new
    # @parser.full_tree
    # NativeEmitter.new.emit interpretation,run:true
    # assert_result_is x,r # Make sure that at least the interpretation works
    assert_equals last_result(parse_tree(x,true)),r #parse_tree(r,emit:true)
  end

  def test_js_emitter #NEEDS TREE
    skip if not $use_tree
    assert_result_emitted "x=5;increase x",6
  end


  def test_int_setter #NEEDS TREE
    skip if not $use_tree
    assert_result_emitted "x=5;puts x",5
  end


  def test_type_cast
    # verbose
    assert_result_is "2.3",2.3
    parse "int z=2.3 as int"
    assert_equals result,2
    # parse "x='5';int z=x as int"
  end


  def test_printf
    # skip
    $use_tree=true
    @parser.dont_interpret!
    parse "printf 'hello world'",false
    interpretation= @parser.interpretation || Interpretation.new
    @parser.full_tree
    result=NativeCEmitter.new.emit interpretation,run:true
    assert_equals result,"hello world"
  end

  def test_printf_1
    assert_result_emitted "printf 'hello world'",'hello world'
  end

  def test_function_call
    assert_result_emitted "i=7;i minus one",6
  end

  def test_function
    assert_result_emitted "def test{puts 'yay'};test",'yay'
    # assert_result_emitted "def test{puts 'yay'};test()",'yay'
    # assert_result_emitted "def inverte c: c.invert;done;xs=[1,4,7];inverte xs",[7,4,1]
  end

  def test_function2
    parse_file "examples/factorial.e"
    assert_result_emitted "factorial 6",5040
  end

  def test_array
    assert_result_emitted "xs=[1,4,7];invert xs",[7,4,1]
    # assert_result_emitted "xs=1,4,7;invert xs",[7,4,1]
  end

  def test_setter
    # skip
    $use_tree=true
    @parser.dont_interpret!
    # parse "x='ho';printf x"
    parse "x='ho';puts x"
    interpretation= @parser.interpretation || Interpretation.new
    # @parser.full_tree
    @parser.show_tree
    # parse "x='hi';printf('hi')"
    NativeCEmitter.new.emit interpretation,run:true
    # NativeEmitter.new.emit interpretation,run:true
    # assert "type of x is string"
  end

end
