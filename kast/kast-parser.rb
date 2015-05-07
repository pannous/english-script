require_relative 'kast.rb'
# require 'file'
require 'nokogiri'
# require 'libxml' #  identical : XML::Document.new == LibXML::XML::Document.new
# require 'file/libxml' # if ^^ fails!


fileName   ='test.kast.xml'
fileName   ='kast.yml'
schema_file='kast.xsd'

@obs=obs=Object.methods

begin
  schema = Nokogiri::XML::Schema(File.read(schema_file))
rescue Nokogiri::XML::SyntaxError => e
  puts "Invalid XML Schema! "+e.to_s
  exit
end


def yml2xml builder, body, tabs=0
  builder.puts "<module xmlns='http://angle-lang.org'>" if (tabs==0 and body.length>1)
  body.each_pair do |k, v|
    val=v.is_a? Integer
    val||=v.is_a? Fixnum
    val||=v.is_a? String
    val||=v.is_a? TrueClass
    val||=v.is_a? FalseClass
    if val
      builder.puts "\t"*tabs+"<#{k}>#{v}</#{k}>"
    else
      builder.puts "\t"*tabs+"<#{k}>"
      yml2xml builder, v, tabs+1
      builder.puts "\t"*tabs+"</#{k}>"
    end
  end
  builder.puts "</module>" if (tabs==0 and body.length>1)
  return builder
end

file=File.open(fileName)
if fileName.end_with? "yml"
  file =yml2xml(StringIO.new, YAML::load(file)).string
end
doc = Nokogiri::XML(file)
# puts doc.to_xml
if not schema.valid?(doc)
  puts schema.validate(doc).join("\n")
  raise "Invalid XML fileName #{fileName} under schema #{schema_file}!"
else
  p"schema OK"
end

# doc = XML::Parser.string(xml_data).parse
node=doc.root

@methods={}
for method in Kast.instance_methods # module.methods == Classes!!
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
    k         =element.name
    v         =element
    # if k=="name"
    elem      =walk k, v
    content[k]=elem
    contents<<elem # many defs ...
  end
  contents      =node.text if not node.element_children or node.element_children.count==0
  content[:body]||=contents
  p content
  constructor.call(content)
end

tree=walk :module, node
p tree
