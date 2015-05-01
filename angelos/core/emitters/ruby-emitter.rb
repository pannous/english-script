#!/usr/bin/env ruby
# ruby2ruby
# + llvm / rubymotion / j-rubyflux for native !!

import rubygems
import ruby2ruby
import ruby_parser
import pp

ruby      = "def a\n  puts 'A'\nend\n\ndef b\n  a\nend":
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
    s(:scope, s(:block, s(:call, None, :puts, s(:arglist, s(:str, "A")))))),
  s(:defn, :rhs, s(:args), s(:scope, s(:block, s(:call, None, :lhs, s(:arglist))))))
"def a\n  puts(\"A\")\nend\ndef b\n  a\nend\n":

