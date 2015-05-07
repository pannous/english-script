require_relative 'kast.rb'
# load 'kast.rb'
require 'yaml'
# reload!

puts "SEE YML TO XML FOR A DIFFERENT PATH"

file    ='kast.yml'
file    ='kast.yml.txt'
obs     =Object.methods
# p Kast.methods-obs
yml     =YAML::load(File.open(file)) # HASH!!
@methods={}
for method in Kast.instance_methods
  # methods[method]=method
  # methods[method.to_s]=method
  # methods[method.to_s.downcase]=method
  @methods[method.to_s.downcase.sub(/def$/, '')]=method #
end

@methods[:then]        =:Expression
@methods[:else]        =:Expression
@methods[:arg]         =:Expression # Danger: expects plural!
@methods[:args]        =:Expression
@methods[:argument]    =:Expression # Danger: kast expects plural!
@methods[:arguments]   =:Expression
@methods[:body]        =:Expression
@methods[:class_method]=:MethodDef #TODO!!
# p yml.methods-obs
# [:rehash, :to_hash, :to_h, :to_a, :[], :fetch, :[]=, :store, :default, :default=, :default_proc, :default_proc=, :key, :index, :size, :length, :empty?, :each_value, :each_key, :each_pair, :each, :keys, :values, :values_at, :shift, :delete, :delete_if, :keep_if, :select, :select!, :reject, :reject!, :clear, :invert, :update, :replace, :merge!, :merge, :assoc, :rassoc, :flatten, :member?, :has_key?, :has_value?, :key?, :value?, :compare_by_identity, :compare_by_identity?, :entries, :sort, :sort_by, :grep, :count, :find, :detect, :find_index, :find_all, :collect, :map, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :first, :all?, :any?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :each_with_index, :reverse_each, :each_entry, :each_slice, :each_cons, :each_with_object, :zip, :take, :take_while, :drop, :drop_while, :cycle, :chunk, :slice_before, :lazy, :to_set]
# p yml.class #HASH!
p @methods

# >>> file_ast=compile('if 1: z="hiiii"\nelse: 3;', source, 'exec',ast.PyCF_ONLY_AST)
# >>> ast.dump(file_ast)
# "Module(body=[If(test=Num(n=1), body=[Assign(targets=[Name(id='z', ctx=Store())], value=Str(s='hiiii'))], orelse=[Expr(value=Num(n=3))])])"


def walk node, body
  if node=="set"
    p node
  end
  return body if body.is_a? Integer
  return body if body.is_a? String
  # return node if not methods.has(node)
  method=@methods[node.to_s]
  if not method
    raise "UNKNOWN TYPE #{node}"
    return :None
  end
  constructor=Kast.instance_method(method)
  constructor=constructor.bind(Kast)
  content    ={}
  contents   =[]
  body.each_pair do |k, v|
    elem      =walk k, v
    content[k]=elem
    contents<<elem # many defs ...
  end
  # content[:body]||=contents
  # content[:elts]=nil
  constructor.call(content)
end

# p yml2xml :module, yml, 0
tree=walk :module, yml
puts tree.to_s
puts tree.dump
# p tree
# p tree.type

# yml.
# IO.readlines(file) do l
