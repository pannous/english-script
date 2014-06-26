#!/usr/bin/env ruby
$use_tree=false
$verbose=false
# $verbose=true
require_relative '../parser_test_helper'

class HashTestParser < ParserBaseTest
  include ParserTestHelper

  def test_hash_symbol_invariance_extension
    a={a:1}
    #VIA extension.rb !!! todo : native
    assert_equals a[:a],a['a']
    # h=parse '["SuperSecret" : "kSecValueRef"]'
    h=parse '{"SuperSecret" : "kSecValueRef"}'
    assert_equals h['SuperSecret'],"kSecValueRef"
  end

  def test_json_data
    init('{a{b:"b";c:"c"}}')
    @parser.json_hash
  end

  def test_invariances
    assert_equals parse('{a:"b"}'),parse('{"a":"b"}')
    assert_equals parse('{a:"b"}'), a:"b"
    assert_equals parse('{a{b:"b",c:"c"}}'),{a:{b:"b",c:"c"}}
    assert_equals parse('{a{b:"b";c:"c"}}'), a:{b:"b",c:"c"}
  end

  def test_invariances2 # careful / remove !
    assert_equals parse('{:a => "b"}'),a:'b' #Don't support all of the old rubies syntext
    assert_equals parse('{a:{b:"b";c:"c"}}'), a:{b:"b",c:"c"}
    # assert_equals parse('{a:{b="b";c="c"}}'), a:{b:"b",c:"c"} # DANGER with properties/setters/data !
    # assert_equals parse('a:"b"'), a:"b"  # ONLY IN CONTEXT! Special case for arguments
  end

  def test_immediate_hash
    # assert_equals parse('a:{b:"b",c:"c"}'), "a"=>{b:"b",c:"c"} # todo
    # assert_equals parse('a:{b:"b";c:"c"}'), a:{b:"b",c:"c"} # No ';' allowed here
    assert_equals parse('a:{b:"b",c:"c"}'), a:{b:"b",c:"c"} #
    assert_equals parse('a{b:"b",c:"c"}'), a:{b:"b",c:"c"}  # careful map{puts ":"} !
  end
end

