# https://github.com/jvoorhis/ruby-llvm
# http://llvm.org/releases/3.4/docs/index.html
# https://developer.chrome.com/native-client/reference/pnacl-bitcode-abi

# require 'llvm' # ACTIVE project ++
# require 'ruby-llvm'
require 'llvm/core'
require 'llvm/execution_engine'
require 'llvm/transforms/scalar'

class NativeEmitter
  include LLVM

  def args_match meth, args
    [@chars]
  end

  def norm args,types,block
    # args=args.to_s if args.is_a? TreeNode #TODO
    a=block.global_string_pointer(args);
    a
  end

  def method_call context, node, modul, block
    args=node["arguments"]||node["object"]
    meth=node["true_method"]||node["c_method"]
    arg_types=args_match(meth,args)
    return_type=LLVM.Void # 'EGAL!'
    func=@included[meth]|| modul.functions.add(meth, arg_types,return_type)
    @included[meth]=func
    # func.basic_blocks.append.build do |block|
    params=norm(args,arg_types,block)
    result=block.call(func,params)
    puts result
    # end
  end

  def descend context, node, modul, func
    put node.name
    put "{"
    # method_call context, node, modul, func if node.name==:method_call
    case node.name
      when :method_call then method_call context, node, modul, func
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
        block.ret_void
        # builder.return(0.llvm)
        # builder.return(0.llvm(LLVM::Int32Ty))
      end
    end


#, arg = (ARGV[0] || 6).to_i)

# OR via ruby emitter: use FFI to call that DLL from Ruby https://github.com/ffi/ffi
    puts "COMPILING!!!"
    modul.write_bitcode("./build/main.bc")
    `llc -filetype=obj ./build/main.bc -o ./build/main.o` # to compile!!
# `COMPILER_ARGS=llvm-config --libs core jit native --cxxflags --ldflags`
    `clang++ $COMPILER_ARGS ./build/main.o -o ./target/main` # or any other gcc!!

    puts "EXECUTING FILE!!!"
    system("./target/main")
    # system("./target/main&")

    puts "\nEXECUTING JIT!!!"
    engine = LLVM::JITCompiler.new(modul) #LIVE TEST!
    result=engine.run_function(modul.functions["main"]) if do_run

    result
  end
end
