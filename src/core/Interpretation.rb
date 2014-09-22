# require_relative "emitters/native-emitter"

# why not return parser??
class Interpretation
  #  don't put this into the parser!! it conflicts with the  grammar patterns
  attr_accessor :result,:methods,:ruby_methods,:svg,:javascript,:variables,:context
  attr_accessor :root,:tree,:nodes  # needs method interception which might not be available in debugging

  # def print
  #   puts tree
  # end

  # def to_s
  #   puts tree
  # end
  #attr_accessor :error,:stacktrace,:error_position
end
