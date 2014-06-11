module Exceptions
  # DONT ROLLBACK StandardError
  # DO ROLLBACK all NotMatching
NotMatching = Class.new StandardError
NotPassing = Class.new StandardError
NoResult = Class.new NotMatching
EndOfDocument = Class.new StandardError
EndOfLine=  Class.new NotMatching
MaxRecursionReached= Class.new StandardError
EndOfBlock=  Class.new NotMatching
GivingUp= Class.new StandardError
ShouldNotMatchKeyword=  Class.new NotMatching
KeywordNotExpected=  Class.new NotMatching
UndefinedRubyMethod=  Class.new NotMatching
WrongType = Class.new StandardError
end
