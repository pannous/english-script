#!/usr/bin/env ruby
# http://jruby.org/apidocs/org/jruby/ast/package-tree.html
require "rubyast" # using jruby/ast in normal ruby!
require "yaml"
# sudo gem install ruby_parser sexp->xml

# file="../test/unit/condition_test.rb"
# file="../src/core/english-parser.rb"

@map={}
# <FCall name='require'> => require<im
def load_map
  dir=File.symlink?(__FILE__) ? File.dirname( File.readlink(__FILE__)): File.dirname(__FILE__)
  yml_map_file= dir+'/transforms/rast-map.yml'
  @map=YAML::load(File.open(yml_map_file))
end

def dump_xml(file, out=STDOUT,map=true)
# ast = RubyAST.parse("(string)", "x = 1") # OK (via SLIM java: jrubyparser-0.2.jar)
  begin
    load_map if map #Hash
    ast = RubyAST.parse(file, IO.read(file))
    walk(out, ast.getBodyNode, ast, 0)
  rescue
    puts "CANT PARSE " +file
  end
end


def escape_xml(xml)
  xml.gsub("<","&lt;").gsub(">","&gt;")
end

# source = RubyAST.to_source(ast)
# p ast.toString
def walk(out, node, parent, indent, parentNode=nil)
  name0  =node.getClass.to_s.sub("#<Rjb::", "").sub(/\:.*/, "").gsub(/.*_/, "").gsub(/Node$/, "") #getNodeType
  name  = @map[name0] ? @map[name0] : name0
  name  ="Args" if parent=="Call" and name=="Array" # Name != Args!!
  # name  ="Attrib" if parent=="Assign" and name0=="VCall"
  hidden= ["Newline", "List", "Str"].index name #, "Arguments"
  # hidden=false
  return if parent=="Method" and name=="Argument" # Name != Args!!


  hasName=node.getName rescue false
  hasName=false if name=="True" or name=="False" or name=="Self"
  # hasName=parentNode.getName + "' attr='"+hasName if name  =="Attrib" and parent=="Assign" #HAA
  # hasValue=node.getValueNode rescue false
  hasValue=node.getValue rescue false

  #getValueNode
  if hasName # respond_to? :getValueNode
    if hasValue # respond_to? :getValueNode
      p "VALUE #{hasValue.toString}"
    end
    if node.childNodes.size>0
      out.puts "\t"*indent+ "<#{name} name='#{hasName}'>"
    else
      out.puts "\t"*indent+ "<#{name} name='#{hasName}'/>"
      return
    end
  else
    if hasValue
      if (hasValue.is_a? String)
        out.puts "\t"*indent+ "<#{name}>#{escape_xml(hasValue)}</#{name}>"
      else
        out.puts "\t"*indent+ "<#{name} value='#{hasValue}'/>"
      end
        return
    else
      if node.childNodes.size>0
        out.puts "\t"*indent+ "<#{name}>" unless hidden
      else
        out.puts "\t"*indent+ "<#{name}/>"
        return
      end
    end
  end
  # if t=="Str"
  #   x=1
  # end
  for c in node.childNodes.toArray #forEach # iterator listIterator spliterator stream subList toArray
    walk out, c, name, indent+(hidden ? 0 : 1), node
  end
  out.puts "\t"*indent+ "</#{name}>" unless hidden
end

# https://github.com/jruby/jruby/wiki/Truffle
# JRuby+Truffle - a High-Performance Truffle Backend for JRuby
# The Truffle runtime of JRuby is an experimental implementation of an interpreter for JRuby using the Truffle AST interpreting framework and the Graal compiler. It’s an alternative to the IR interpreter and bytecode compiler. The goal is to be significantly faster, simpler and to have more functionality than other implementations of Ruby.


if __FILE__==$0 # shell main
  # this will only run if the script was the main, not load'd or require'd
  # file="/Users/me/dev/ai/english-script/src/core/extensions.rb"
  # dump_xml(file)
  load_map

  if ARGV.length>0
    file=ARGV[0]
    puts "loading #{file}"
    dump_xml(file)
  else
    content="'abc'.split('b')"
    ast = RubyAST.parse("(string)", content) # OK (via SLIM java: jrubyparser-0.2.jar)
    walk(STDOUT, ast.getBodyNode, ast, 0)
  end
end
