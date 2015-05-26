# import emitters/native-emitter

# why not return parser??
import events
import the


class Interpretation:
    pass
  #  don't put this into the parser!! it conflicts with the  grammar patterns
  #attr_accessor :result,:methods,:ruby_methods,:svg,:javascript,:variables,:context
  #attr_accessor :root,:tree,:nodes  # needs method interception which might not be available in debugging

  # def print:
  #   puts tree
  # 
  # def to_s:
  #   puts tree
  # 
  #attr_accessor :error,:stacktrace,:error_position



def add_trigger(condition, action):
    import power_parser
    if power_parser.interpreting():
        return the.listeners.append(events.Observer(condition, action))