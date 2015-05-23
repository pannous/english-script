Xtend https://www.eclipse.org/xtend/documentation/202_xtend_classes_members.html#extension-methods
https://github.com/tobykurien/Xtendroid

MIRAH !!!!!!!!!!!!!!!!!!!!!!!!!!
# https://github.com/mirah/pindah
Mirah
def foo(a:dynamic)
  puts a.getClass
end
foo('hello')

# public static java.io.PrintStream foo(java.lang.Object);
# Code:
# 0: getstatic     #14 // Field java/lang/System.out:Ljava/io/PrintStream;
# 3: dup
# 4: aload_0
# 5: invokedynamic #17,  0 // NameAndType "dyn:callPropWithThis:getClass":(Ljava/ lang/Object;)Ljava/lang/Object;
# 10: invokevirtual #35 // Method java/io/PrintStream.println:(Ljava/lang/Object;)V
# 13: areturn
# Problems...
# • Dynamic invocation happens at runtime
# • Compile-time logic doesn’t apply
# •  Multi-method selection needs a library
# • ...wishing it were built into Java 7...
                                       Monday, July 26, 2010

# javassist
ClassPool pool = ClassPool.getDefault();
CtClass cc = pool.get("test.Rectangle");
cc.setSuperclass(pool.get("test.Point"));
CtField f = new CtField(ClassPool.getDefault().get("java.util.ArrayList"), "someList", cc);
cc.addField(f);
cc.addField(new CtField(CtClass.intType, "z", cc));
cc.writeFile();

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


# >>> via lightweight clojure approach SEE THERE FOR EMITTER
# JVM VIA JAVA!
# VIA ruby bytecode to java bytecode + magic


# XML/json statt closure for AST! (DONT) see:
require_relative 'lisp-emitter.rb'

# <j:jelly xmlns:j="jelly:core" xmlns:define="jelly:define" xmlns:my="myTagLib">
# <define:taglib uri="myTagLib">
# <define:jellybean name="foo" className="MyTask"/>
# </define:taglib>
#   Now lets use the new tag
#   <my:foo x="2" y="cheese"/>
# </j:jelly>

