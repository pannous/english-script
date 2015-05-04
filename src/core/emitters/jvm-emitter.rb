# >>> via lightweight clojure approach SEE THERE FOR EMITTER
# JVM VIA JAVA!
# VIA ruby bytecode to java bytecode + magic
#
#
#
# MethodHandle happyTimeHandle = MethodHandles.findVirtual(Happy.class, "happyTime", void.class, String.class);
# # currying
# MethodHandle curriedHandle = MethodHandles.insertArgument(happyTimeHandle, new Happy());
#
# # http://blog.headius.com/2011/08/invokedynamic-in-jruby-constant-lookup.html
# public abstract IRubyObject call(ThreadContext context, IRubyObject self, RubyModule clazz,
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule clazz,
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule klazz, String name, IRubyObject arg);
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule klazz, String name, IRubyObject arg1, IRubyObject arg2);
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule klazz, String name, IRubyObject arg1, IRubyObject arg2, IRubyObject arg3);
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule klazz, String name);
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule klazz, String name, Block block);
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule klazz, String name, IRubyObject arg, Block block);
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule klazz, String name, IRubyObject arg1, IRubyObject arg2, Block block);
# public IRubyObject call(ThreadContext context, IRubyObject self, RubyModule klazz, String name, IRubyObject arg1, IRubyObject arg2, IRubyObject arg3, Block block);
#
# What

# XML/json statt closure for AST! (DONT) see:
require_relative 'lisp-emitter.rb'

# <j:jelly xmlns:j="jelly:core" xmlns:define="jelly:define" xmlns:my="myTagLib">
# <define:taglib uri="myTagLib">
# <define:jellybean name="foo" className="MyTask"/>
# </define:taglib>
#   Now lets use the new tag
#   <my:foo x="2" y="cheese"/>
# </j:jelly>

