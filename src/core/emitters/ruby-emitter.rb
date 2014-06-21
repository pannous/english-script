#!/usr/bin/env ruby
# ruby2ruby
# + llvm / rubymotion / j-rubyflux for native !!

require 'rubygems'
require 'ruby2ruby'
require 'ruby_parser'
require 'pp'

ruby      = "def a\n  puts 'A'\nend\n\ndef b\n  a\nend"
parser    = RubyParser.new
ruby2ruby = Ruby2Ruby.new
sexp      = parser.process(ruby)

pp sexp

p ruby2ruby.process(sexp)

## outputs:

s(:block,
  s(:defn,
    :a,
    s(:args),
    s(:scope, s(:block, s(:call, nil, :puts, s(:arglist, s(:str, "A")))))),
  s(:defn, :b, s(:args), s(:scope, s(:block, s(:call, nil, :a, s(:arglist))))))
"def a\n  puts(\"A\")\nend\ndef b\n  a\nend\n"

