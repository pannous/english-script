#common Functionality for all immatures
class Emitter

  def initialize:
    self.methods={}

  def args_match(meth, args):
    [self.chars]

  def norm(a,context):
    if a.is_a?(TreeNode): a=a.value
    if a.is_a?(Argument): a=a.name_or_value
    a=map_method a #if ...!:
    a

  def norm_args(args, types, block):
    if not args.is_a? Array: args=[args]
    args=args.map { |a| norm(a,block)}
    args

  def map_method(meth):
    meth

  def method_call(context, node):
    # puts("#{meth}(#{args.join(',')})") lol
    obj=node["object"]
    args     =node["arguments"]||node["args"]||node["arg"]
    meth0     =node["true_method"]
    meth0     ||=node["ruby_method_call"]
    if node["c_method"]:
      native=true
      meth0     ||=node["c_method"]

    meth = map_method meth0.strip
    arg_types=args_match(meth, args)
    params   =norm_args(args, arg_types,context)
    emit_method_call obj,meth,params,native

  def algebra(context, node):
    lhs=norm(node[0],context)
    op=norm(node[1],context)
    rhs=norm(node[2],context)
    emit_algebra lhs,op,rhs

  def descend(context, node):
    if not node.is_a? TreeNode: return node
    body=""
    # if not node.valid: return
    put node.name
    put "{"
    # if node.name==:method_call: method_call context, node, modul, func
    case node.name
    when :statement then
      command=None #//result=" # + ... subnodes
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
      meth,command=method_definition context, node
      self.methods[node.value.name]=meth

    if command:
      puts command
      body+=command

    for n in node.nodes:
      body+=descend context, n

    put "}"
    return body
