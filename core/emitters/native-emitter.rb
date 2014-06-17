# https://github.com/jvoorhis/ruby-llvm
# http://llvm.org/releases/3.4/docs/index.html
# https://developer.chrome.com/native-client/reference/pnacl-bitcode-abi

# require 'llvm' # ACTIVE project ++
# require 'ruby-llvm'
begin
require 'llvm/core'
require 'llvm/execution_engine'
require 'llvm/transforms/scalar'
rescue Exception => e
  puts "WARN llvm NOT available"
end

# todo : google llvm AST emitter

# VIA MicroVR: Rubinius / Parrot /
# VIA MRUBY libmruby.a YAY VM / bytecode

# You can also compile Ruby programs into compiled byte code using the mruby compiler "mrbc". !!!
#  USE EXISTING 'VM': YARV / mruby 'ritevm'/Rubinius/ ... or?
# mrb_define_method(mrb, h, "values_at", hash_values_at, MRB_ARGS_ANY());
# RubyVM::InstructionSequence.compile "puts 1+4"  YARV became the official Ruby interpreter !!
#  3699712byte= 3.6MB! libruby.2.0.0.dylib
# http://www.reddit.com/r/ruby/comments/k9jce/ruby_ritevm_faq_and_timeline_updates/
# threads ok ++
# http://patshaughnessy.net/2012/6/29/how-ruby-executes-your-code
# Why I deverop ytljit instead of using llvm? Because according to
# my yarv2llvm's experience I think llvm don't have enough power
# for  Ruby compiler.

# VIA CYTHON??

# VIA C++ ? similar to j-rubyflux

# via AST? clang -Xclang -ast-dump -fsyntax-only test.cc
# http://clang.llvm.org/docs/IntroductionToTheClangAST.html
# probably not https://github.com/ioquatix/ffi-clang

class NativeEmitter
  include LLVM rescue nil

  #  HORRIBLE just to set a variable: http://llvm.org/docs/tutorial/LangImpl7.html !!!!!!!!!!!! :(
  #  OMG in LLVM IR, fields of structs do not have names.

  # F  = LLVM::Function([LLVM::Int], LLVM::Int)
  # FP = LLVM::Pointer(F) # FunctionPointers !!
  # LLVM::GenericValue.from_d(2.2).to_f(LLVM::Double)
  # ref = builder.gep(global, [LLVM::Int(0), LLVM::Int(0)])

  def args_match meth, args
    [@chars]
  end

  def norm args, types, block
    # args=args.to_s if args.is_a? TreeNode #TODO
    a=block.global_string_pointer(args);
    a
  end

  def setter context, node, modul, block
    var=node[:word]
    val=node[:expressions]
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

  def descend context, node, modul, func
    put node.name
    put "{"
    # method_call context, node, modul, func if node.name==:method_call
    case node.name
      when :method_call then
        method_call context, node, modul, func
      when :setter then
        setter context, node, modul, func
      when :algebra then
        algebra
    end

    for n in node.nodes
      descend context, n, modul, func
    end
    put "}"
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
