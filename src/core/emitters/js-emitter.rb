#!/usr/bin/env ruby
# require 'opal'
# Opal code is 264 times slower than the raw JS code!!!
# VIA LLVM -> emscripten (mruby)
# OR DIRECTLY!

# APIS:
# contacts,mail,... Google's API Node JS Client
# https://github.com/unconed/TermKit

"" "
<!DOCTYPE html>
<html>
  <head>
    <META HTTP-EQUIV='CONTENT-TYPE' CONTENT='text/html; charset=UTF-8'>
    <script src='opal.js'></script>
    <script src='app.js'></script>
    <script src='english-script.js'></script>
  </head>
</html>
" ""
# f.puts Opal.compile("puts 'wow'")
# f.puts Opal.compile("x = (1..3).map do |n| n * n * n  end.reduce(:+); puts x")
# Opal::Builder.build('opal')

class JavascriptEmitter < Emitter
  require 'json'

  def setter context, node
    var=node[:word]||node[:variable]
    val=node[:value]||node[:expressions]
    command="var #{var}=result=#{val};"
  end

  def map_method meth
    return "++" if meth=="increase"
    meth
  end

  def list context, node
    l=node.value
    # return l if not l.contains_a TreeNode
    mapped=l.map{|i| descend context,i}.join(",")
    return mapped
  end

  def json_hash context, node
    # node=TreeNode.new
    e=node.content
    # DEBUG ^^
    l=node.value
    mapped=l.map_values{|i| descend context,i}
    return mapped.to_json
  end

  def emit_method_call meth,params
    set=EnglishParser.self_modifying(meth) ? params[0]+"=result=" : "result="
    command="#{set}#{meth}(#{params.join(",")})"
  end


  def emit interpretation, root,do_run=false
    root||=interpretation.root
    @file=File.open("../../build/app.js", "w") rescue nil# ./test/unit/
    # @file=File.open("../../../build/app.js", "w");
    # @file=File.open("build/app.js", "w");
    @file=File.open("app.js", "w") if not @file
    descend interpretation, root
    @file.puts("console.log(result)")
    @file.flush
    result=`node #{@file}`.strip if do_run #danger 1
    result=eval result rescue result #danger 1
    # exit 0
    return result
  end
end
