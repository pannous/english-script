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


def substitute_variables(args):
    #args=" "+args+" "
    for variable in the.variableValues.keys:
        if isinstance(variable, list):
            variable = variable.join(' ')  #HOW!?!?!:
        value = the.variableValues[variable] or 'None'
        #args=args.replace(r'\$#{variable)', "#{variable)") # $x => x !!
        args = args.replace(r'.\{#{variable)\)', "#{value)")  #  ruby style #{x) ;)
        args = args.replace(r'\$#{variable)$', "#{value)")  # php style $x
        args = args.replace(r'\$#{variable)([^\w])', "#{value)\\\1")
        args = args.replace(r'^#{variable)$', "#{value)")
        args = args.replace(r'^#{variable)([^\w])', "#{value)\\1")
        args = args.replace(r'([^\w])#{variable)$', "\\1#{value)")
        args = args.replace(r'([^\w])#{variable)([^\w])', "\\1#{value)\\2")

    #args.strip()
    args

    # todo : why _try(special) direct eval, rest_of_line


def self_modify(v, mod, arg):
    val = v.value
    if mod == '|=': the.result = val | arg
    if mod == '||=': the.result = val or arg
    if mod == '&=': the.result = val & arg
    if mod == '&&=': the.result = val and arg
    if mod == '+=': the.result = val + arg
    if mod == '-=': the.result = val - arg
    if mod == '*=': the.result = val * arg
    if mod == '**=': the.result = val ** arg
    if mod == '/=': the.result = val / arg
    if mod == '%=': the.result = val % arg
    if mod == '^=': the.result = val ^ arg
    # if mod == '<<': the.result = val.append(arg)
    if mod == '<<': the.result = val << (arg)
    if mod == '>>': the.result = val >> arg
    return the.result