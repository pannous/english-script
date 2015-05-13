require "rubyast"

file="../test/unit/condition_test.rb"

# ast = RubyAST.parse("(string)", "x = 1") # OK (via SLIM java: jrubyparser-0.2.jar)
ast = RubyAST.parse(file, IO.read(file))

def escape_xml(xml)
  xml
end
# source = RubyAST.to_source(ast)
# p ast.toString
def walk(node, indent)
  t=node.getClass.to_s.sub("#<Rjb::", "").sub(/\:.*/, "").gsub(/.*_/, "").gsub(/Node$/, "") #getNodeType
  hasName=node.getName rescue false
  # hasValue=node.getValueNode rescue false
  hasValue=node.getValue rescue false

  #getValueNode
  if hasName # respond_to? :getValueNode
    if hasValue # respond_to? :getValueNode
      p "VALUE #{hasValue.toString}"
    end
    if node.childNodes.size>0
      puts "\t"*indent+ "<#{t} name='#{hasName}'>"
    else
      puts "\t"*indent+ "<#{t} name='#{hasName}'/>"
      return
    end
  else
    if hasValue
      if(not hasValue.is_a?String or not hasValue.index("'"))
        puts "\t"*indent+ "<#{t} value='#{hasValue}'/>"
        return
      else
        puts "\t"*indent+ "<#{t}>#{escape_xml(hasValue)}"
      end
    else
      puts "\t"*indent+ "<#{t}>" if t!="Newline"
    end
  end
  # if t=="Str"
  #   x=1
  # end
  for c in node.childNodes.toArray #forEach # iterator listIterator spliterator stream subList toArray
    walk c, indent+(t=="Newline" ? 0 : 1)
  end
  puts "\t"*indent+ "</#{t}>" if t!="Newline"
end

walk ast.getBodyNode, 0 #skip root

# p source

