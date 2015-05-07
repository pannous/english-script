# source-to-source compiled:
# haxe HORRIBLE_TOOLCHAIN___UGLY_LANGUAGE OCaml (optimizing compiler)
# haxe.Log.trace.__hx_invoke2_o(0.0, "Hello World", 0.0, new haxe.lang.DynamicObject(new haxe.root.Array<java.lang.String>(new java.lang.String[]{"className", "fileName", "methodName"}), new haxe.root.Array<java.lang.Object>(new java.lang.Object[]{"World", "World.hx", "main"}), new haxe.root.Array<java.lang.String>(new java.lang.String[]{"lineNumber"}), new haxe.root.Array<java.lang.Object>(new java.lang.Object[]{((java.lang.Object) (((double) (3) )) )})));

# Bytecode Targets - There are targets that produce bytecode (Neko, SWF, SWF8) that is being passed as-is to the respective runtime. Haxe API is available as well as platform specific features under the platform's namespace.
# Language Targets - There are targets that produce sourcecode (AS3, C++, C#, Java), that has to be compiled by a third-party compiler, or passed as-is to the respective runtime which compiles the code and executes it (JavaScript, PHP). Specific mechanisms exist to interact with low-level aspects of the target-language to ease development. Unsupported API can be added into Haxe files by embedding source code written in the target-language.
# Platform Targets - For most of the targets, multiple runtimes with different purposes exist. JavaScript, for instance, is in widespread use as a scripting language in browsers, game-engines, office-applications, as server-side language for runtimes like NodeJs, and much more.
# External Modules - Extern type definitions ("extern class" in Haxe) all describe the types of platform-native APIs, as well as those of runtimes and libraries written in the target language, to the Haxe compiler, so that static type-checking can be applied.

# see ruby-vs-python.txt
# ruby++ better blocks + lambdas !!!
# ruby+ jruby better, class extensions
# ruby- less modules, more beautiful language => less need for angle!
# ruby--: NO types!!, no annotations!
# python ++: more modules, ironpython ok!, type hints (py3), annotations, TO NATIVE (sometimes), Ast better(!!)
# python - annoying (self),:,() neccessary + DANGEROUS!! (ok if generated?), NO class extensions! (ok with 'macros' / subclass construction (?))
# python --- explicit global/class(self) variable scope nightmare!! lambdas + block variable scope !!!!! 'nonlocal' keyword :(

