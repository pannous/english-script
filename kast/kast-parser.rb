require_relative 'kast.rb'
# require 'xml'
require 'nokogiri'
# require 'libxml' #  identical : XML::Document.new == LibXML::XML::Document.new
# require 'xml/libxml' # if ^^ fails!


file='test.kast.xml'
schema_file='kast.xsd'

@obs=obs=Object.methods

begin
  schema = Nokogiri::XML::Schema(File.read(schema_file))
rescue Nokogiri::XML::SyntaxError => e
  puts "Invalid XML Schema! "+e.to_s
end


if not schema.valid?( file )
  puts schema.validate( file ).join("\n")
  raise "Invalid XML file #{file} under schema #{schema_file}!"
end

# doc = XML::Parser.string(xml_data).parse
doc = Nokogiri::XML(File.open(file))

# doc.find('//method').each{|p|
doc.xpath('//method').each{|p|
  puts p
  # puts  (p.find_first "id").to_s
  # puts  (p.find_first "id[@name='bla']").content.to_s  #content!!
  # attribute =(offer.find_first "@produktsku").value.to_s  #value!!
}

node=doc.root
# p (node.methods-obs).sort
# [:%, :/, :<<, :[], :[]=, :accept, :add_child, :add_namespace, :add_namespace_definition, :add_next_sibling, :add_previous_sibling, :after, :all?, :any?, :at, :at_css, :at_xpath, :attr, :attribute, :attribute_nodes, :attribute_with_ns, :attributes, :before, :canonicalize, :cdata?, :child, :children, :children=, :chunk, :collect, :collect_concat, :comment?, :content, :content=, :count, :create_external_subset, :create_internal_subset, :css, :css_path, :cycle, :decorate!, :default_namespace=, :delete, :description, :detect, :do_xinclude, :document, :drop, :drop_while, :each, :each_cons, :each_entry, :each_slice, :each_with_index, :each_with_object, :elem?, :element?, :element_children, :elements, :encode_special_chars, :entries, :external_subset, :find, :find_all, :find_index, :first, :first_element_child, :flat_map, :fragment, :fragment?, :get_attribute, :grep, :group_by, :has_attribute?, :html?, :inject, :inner_html, :inner_html=, :inner_text, :internal_subset, :key?, :keys, :last_element_child, :lazy, :line, :map, :matches?, :max, :max_by, :member?, :min, :min_by, :minmax, :minmax_by, :name=, :namespace, :namespace=, :namespace_definitions, :namespace_scopes, :namespaced_key?, :namespaces, :native_content=, :next, :next=, :next_element, :next_sibling, :node_name, :node_name=, :node_type, :none?, :one?, :parent, :parent=, :parse, :partition, :path, :pointer_id, :previous, :previous=, :previous_element, :previous_sibling, :read_only?, :reduce, :reject, :remove, :remove_attribute, :replace, :reverse_each, :search, :select, :serialize, :set_attribute, :slice_before, :sort, :sort_by, :swap, :take, :take_while, :text, :text?, :to_a, :to_h, :to_html, :to_set, :to_str, :to_xhtml, :to_xml, :traverse, :unlink, :values, :write_html_to, :write_to, :write_xhtml_to, :write_xml_to, :xml?, :xpath, :zip]

@methods={}
for method in Kast.instance_methods
  # methods[method]=method
  # methods[method.to_s]=method
  # methods[method.to_s.downcase]=method
  @methods[method.to_s.downcase.sub(/def$/, '')]=method#
end

@methods[:then]=:Expression
@methods[:else]=:Expression
@methods[:arg]=:Expression # Danger: expects plural!
@methods[:args]=:Expression
@methods[:argument]=:Expression # Danger: kast expects plural!
@methods[:arguments]=:Expression
@methods[:body]=:Expression
@methods[:class_method]=:MethodDef #TODO!!

def walk type, node
  p type
  return :None if not type
  return node.text.to_i if type=='int'
  # return node if not methods.has(node)
  method=@methods[type.to_s]
  if not method
    raise "UNKNOWN TYPE #{type}"
    return :None
  end

  # method=@methods.get(node.to_s)
  constructor=Kast.instance_method(method)
  # p constructor.methods-@obs    [:arity, :original_name, :owner, :bind, :source_location, :parameters]
  constructor=constructor.bind(Kast)
  # => [:call, :curry, :[], :arity, :to_proc, :receiver, :original_name, :owner, :unbind, :source_location, :parameters, :super_method, :source, :comment]
  p constructor

  content={}
  for att in node.attribute_nodes
    content[att.name]=att.value
  end
  contents=[]
  for element in node.element_children
    k=element.name
    v=element
    elem=walk k,v
    content[k]=elem
    contents<<elem # many defs ...
  end
  contents=node.text if not node.element_children or node.element_children.count==0
  content[:body]||=contents
  # p content
  constructor.call(content)
end
tree=walk :module, node
p tree
# yml.
# IO.readlines(file) do l
