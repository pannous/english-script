require_relative '../../cast/cast'
require_relative 'nodes/argument'
require_relative 'nodes/function.rb'
require_relative 'nodes/function-call'
require_relative 'nodes/quote.rb'
require_relative 'nodes/variable.rb'

class Script < Kast::Expression
  attr_reader :body,:type
  def initialize(body, type)
    @body = body
    @type = type
  end
end

class Cast < Kast::Expression
  # The expression to cast
  attr_reader :expr

  # The type to which to cast the expression
  attr_reader :type

  # Set the attributes to the given arguments
  def initialize(expr, type)
    @expr = expr
    @type = type
  end

end
