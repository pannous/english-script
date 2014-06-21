# >>> via lightweight clojure approach SEE THERE FOR EMITTER

# VIA ruby bytecode to java bytecode + magic

# VIA JAVA FILES: https://github.com/headius/rubyflux

# VIA JRUBY + extensions SLOOOOOW!!!
# me:~/english-script/xtra$ time ruby test.rb
# 10 times faster startup for ruby: 0m0.030s
# >>>OK<<< AFTER COMPILE: 0.4s load time for java+jruby-1.6 vm
# NOT OK java + jruby-2.1  : 2.424s !!!!!
# 742400 jruby.dll |
# 18240463 jruby.jar NOT OK to bundle
# 25M WTF!? ruby_flux-1.0-SNAPSHOT.jar
# 15477 original-ruby_flux-1.0-SNAPSHOT.jar ???
# [INFO] JRuby ............................................. SUCCESS [0.362s]
# [INFO] JRuby Core ........................................ SUCCESS [12.384s]
# [INFO] JRuby Lib Setup ................................... SUCCESS [7.124s]

# http://jruby.org/apidocs/org/jruby/ast/class-use/Node.html#org.jruby.compiler

# you can instruct the JVM to inline specific methods. -XX:CompileCommand=inline,java.lan.String::indexOf

# You trade dynamicity at the language level for predictability at the VM level.
# JRuby can, with the help of invokedynamic, make method calls *nearly* as fast as Java calls
# and by generating type shapes we can make object state *nearly* as predictable as Java types, but we can't go all the way.

# Arrays.sort(rosterAsArray, (a, b) -> Person.compareByAge(a, b));
# Arrays.sort(rosterAsArray, Person::compareByAge); !!!

# There are four kinds of method references:
#                                    Kind 	Example
# Reference to a static method 	ContainingClass::staticMethodName
# Reference to an instance method of a particular object 	ContainingObject::instanceMethodName
# Reference to an instance method of an arbitrary object of a particular type 	ContainingType::methodName
# Reference to a constructor 	ClassName::new

# Object methodCaller(Object theObject, String methodName) {
#   return theObject.getClass().getMethod(methodName).invoke(theObject);
# Reflection is not the right answer to anything except "How do I write slow dodgy java code" :D
