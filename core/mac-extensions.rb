module MacExtensions
  require 'osx/cocoa'
  require 'osx'

  include OSX
  OSX.require_framework 'ScriptingBridge'

  class Mail
    def self.check
      mail = SBApplication.applicationWithBundleIdentifier("com.apple.mail")
      mail.accounts.each {|account| mail.checkForNewMailFor(account) }
    end
  end
end
