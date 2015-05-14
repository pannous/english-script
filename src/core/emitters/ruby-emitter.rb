#!/usr/bin/env ruby
# JRuby+Truffle can achieve peak performance well beyond that possible in JRuby at the same time as being a significantly simpler system.

# We can also look at what Rubinius produces, using the command:
# rbenv shell rbx-2.2.2
# ruby -Xjit.dump_code=4 test.rb

# RubyMotion PLEASE become open source!!
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
    :lhs,
    s(:args),
    s(:scope, s(:block, s(:call, nil, :puts, s(:arglist, s(:str, "A")))))),
  s(:defn, :rhs, s(:args), s(:scope, s(:block, s(:call, nil, :lhs, s(:arglist))))))
"def a\n  puts(\"A\")\nend\ndef b\n  a\nend\n"

