# encoding: utf-8
require 'minitest'
module Exceptions
  # DONT ROLLBACK StandardError
  # DO ROLLBACK all NotMatching
  InternalError = Class.new StandardError
  NotMatching = Class.new StandardError
  # NotPassing = Class.new StandardError
  NotPassing = Class.new Minitest::Assertion
  NoResult = Class.new NotMatching
  EndOfDocument = Class.new StandardError
  EndOfLine= Class.new NotMatching
  MaxRecursionReached= Class.new StandardError
  EndOfBlock= Class.new NotMatching
  GivingUp= Class.new StandardError
  ShouldNotMatchKeyword= Class.new NotMatching
  KeywordNotExpected= Class.new NotMatching
  UndefinedRubyMethod= Class.new NotMatching
  WrongType = Class.new StandardError
  ImmutableVaribale = Class.new StandardError

  def filter_stack s
    s.select { |x| not (
    x.index "method_missing" or
        x.index "`tokens'" or
        x.index "`block'" or
        x.index "`maybe'" or
        x.index "`any'" or
        x.index "`many'" or
        x.index "`star'" or
        x.index ".rvm") }
  end
  def filter_backtrace e
    e.set_backtrace filter_stack e.backtrace
  end

end

# hack to enable true.is_a?(Boolean) #=> true
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end
