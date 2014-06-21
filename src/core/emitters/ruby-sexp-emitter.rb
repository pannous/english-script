#!/usr/bin/env ruby
# ruby2ruby
# + llvm / rubymotion / j-rubyflux for native !!

# english->ruby-> DIRECTLY to mrb !

# http://www.hokstad.com/compiler/

# easy in rubinius bin/rbx compile-ng -h

# require 'rubygems'
# ParseTree EOL'd since it relies on MRI 1.8 internals ... =>
require 'ruby_parser' # the better ParseTree
require 'ruby2ruby'   # disassemble
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

