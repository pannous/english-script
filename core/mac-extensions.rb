module MacExtensions

  require 'ffi' # doesn't allow for catching Signals
  # does NOT support events!!
  # https://github.com/thibaudgg/rb-fsevent

    extend FFI::Library
    ffi_lib './libfactorial.so' # load library from the same folder
    # this time we take an integer and return an unsigned integer
    attach_function :factorial, [:int], :uint

  # require 'osx/cocoa'
  # require 'osx'
  #
  # include OSX
  # OSX.require_framework 'ScriptingBridge'
  #
  # class Mail
  #   def self.check
  #     mail = SBApplication.applicationWithBundleIdentifier("com.apple.mail")
  #     mail.accounts.each {|account| mail.checkForNewMailFor(account) }
  #   end
  # end
end
