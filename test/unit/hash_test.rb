#!/usr/bin/env ruby
$use_tree=false
$verbose=false
# $verbose=true
require_relative '../parser_test_helper'

class ListTestParser < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser
  include ParserTestHelper

  def test_hash
    a={a:1}
    z=a['a']
    assert_equals a[:a],a['a'] #VIA extension.rb !!!
    # h=parse '["SuperSecret" : "kSecValueRef"]'
    h=parse '{"SuperSecret" : "kSecValueRef"}'
    assert_equals h['SuperSecret'],"kSecValueRef"
  end
end

