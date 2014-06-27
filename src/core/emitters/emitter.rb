#common Functionality for all immatures
class Emitter

  def args_match meth, args
    [@chars]
  end

  def descend context, node
    put node.name
    put "{"
    # method_call context, node, modul, func if node.name==:method_call
    case node.name
    when :method_call then
      method_call context, node
    when :setter then
      setter context, node
    when :algebra then
      algebra context, node
    when :if_then_else then
      if_then_else
    end

    for n in context.node.nodes
      descend context,n
    end
    put "}"
  end

end
