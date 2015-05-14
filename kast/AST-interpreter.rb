# I am wondering if .net foundation can start an project similar to Graal/Truffle where by you have an AST interpreter which can be leveraged to create new CLI based languages.
# http://forums.dotnetfoundation.org/t/ast-interpreter-easily-create-new-languages/620

# = ParseTree NOTE: This project is EOL'd since it relies on MRI 1.8 internals.

# https://github.com/seattlerb/ruby_parser !!!
# sudo gem install ruby_parser

# ruby2ruby
# via
source = RubyAST.to_source(ast)
# run(source)

# The new backend is an AST interpreter. We call it the Truffle backend because it’s written using the Truffle framework for writing AST interpreters from Oracle Labs.
# Truffle is different to other AST interpreters in that it creates ASTs that specialize as they execute.

# The AST interpretation methods that are currently in JRuby are megamorphic, which means that they must handle all possible types and other dynamic conditions such as branches taken. In Truffle, AST nodes ideally handle a minimal set of conditions, allowing them to be simpler and more statically typed, which can lead to more efficient code. In the less common case that the node's conditions aren’t met the node is replaced with another node that can handle them.
#
# AST interpreters are generally thought of as being slow. This is because every operation becomes something such as a virtual method call. MRI 1.8 used a simple AST interpreter, and JRuby still uses an AST interpreter by default for the first run of methods. To improve performance many language implementations convert the AST to bytecode. Python, Ruby 1.9 and above (via YARV) and PHP all do this. Normally the bytecode is still interpreted, but it’s often faster as the data structure is more compactly represented in memory. In the case of many JVM languages like JRuby and other Ruby implementations such as Topaz and Rubinius, this bytecode is eventually compiled into machine code by the JIT compiler.

# Again, Truffle takes a different approach here. When running on JVM with the Graal JIT compiler, Truffle will take all of the methods involved in interpreting your AST and will combine them into a single method. The powerful optimisations that the JVM usually applies to single methods are applied across the combined AST methods and a single machine code function per Ruby method is emitted by Graal.
# For more information about what Truffle and Graal do see the JRuby wiki page, the a recent project summary slide deck.
# Is this going to change with how you use JRuby today?
# The Truffle backend, Truffle itself, and Graal are research projects and are certainly not ready for general use today.


# !!!It is very unlikely that your application or gem will run right now !!!
# => USE JRUBY or YARV AST interpreter!

# int interpret(tree t)
# {/* left to right, top down scan of tree */
# switch (t->type) {
#   case Int :
#       return t->value;
#   case Variable :
#       return t->symbtable_entry->value
#   case Add :
#       {int leftvalue= interpret(t->leftchild);
#   int rightvalue= interpret(t->rightchild);
#   return leftvalue+rightvalue;
# }
# case Multiply :
#     {int leftvalue= interpret(t->leftchild);
# int rightvalue= interpret(t->rightchild);
# return leftvalue*rightvalue;
# }
# ...
#     case StatementSequence : // assuming a right-leaning tree
# {interpret(t->leftchild);
# interpret(t->rightchild);
# return 0;
# }
# case Assignment :
#     {int right_value=interpret(t->rightchild);
# assert : t->leftchild->==Variable;
# t->leftchild->symbtable_entry->value=right_value;
# return right_value;
# }
# case CompareForEqual :
#     {int leftvalue= interpret(t->leftchild);
# int rightvalue= interpret(t->rightchild);
# return leftvalue==rightvalue;
# }
# case IfThenElse
# {int condition=interpret(t->leftchild);
# if (condition)
#   interpret(t->secondchild);
# else
#   intepret(t->thirdchild);
#   return 0;
#   case While
#   {int condition;
#   while (condition=interpret(t->leftchild))
#     interpret(t->rightchild);
#     return 0;
#
#     ...
#     }
#     }
