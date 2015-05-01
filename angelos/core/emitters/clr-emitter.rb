# http://ironruby.net/ # 1.1.3 released on 2011-3-13 DON't USE!!
# VIA JAVA! OK with java 8 http://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html
# VIA CLOSURE(+JAVA) !!!! https://github.com/richhickey/clojure-clr

# OR vi LLVM: llc -march=msil  DEPRECATED!!!!!!
# Going from C# or MSIL (CIL) to LLVM IR hasnt been done yet (or at least finished). You'd need a C# Front-End.
# VMkit had some kind of C# front end scaffolding. Support was never feature complete and interest has since faded. They've moved to just supporting Java.
# http://stackoverflow.com/questions/3559415/is-there-any-way-to-write-a-llvm-front-end-compiler-in-c


# Lexical Analysis with Flex: Split input data into a set of tokens (identifiers, keywords, numbers, brackets, braces, etc.)
# Semantic Parsing with Bison: Generate an AST while parsing the tokens. Bison will do most of the legwork here, we just need to define our AST.
# class NMethodCall : public NExpression {
#   public:
#       const NIdentifier& id;
#   ExpressionList arguments;
#   NMethodCall(const NIdentifier& id, ExpressionList& arguments) :
#       id(id), arguments(arguments) { }
#   NMethodCall(const NIdentifier& id) : id(id) { }
#   virtual llvm::Value* codeGen(CodeGenContext& context);
# };
# http://gnuu.org/2009/09/18/writing-your-own-toy-compiler


# function pointer and delegate / events

# Action<string> writeLine = Console.WriteLine;
# textBox.TextChanged += HandleTextChanged;


# LAST resort windows COM : import win32ole
# http://stackoverflow.com/questions/265879/can-ruby-import-a-net-dll
# lib = WIN32OLE('ComLib.LogWriter')
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
