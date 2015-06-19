# Statically Compiled Ruby "FOUNDRY" HE GAVE UP!
# http://whitequark.org/blog/2011/12/21/statically-compiled-ruby/
# http://whitequark.org/blog/2013/07/30/metaprogramming-in-foundry/
 # evaluating Ruby code is a slow process. Even when you have an expression like 5 + 2 (which is syntactic sugar for 5.+(2)), one cannot safely assume that + method has not been redefined as something completely different. 
-> FINAL final keyword!! for methods +classes?
HE GAVE UP!
Simply put, this is not a language I myself would use. Also, I could not find a way to get rid of global type inference which didn’t involve turning the language into a not invented here version of C#, Rust or what else.
 don’t use global type inference, it sucks -> Crystal :(
	

 [ "foo", 42 ].each do |v|
   print(v + v)
 end
 how can such code be typed in the object-language? Turns out there are two obvious solutions:
     The compiler can infer a union type str | int, wrap it in a tagged container and pass to the closure. Proliferation of union types (and corresponding dispatch tables) generally grows code size exponentially, execution time linearly, and prohibits further inference and optimization.
     For these reasons, Foundry does not automatically infer union types. They still can be specified explicitly, though, and once specified, will propagate unmodified through the code.
     The compiler can infer a polytype for the closure. Foundry does not support polytypes in the object-language to avoid placing needless restrictions on the value representation.


"Rubinius provides a lot of methods to inspect its internal state, which will prove to be useful for our purpose. Particularly, it allows one to retrieve bytecode for any executable object.

by a common convention, methods named to_s return String, this convention is not enforced
an array, being strictly heterogenous, is a “typing black hole”: it can accept objects of any type, and it always emits unqualified objects.

I should make a small digression here. While I have mentioned operations on AST, in fact these have a little to do with an actual abstract syntactic tree of a Ruby source file. The syntax of Ruby is notoriously complex—it’s enough to say that none of alternative implementations have their own parser—and the AST, while being a bit simpler, is still too complex to allow for convenient transformations. On the other hand, while bytecode only consists of unique opcodes, it is an internal interface prone to unexpected changes, and in case of Rubinius’ bytecode, it is a bytecode for stack VM, which isn’t easily transformed either. The latter can be trivially solved."

sym = :test
puts "the symbol is #{sym}"

The directly transformed SSA representation is as follows:
a = :test
setlocal(0, a)
b = "the symbol is "
c = getlocal(0)
d = tostring(c)
e = stringconcat(b, d)
f = self
g = send(f, :puts, [e])
leave(g)

After folding all local variable accesses and propagating constants, it looks like this:

leave(
  send(self, :puts, [
    stringconcat(
      "the symbol is ",
      tostring(:test))]))


def sum(Array[Fixnum] numbers) => Fixnum
  result = 0
  numbers.each do |number| result += number end
  result
end

Note how the type of a variable result isn’t specified. It is inferred automatically at the point of first assignment and enforced later.
The return type is specified explicitly, but it could be omitted here, as it can be inferred from the type of variable result.

# via PYTHON:

# Use Cython, which is a Python-like language that is compiled into a Python C extension, Python to C source code translator
# RPython -> native (via PyPy!)
# Use PyPy, which has a translator from RPython (a restricted subset of Python that does not support some of the most "dynamic" features of Python) to C or LLVM. # replaced dead Psyco
# PyPy comes by default with support for stackless mode, providing micro-threads for massive concurrency.
# TOPAZ A high performance ruby, written in RPython http://topazruby.com lol wtf python -m topaz /path/to/file.rb

# What are you trying to achieve?
#
# If it's faster code execution, the primary slowdown with a very
# high-level language like Python is caused by high-level data structures
# (introspection, everything being an object, etc.), not the code itself.

# A native compiler would still have to use high-level data structures to
# work with all Python code, so the speed increase wouldn't be very much.
#
# If you just think a compiler would be cool, check out Psyco, Pyrex, it even combats the speed issue by allowing native C types
# to be used in addition to Python high-level types.


# https://github.com/jvoorhis/ruby-llvm
# http://llvm.org/releases/3.4/docs/index.html
# https://developer.chrome.com/native-client/reference/pnacl-bitcode-abi
# http://www.infoq.com/presentations/clojure-scheme -> native!

# obviously we don't want to use those obscure programming languages we just want to hijack that compiler pipeline / toolchain
# VALA (active! source-to-source compiled to C (!)) C ONLY! :(  used by Baobab - Disk usage analyzer !!
# vala ~= c#, but would also love to be able to get maximum performance from their hardware. This lets you do that while using your favorite language. I can't see something like this dieing.
# If you check the Linux Desktop scenario, every 2nd new app seems to be written in Vala. Vala is fast becoming the language of choice on Linux desktop at least.
# The main drawback of the GObject framework is its verbosity. Large amounts of boilerplate code, such as manual definitions of type casting macros and obscure type registration incantations, are necessary to create a new class. The GObject Builder, or GOB2, is a tool that attempts to remedy this problem by offering a template syntax reminiscent of Java. Code written using GOB2 is pre-processed into vanilla C code prior to compilation. Another compiler-to-C for the GObject type system is Vala, which uses a C#-style syntax.

# Haxe is an open-source high-level multiplatform programming language and compiler that can produce applications and source code for many different platforms from a single code-base.
# haxe -main World.hx -cpp out   YAY!! big (1/2MB) but FAST exe!!

# require 'llvm' # ACTIVE project ++
# require 'ruby-llvm'

# AST -> LISP -> ()LLVM ->) NATIVE YEAH!
# SCHEME == gambit == gsc !!
# The compiler can produce standalone executables or compiled modules which can be loaded at run time. Interpreted code and compiled code can be freely mixed.
# http://stackoverflow.com/questions/913671/are-there-lisp-native-code-compilers

# https://github.com/talw/crisp-compiler

# Compiling Clojure to native code would likely degrade overall performance
# but may improve startup speed.

# Native?? Even if you get all that straightened out, you still lack a good
# standard lib. This is what really killed the project for me. Read up
# on C++ linking sometime. Trying to get something like .JARs or .net
# assemblies working on a native level is a nightmare to say the least.

# !!! For C it would be easy-ish to create a pinvoke
# like system. But for C++.....yeaaaahhh.....the way C++ is linked is
# just wrong.


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


# on mac: macRubyc AOT
# Rubinius is a new virtual machine for Ruby.
# It leverages LLVM to dynamically compile Ruby code down to machine code using LLVM's JIT. (NOT AOT)
# execute("#{env} arch -#{arch} #{@macruby} #{@uses_bs_flags} --emit-llvm \"#{bc}\" #{init_func} \"#{path}\"")

# clang -emit-llvm -S -o test.bc test.c
# lli test.bc
# llc test.bc
# as test.S


# Why I deverop ytljit instead of using llvm? Because according to
# my yarv2llvm's experience I think llvm don't have enough power
# Ytl is translator from CRuby VM (aka YARV) to X86-32/X86-64 Native Code. Ytl uses ytljit as code generate library.

# VIA ruby bytecode loader, saver ('semi-native') + emitter
# RubyVM::InstructionSequence.compile "puts 1+4"  YARV became the official Ruby interpreter !!
# iseq gem needs array, we rather load binary dump
# iseq_marshal_load NOWHERE FOUND!
# reconstruct dump via rb_iseq_new_with_opt / prepare_iseq_build
# DONT build manually via rb_iseq_compile_node (AST)
# DONT iseq_data_to_ary(rb_iseq_t *iseq) : load directly, no ary array


# VIA MicroVR: Rubinius / Parrot /
# VIA MRUBY libmruby.a YAY VM / bytecode (or call via ffi/llvm/c [main wrapper/mrbc header])

# You can also compile Ruby programs into compiled byte code using the mruby compiler "mrbc". !!!
#  USE EXISTING 'VM': YARV / mruby 'ritevm' / Rubinius/ ... or?
# mrb_define_method(mrb, h, "values_at", hash_values_at, MRB_ARGS_ANY());
# libruby.2.0.0.dylib 3699712byte = 3.6MB!
# libmruby.a 3MB, but not all linked ++ : 691560 mruby_hello.out! 0.6MB
# http://www.reddit.com/r/ruby/comments/k9jce/ruby_ritevm_faq_and_timeline_updates/
# threads ok ++
# http://patshaughnessy.net/2012/6/29/how-ruby-executes-your-code

# VIA CYTHON??

# VIA C++ ? similar to j-rubyflux

# VIA MachineCode? WAY Too painful + not portable

# VIA >>> LLVM <<< ? Too painful! but would be VERY NICE!
# SEE http://www.stephendiehl.com/llvm/#for-loop-expressions for advanced stuff!
# Why I deverop ytljit instead of using llvm? Because according to
# my yarv2llvm's experience I think llvm don't have enough power
# for  Ruby compiler.
# Ytl is translator from CRuby VM (aka YARV) to X86-32/X86-64 Native Code. Ytl uses ytljit as code generate library.
# todo : google llvm AST emitter / llvm frontend => RUST / wait for swift OS?

# via AST? clang -Xclang -ast-dump -fsyntax-only test.cc
# http://clang.llvm.org/docs/IntroductionToTheClangAST.html
# probably not: https://github.com/ioquatix/ffi-clang

begin
  require_relative 'emitter'
  require 'llvm/core'
  require 'llvm/execution_engine'
  require 'llvm/transforms/scalar'
rescue Exception => e
  puts "WARN llvm NOT available"
end

class NativeEmitter < Emitter
  include LLVM rescue nil

  #  HORRIBLE just to set a variable: http://llvm.org/docs/tutorial/LangImpl7.html !!!!!!!!!!!! :(
  #  OMG in LLVM IR, fields of structs do not have names.

  # F  = LLVM::Function([LLVM::Int], LLVM::Int)
  # FP = LLVM::Pointer(F) # FunctionPointers !!
  # LLVM::GenericValue.from_d(2.2).to_f(LLVM::Double)
  # ref = builder.gep(global, [LLVM::Int(0), LLVM::Int(0)])


  def norm args, types, block
    # args=args.to_s if args.is_a? TreeNode #TODO
    a=block.global_string_pointer(args);
    a
  end

  def setter var,val
    # context.variables[var]
    modul.globals.add(var.to_s,nil) do |v|
    # Aliases http://llvm.org/docs/LangRef.html#id564
    end
  end

  def method_call context, node, modul, block
    # puts("#{meth}(#{args.join(',')})") lol
    args=node["arguments"]||node["object"]||node["arg"]
    meth=node["true_method"]||node["c_method"]
    arg_types=args_match(meth, args)
    return_type=LLVM.Void # 'EGAL!'
    func=@included[meth]|| modul.functions.add(meth, arg_types, return_type)
    @included[meth]=func
    # func.basic_blocks.append.build do |block|
    params=norm(args, arg_types, block)
    result=block.call(func, params)
    puts result
    # end
  end

  def algebra
    # n_1       = b.sub(n, LLVM::Int(1), "n-1")
    # fac_n_1   = b.call(fac, n_1, "fac(n-1)")
    # n_fac_n_1 = b.mul(n, fac_n_1, "n*fac(n-1)")
  end

  def emit interpretation, do_run=false
    puts "BUILDING TREE!!!"

    LLVM::Target.init('X86') rescue LLVM.init_x86
    @chars = LLVM::Type.pointer(LLVM::Int8Ty) ## CHAR==Int8 !!!!!!
    @included={}


# Creates a new modul to hold the code
    modul = LLVM::Module.new("natlash")
    host_module=modul

    ftype=LLVM::Type.function([@chars], LLVM::Int32Ty)
# printf = host_module.functions.add("printf", [chars], LLVM::Int32Ty)
    printf = host_module.functions.add("printf", ftype)
    show_version = host_module.functions.add("mrb_show_version",[],LLVM::Int32Ty);
    getenv = host_module.functions.add("getenv", [LLVM::Pointer(LLVM::Int8)], LLVM::Pointer(LLVM::Int8))
    @included["printf"]=printf
    init = modul.functions.add("init", [], LLVM.Void) do |fn|
      fn.basic_blocks.append.build do |block|
        descend interpretation, interpretation.root, modul, block
        block.ret_void # if ...
      end
    end

    main = modul.functions.add("main", [], LLVM.Void) do |fn|
      fn.basic_blocks.append.build do |block|
        block.call(init); #, LLVM::Pointer(ARGV))
        block.call(show_version); #, LLVM::Pointer(ARGV))
        block.ret_void
        # builder.return(0.llvm)
        # builder.return(0.llvm(LLVM::Int32Ty))
      end
    end


#, arg = (ARGV[0] || 6).to_i)

# OR via ruby emitter: use FFI to call that DLL from Ruby https://github.com/ffi/ffi
    puts "\nCOMPILING!!!"
    modul.write_bitcode("./build/main.bc")
    puts "BUILDING!!!"
    `llc -filetype=obj ./build/main.bc -o ./build/main.o` # to compile!!
# `COMPILER_ARGS=llvm-config --libs core jit native --cxxflags --ldflags`
    puts "LINKING!!!"
    `clang++ $COMPILER_ARGS ./build/libmruby.a  ./build/main.o -o ./target/main` # or any other gcc!!
    puts "EXECUTING FILE!!!"
    system("./target/main")
# system("./target/main&")

    puts "\nEXECUTING JIT!!!"
    engine = LLVM::JITCompiler.new(modul) #LIVE TEST!
    result=engine.run_function(modul.functions["main"]) if do_run

    result
  end
end
