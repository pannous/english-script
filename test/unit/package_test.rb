#!/usr/bin/env ruby

# $use_tree=true
# $verbose=true

require_relative '../parser_test_helper'

class PackageTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_using
    @parser.dont_interpret!
    simple=parse("depends on stdio")
    assert_equals({dependency: {type:nil,package:"stdio",version:nil}},simple)
    dependency=parse "using c package stdio version >= 1.2.3"
    puts dependency
    assert_equals({dependency: {type:"c",package:"stdio",version:"1.2.3"}},dependency)
  end

end
