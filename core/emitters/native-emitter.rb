# https://github.com/jvoorhis/ruby-llvm
# http://llvm.org/releases/3.4/docs/index.html
# https://developer.chrome.com/native-client/reference/pnacl-bitcode-abi

# require 'llvm' # ACTIVE project ++
# require 'ruby-llvm'
require 'llvm/core'
require 'llvm/execution_engine'
require 'llvm/transforms/scalar'

include LLVM
LLVM.init_x86

chars = LLVM::Type.pointer(LLVM::Int8Ty) ## CHAR==Int8 !!!!!!

# Creates a new modul to hold the code
modul = LLVM::Module.new("natlash")
host_module=modul

ftype=LLVM::Type.function([chars], LLVM::Int32Ty)
# printf = host_module.functions.add("printf", [chars], LLVM::Int32Ty)
printf = host_module.functions.add("printf", ftype)
getenv = host_module.functions.add("getenv", [LLVM::Pointer(LLVM::Int8)], LLVM::Pointer(LLVM::Int8))

main = modul.functions.add("main", [], LLVM.Void) do |fn|
  fn.basic_blocks.append.build do |block|
    grapes_str = block.global_string_pointer("I LIKE GRAPES!\n")
    grapes_str = block.call(getenv, block.global_string_pointer("SHELL"))
    block.call(printf, grapes_str)
    block.ret_void
    # builder.return(0.llvm)
    # builder.return(0.llvm(LLVM::Int32Ty))
  end
end

engine = LLVM::JITCompiler.new(modul)#LIVE TEST!
value = engine.run_function(modul.functions["main"]) #, arg = (ARGV[0] || 6).to_i)

# OR via ruby emitter: use FFI to call that DLL from Ruby https://github.com/ffi/ffi
modul.write_bitcode("../build/main.bc")
`llc -filetype=obj ../build/main.bc -o ../build/main.o` # to compile!!
`COMPILER_ARGS=llvm-config --libs core jit native --cxxflags --ldflags`
`clang++ $COMPILER_ARGS ../build/main.o -o ../target/main` # or any other gcc!!
`../target/main`
