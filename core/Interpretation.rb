require_relative "emitters/native-emitter"

class Interpretation
  #  don't put this into the parser!! it conflicts with the  grammar patterns
  attr_accessor :result,:methods,:ruby_methods,:svg,:javascript,:variables,:context
  attr_accessor :root,:tree,:nodes  # needs method interception which might not be available in debugging

  def evaluate
    NativeEmitter.new.emit self,run:true
  end

  def print
    puts tree
  end

  # def to_s
  #   puts tree
  # end
  #attr_accessor :error,:stacktrace,:error_position
end
