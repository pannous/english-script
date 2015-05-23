# The Dynamic Language Runtime (DLR) from Microsoft runs on top of the Common Language Runtime

# .net (ROSLYN) OPEN source OK
# MONO.CECIL syntax tree Better (why?)

#NRefactory is the C# analysis library used in the SharpDevelop and MonoDevelop IDEs. It allows applications to easily analyze both syntax and semantics of C# programs. It is quite similar to Microsoft's Roslyn project; except that it is not a full compiler – NRefactory only analyzes C# code, it does not generate IL code.

# StatementSyntax statement=Syntax.ParseStatement("for (int i = 0; i < 10; i++) { }");
# http://www.codeproject.com/Articles/113169/C-As-A-Scripting-Language-In-Your-NET-Applications
# http://www.csscript.net/ ?

# Microsoft Research Common Compiler Infrastructure (CCI)
# https://cciast.codeplex.com/

# DEAD http://IRONRUBY.net/ # 1.1.3 released on 2011-3-13 DON't USE!!

# IRONPYTHON is (relatively) alive! LOL and 3 times faster than java (JYTHON)!!!
# time mono ipy.exe exit
# real	0m1.156s

# Boo naja (JVM support coming soon) why not python?
# Fantom (.net+jvm!!) Typing discipline static, dynamic

# me> csharp
# Mono C# REPL Shell, type "help;" for help
#
# Enter statements below.
# csharp>


# VIA CLOSURE(+JAVA) !!!! https://github.com/clojure/clojure-clr  Dynamic Language Runtime (DLR).

# OR vi LLVM: llc -march=msil  DEPRECATED!!!!!!
# Going from C# or MSIL (CIL) to LLVM IR hasnt been done yet (or at least finished). You'd need a C# Front-End.
# VMkit had some kind of C# front end scaffolding. Support was never feature complete and interest has since faded. They've moved to just supporting Java.
# http://stackoverflow.com/questions/3559415/is-there-any-way-to-write-a-llvm-front-end-compiler-in-c

# function pointer and delegate / events

# Action<string> writeLine = Console.WriteLine;
# textBox.TextChanged += HandleTextChanged;

# LAST resort windows COM : require 'win32ole'
# http://stackoverflow.com/questions/265879/can-ruby-import-a-net-dll
# lib = WIN32OLE.new('ComLib.LogWriter')
# lib.WriteLine('calling .net from ruby via COM, hooray!')

# use FFI to call that DLL from Ruby https://github.com/ffi/ffi

# OR emit like this:
# # // Push null-reference onto stack.
# # // (Console.WriteLine is a static method)
# ldnull
#
# #// Push unmanaged pointer to desired function onto stack.
# ldftn void [mscorlib]System.Console::WriteLine(string)
#
# #// Create delegate and push reference to it onto stack.
# # instance void [mscorlib]System.Action`1<string>::.ctor(object, native int)
#
# # // Pop delegate-reference from top of the stack and store in local.
# stloc.0

# A full C# parser is available with our DMS Software Reengineering Toolkit (DMS for short). It has been used to process tens of thousands of C# files accurately. It provides automated AST building, tree traversals, surface-syntax pattern matching and transformation and lots more. As a commercial product it might not work out for a student project.

# ANTLR arguably offers a C# parser, but I don't know complete or robust it is, or whether it actually builds ASTs.
