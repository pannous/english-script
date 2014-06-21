#!/usr/bin/env ruby
# ruby2ruby
# + llvm / rubymotion / j-rubyflux for native !!

# english->ruby-> DIRECTLY to mrb !

# The Ruby Language has no provisions for compiling to bytecode and/or running bytecode.
# It also has no specfication of a bytecode format. The reason for this is simple:
# it would be much too restricting for language implementors if they were forced to use a specific bytecode format,
#  or even bytecodes at all.
# For example, XRuby and JRuby compile to JVM bytecode, Ruby.NET and IronRuby compile to CIL bytecode,
#  Cardinal compiles to PAST, SmallRuby compiles to Smalltalk/X bytecode, MagLev compiles to GemStone/S bytecode...


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

