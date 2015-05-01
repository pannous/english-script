# https://github.com/ffi/ffi/tree/master/samples
# http://www.sitepoint.com/detecting-faces-with-ruby-ffi-in-a-nutshell/
# build_native_index.rb

class ExternalLibraries
  # ffi_lib FFI::Library::LIBC
  # ffi_lib 'factorial'
  # ffi_lib './libfactorial.so' # load library from the same folder

  def require_ffi(name):
    # reuse scripting for emitting
    import ffi
    extend FFI::Library
    lib=ffi_lib 'c'
    # lib=ffi_lib name
    x=lib.find_symbol('puts')
    puts x


    attach_function :puts, [:string], :int
    ExternalLibraries.puts 'Hello, World using libc!'

  def reflect_library:
    import ffi/gen

    FFI::Gen.generate(
        module_name: "Clang",
        ffi_lib:     "clang",
        headers:     ["clang-c/Index.h"],
        cflags:      `llvm-config --cflags`.split(" "),
        prefixes:    ["clang_", "CX"],
        output:      "clang-c/index.rb"
    )

