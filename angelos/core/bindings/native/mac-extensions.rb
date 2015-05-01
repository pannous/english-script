class MacExtensions
  # osx/cocoa DEPRECATED
  # see mruby-cocoa
  # rubymotion PROPRIETARY!

  import ffi' # doesnt allow for catching Signals
  # does NOT support events!!
  # https://github.com/thibaudgg/rb-fsevent

    extend FFI::Library
    ffi_lib './libfactorial.so' # load library from the same folder
    # this time we take an integer and return an unsigned integer
    attach_function :factorial, [:int], :uint

  # import osx/cocoa
  # import osx
  #
  # import 
  # OSX.require_framework 'ScriptingBridge'
  #
  # class Mail
  #   def check(self):
  #     mail = SBApplication.applicationWithBundleIdentifier("com.apple.mail")
  #     mail.accounts.each {|account| mail.checkForNewMailFor(account) }
  #   
  # 