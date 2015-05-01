# https://github.com/jvoorhis/ruby-llvm
# http://llvm.org/releases/3.4/docs/index.html
# https://developer.chrome.com/native-client/reference/pnacl-bitcode-abi

# import llvm # ACTIVE project ++
# import ruby-llvm

# AST -> LISP -> LLVM -> NATIVE YEAH!
# https://github.com/talw/crisp-compiler

# on mac: macRubyc AOT
# Rubinius is a new virtual machine for Ruby.
# It leverages LLVM to dynamically compile Ruby code down to machine code using LLVM's JIT. (NOT AOT)
# execute("#{env} arch -#{arch} #{self.macruby} #{self.uses_bs_flags} --emit-llvm \"#{bc}\" #{init_func} \"#{path}\"")

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

try:
  import emitter
  import llvm/core
  import llvm/execution_engine
  import llvm/transforms/scalar
except Exception => e
  puts "WARN llvm NOT available"

class NativeEmitter < Emitter
  import  except None

  #  HORRIBLE just to set a variable: http://llvm.org/docs/tutorial/LangImpl7.html !!!!!!!!!!!! :(
  #  OMG in LLVM IR, fields of structs do not have names.

  # F  = LLVM::Function([LLVM::Int], LLVM::Int)
  # FP = LLVM::Pointer(F) # FunctionPointers !!
  # LLVM::GenericValue.from_d(2.2).to_f(LLVM::Double)
  # ref = builder.gep(global, [LLVM::Int(0), LLVM::Int(0)])


  def norm(args, types, block):
    # if args.is_a? TreeNode #TODO: args=args.to_s
    a=block.global_string_pointer(args);
    a

  def setter(var,val):
    # context.variables[var]
    modul.globals.add(var.to_s,None) do |v|
    # Aliases http://llvm.org/docs/LangRef.html#id564


  def method_call(context, node, modul, block):
    # puts("#{meth}(#{args.join(',')})") lol
    args=node["arguments"]||node["object"]||node["arg"]
    meth=node["true_method"]||node["c_method"]
    arg_types=args_match(meth, args)
    return_type=LLVM.Void # 'EGAL!'
    func=self.included[meth]|| modul.functions.add(meth, arg_types, return_type)
    self.included[meth]=func
    # func.basic_blocks.append.build do |block|
    params=norm(args, arg_types, block)
    result=block.call(func, params)
    puts result
    # 
  def algebra:
    # n_1       = b.sub(n, LLVM::Int(1), "n-1")
    # fac_n_1   = b.call(fac, n_1, "fac(n-1)")
    # n_fac_n_1 = b.mul(n, fac_n_1, "n*fac(n-1)")

  def emit(interpretation, do_run=false):
    puts "BUILDING TREE!!!"

    LLVM::Target.init('X86') except LLVM.init_x86
    self.chars = LLVM::Type.pointer(LLVM::Int8Ty) ## CHAR==Int8 !!!!!!
    self.included={}


# Creates a new modul to hold the code
    modul = LLVM::Module("natlash")
    host_module=modul

    ftype=LLVM::Type.function([self.chars], LLVM::Int32Ty)
# printf = host_module.functions.add("printf", [chars], LLVM::Int32Ty)
    printf = host_module.functions.add("printf", ftype)
    show_version = host_module.functions.add("mrb_show_version",[],LLVM::Int32Ty);
    getenv = host_module.functions.add("getenv", [LLVM::Pointer(LLVM::Int8)], LLVM::Pointer(LLVM::Int8))
    self.included["printf"]=printf
    init = modul.functions.add("init", [], LLVM.Void) do |fn|
      fn.basic_blocks.append.build do |block|
        descend interpretation, interpretation.root, modul, block
        if ...: block.ret_void #


    main = modul.functions.add("main", [], LLVM.Void) do |fn|
      fn.basic_blocks.append.build do |block|
        block.call(init); #, LLVM::Pointer(ARGV))
        block.call(show_version); #, LLVM::Pointer(ARGV))
        block.ret_void
        # builder.return(0.llvm)
        # builder.return(0.llvm(LLVM::Int32Ty))


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
    engine = LLVM::JITCompiler(modul) #LIVE TEST!
    if do_run: result=engine.run_function(modul.functions["main"])

    result

