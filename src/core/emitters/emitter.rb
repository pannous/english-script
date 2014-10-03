#common Functionality for all immatures
class Emitter

  def initialize
    @methods={}
  end

  def args_match meth, args
    [@chars]
  end

  def norm a,context
    a=a.value if a.is_a?(TreeNode)
    a=a.name_or_value if a.is_a?(Argument)
    a=map_method a #if ...!
    a
  end

  def norm_args args, types, block
    args=[args] if not args.is_a? Array
    args=args.map { |a| norm(a,block)}
    args
  end

  def map_method meth
    meth
  end

  def method_call context, node
    # puts("#{meth}(#{args.join(',')})") lol
    obj=node["object"]
    args     =node["arguments"]||node["args"]||node["arg"]
    meth0     =node["true_method"]
    meth0     ||=node["ruby_method_call"]
    if node["c_method"]
      native=true
      meth0     ||=node["c_method"]
    end
    meth = map_method meth0.strip
    arg_types=args_match(meth, args)
    params   =norm_args(args, arg_types,context)
    emit_method_call obj,meth,params,native
  end

  def algebra context, node
    lhs=norm(node[0],context)
    op=norm(node[1],context)
    rhs=norm(node[2],context)
    emit_algebra lhs,op,rhs
  end


  def descend context, node
    return node if not node.is_a? TreeNode
    # return if not node.valid
    put node.name
    put "{"
    # method_call context, node, modul, func if node.name==:method_call
    case node.name
    when :statement then
      command=nil #//result=" # + ... subnodes
    when :method_call then
      command=method_call context, node
    when :setter then
      var=node[:var]#||node[:variable]||node[:word]
      val=node[:val]#||node[:value]||node[:expressions]
      command=setter var,val
    when :algebra then
      command=algebra context, node
    when :if_then_else then
      command=if_then_else context, node
    when :json_hash then
      command=json_hash(context, node)
    when :method_definition then
      @methods[node.value.name]=method_definition context, node
    end
    if command
      puts command
      @file.puts command if @file
    end

    for n in node.nodes
      descend context, n
    end
    put "}"
  end

end
