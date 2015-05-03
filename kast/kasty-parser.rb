require_relative 'kast.rb'
# require 'yml'

file='kast.yml'
obs=Object.methods
# p Kast.methods-obs
yml=YAML::load(File.open(file)) # HASH!!
methods={}
for method in Kast.instance_methods
  # methods[method]=method
  # methods[method.to_s]=method
  # methods[method.to_s.downcase]=method
  methods[method.to_s.downcase.sub(/def$/, '')]=method#
end
# p yml.methods-obs
# [:rehash, :to_hash, :to_h, :to_a, :[], :fetch, :[]=, :store, :default, :default=, :default_proc, :default_proc=, :key, :index, :size, :length, :empty?, :each_value, :each_key, :each_pair, :each, :keys, :values, :values_at, :shift, :delete, :delete_if, :keep_if, :select, :select!, :reject, :reject!, :clear, :invert, :update, :replace, :merge!, :merge, :assoc, :rassoc, :flatten, :member?, :has_key?, :has_value?, :key?, :value?, :compare_by_identity, :compare_by_identity?, :entries, :sort, :sort_by, :grep, :count, :find, :detect, :find_index, :find_all, :collect, :map, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :first, :all?, :any?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :each_with_index, :reverse_each, :each_entry, :each_slice, :each_cons, :each_with_object, :zip, :take, :take_while, :drop, :drop_while, :cycle, :chunk, :slice_before, :lazy, :to_set]
p yml.class
p methods
def walk node, body
  p node
  return node if node.is_a? Integer
  # return node if not methods.has(node)
  method=methods[node.to_s]
  constructor=Kast.instance_method(method)
  content={}
  body.each_pair do |k,v|
    content[k]=walk k,v
    contents[k]<<walk(k,v) # many defs ...
  end
  constructor.call(content)
end
tree=walk :module, yml
p tree
# yml.
# IO.readlines(file) do l
