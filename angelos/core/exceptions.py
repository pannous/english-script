# encoding: utf-8
# import minitest
  # DONT ROLLBACK StandardError
  # DO ROLLBACK all NotMatching
global NotMatching
# class StandardError(Exception):
#     pass

# class Error(Exception):
#     pass
class InternalError(StandardError):
    pass

class NoMethodError(StandardError):
    pass

class InternalError(StandardError):
    pass

class NotMatching(StandardError):
    pass

class UnknownCommandError(StandardError):
    pass

class SecurityError(StandardError):
    pass

# NotPassing = Class.new StandardError
class NotPassing(StandardError):
    pass

class NoResult(NotMatching):
    pass

class EndOfDocument(StandardError):
    pass

class EndOfLine(NotMatching):
    pass

class MaxRecursionReached(StandardError):
    pass

class EndOfBlock(NotMatching):
    pass

class GivingUp(StandardError):
    pass

class ShouldNotMatchKeyword(NotMatching):
    pass

class KeywordNotExpected(NotMatching):
    pass

class UndefinedRubyMethod(NotMatching):
    pass

class WrongType(StandardError):
    pass

class ImmutableVaribale(StandardError):
    pass

class SystemStackError(StandardError):
    pass



