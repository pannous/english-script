# see ast.interpreter!!
# ^^^^^^^^^^^^^^^^^^^

require_relative 'kast.rb'
# require_relative 'demo.rb'
require_relative 'demo2.rb'
# require_relative 'demo.kast' Uncaught exception: cannot load such file
# p ast
ast.dump
p ast.interpret

