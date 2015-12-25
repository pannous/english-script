TODO
https://github.com/mephux/envdb !
Fwd: Nixar - Joyable equivalents for existent linux commands  http://nixar.work/



JVM, .Net (CLR/CIL,msil), llvm , apple CLI, WebCL and NaCl??
asm.js A Mozilla Research project to specify and develop the extremely optimizable subset of JS targeted by compilers like Emscripten, Mandreel, and LLJS. 
Emscripten: An LLVM-to-JavaScript Compiler

The CLR is a great platform for creating programming languages, and the DLR makes it all the better for dynamic languages. Also, the .NET framework (base class library, presentation foundation, Silverlight, etc.) gives developers an amazing amount of functionality and power.

<!-- http://www.2ality.com/2012/01/bytecode-myth.html -->
There is no single bytecode to “rule all languages”: A good bytecode is intimately tied to the language that is most frequently compiled to it. It is thus impossible to define a bytecode that works well with all languages, especially if you want to support both dynamic and static languages. There is no common ground between browsers. Source code is not that bad – it’s meta-bytecode
Parsing source code is fast (!!!?!?!?)
Source can be quite compact !! YES
Already a good compilation target!!!!!!!!!!!!!!!!!!!!!!!!
JavaScript source code having such a high level of abstraction makes it relatively easy to compile to.
In the future, SOURCE MAPS will even allow one to debug JavaScript code in the original language. 
==> The web needs no bytecode, but LISP!!! for faster parsing (JSZap)
Reduced program size (by approximately 10% compared to minification plus gzip compression). ????

Bytecode is inflexible: it ties you to the current version of the language and to implementation details such as how data is encoded.
Now, of course, you could say “Let’s version the bytecode”, and then you’re in version hell. The web really doesn’t like to have that kind of versioning. 

mono - Mono's ECMA-CLI native code generator (Just-in-Time and Ahead-of-Time)
mono --aot --llvm #--desktop --security --server --verify-all
<!-- --debug --profile --trace --break method --compileall  -->
To debug managed applications, you can use the mdb command, a command line debugger.
 MONO_LOG_LEVEL="debug" 
rubydotnet 	2003-09-28 	LOL -- :(
ironruby 1.1.3 released on 2011-3-13

Android will have ART, with AOT java!!

org.eclipse.jdt.core.dom.ASTNode

CLOSURE = AST = LISP http://blog.fogus.me/2012/04/25/the-clojurescript-compilation-pipeline/
PYTHON AST -> native !!
clojure-py : https://github.com/halgari/clojure-py
Clojure is a dynamic programming language that targets the Java Virtual Machine (and the CLR!!, and JavaScript!!).
http://clojure.org/rationale

<< LLVM >> Bytecode!
many JVM CONSTRAINS baked into iCode
IR doesn't have an AST representation inside LLVM, because it's a simple assembly-like language. If you go one step up, to C or C++, you can use Clang to parse that into ASTs, and then do manipulations at the AST level. Clang then knows how to produce LLVM IR from its AST. However, you do have to start with C/C++ here, and not LLVM IR. If LLVM IR is all you care about, forget about ASTs.
no generic GARBAGE COLLECTION!
But: http://vmkit.llvm.org/ BROKEN, just like GCJ

Sick: directly in JS: https://github.com/opal/opal/
/Applications/IntelliJ IDEA 13.app/plugins/sass/lib/jrubyparser-0.5.0.jar

clang -Xclang -ast-dump -fsyntax-only test.cc
http://www.mono-project.com/Mono:Runtime:Documentation:LLVM

http://www.antlr3.org/api/ActionScript/org/antlr/runtime/tree/BaseTree.html

http://stackoverflow.com/questions/197057/javac-exe-ast-programmatic-access-example

js parser in js WTF https://github.com/ariya/esprima

Java supports anonymous functions AND FUNCTION POINTERS since JDK 8
# Arrays.sort(rosterAsArray, (a, b) -> Person.compareByAge(a, b));
# Arrays.sort(rosterAsArray, Person::compareByAge); !!!

Lambda Expressions = Anonymous Methods
Closures = contextual Methods  f(x){g=(){x*7};return g}



At first glance, lambda methods look like nothing more than a syntactic sugar, a more compact and pleasant syntax for embedding an anonymous method in code. Compare:
Func<int, int> f1 = delegate(int i) { return i + 1; };
Func<int, int> f2 = i=>i+1; 

todo
selfModify IF STANDALONE!! , not in setter, args, etc
increase x
square x
vs 
y=square x

AST parsetree
https://github.com/seattlerb/parsetree  doesn't work with RUBY_VERSION >= "1.9" :(
ruby to s

python AST -> SQL !!!
http://stackoverflow.com/questions/16115713/how-pony-orm-does-its-tricks

crazy compiler in ruby: ruby->c DIRECTLY ! crazy don't use!
http://www.hokstad.com/compiler


http://www.llvm.org/demo/
llvm-code-from-java http://stackoverflow.com/questions/12358684/generating-llvm-code-from-java

!! LLVM is not able to support some of the features that Mono needs, so in those cases the JIT compiler will still fall back to Mono's JIT engine (methods that contain try/catch clauses or methods that do interface calls). 


CLOSURE -> BYTECODE !!!
	void compile(String superName, String[] interfaceNames, boolean oneTimeUse) throws IOException{
		//create bytecode for a class
		ClassWriter cw = new ClassWriter(ClassWriter.COMPUTE_MAXS);
//		ClassVisitor cv = new TraceClassVisitor(new CheckClassAdapter(cw), new PrintWriter(System.out));
		cv.visit(V1_5, ACC_PUBLIC + ACC_SUPER + ACC_FINAL, internalName, null,superName,interfaceNames);
			String smap = "SMAP\n"...
			cv.visitSource(source, smap);
		addAnnotation(cv, classMeta);
		//static fields for constants
		for(int i = 0; i < constants.count(); i++)
			{
			cv.visitField(ACC_PUBLIC + ACC_FINAL
			              + ACC_STATIC, constantName(i), constantType(i).getDescriptor(),
			              null, null);
			}


 Everything is now included in the API directly, so using Groovy or JRuby provide a great scripting framework for using JavaFX.

Shed Skin can compile Python to C++, but only a restricted subset of it. Some aspects of Python are very difficult to compile to native code.

compare natlash with treetop https://github.com/nathansobo/treetop

I used Treetop to create the parser. Writing the Treetop grammar was the most time consuming task. Also, because Treetop can’t produce context sensitive grammar, you’re limited in the kind of syntax you provide!!!!!!!!!!!!!!!!!!!!!!!!!

<< Clojure  LLVM >>
Clojure depends on aggressive dynamic optimization for performance.
It's a very different set of techniques than what is used in the
ahead-of-time static compilation world from which LLVM hails. The
Google guys working on Unladen Swallow seem to have had enough
problems getting it to work well even as a basic JIT code generator;
the layers of abstraction make it very slow. There's a good reason V8
is using unlayered, direct code generation.
In my judgement it would be a multi-year project for an experienced
specialist in the field. Mike Pall took several years to do just the
x86 version of LuaJIT 2.0, but he had already done LuaJIT 1.0, and he
is arguably one of the world's top experts in this area.
Besides, one of the Clojure's main raisons d'etre is the vast pool of
existing libraries in the JVM (and now CLR) world to draw from.

LLVM provides a lot, but it's still only a small part of the runtime a functional language needs. And C FFI calls are uncomplicated because LLVM leaves memory management to be handled by someone else. Interacting the Garbage Collector is what makes FFI calls difficult in languages such as Scheme.
