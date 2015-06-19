#!/usr/bin/env ruby

#  again via AST:
# https://v8.googlecode.com/svn/trunk/src/ast.h

# Jeremy Ashkenas @ coffeescript -> T800 teescript .tee .t

# OPAL opal = ruby to js
# http://opalrb.org/try/
# require 'opal'
# Opal code is 264 times slower than the raw JS code!!!
# VIA LLVM -> emscripten (mruby)
# OR DIRECTLY!


# appcelerator Write in JavaScript, run native on any device and OS

# via python:  PyPy compiled to 'JavaScript' (emscripten/asmjs)
# :( !! Loading PyPy.js. It's big, so this might take a while :( http://pypyjs.org/

# TypeScript is a free and open source programming language developed and maintained by Microsoft. It is a strict superset of JavaScript, and adds optional static typing and class-based object-oriented programming to the language.

# VIA CLOSURE! https://github.com/clojure/clojurescript

# obviously we don't want to use those obscure programming languages we just want to hijack that compiler pipeline
# Dart (programming language), has its own VM, compiles to JS. Type system not very strict, supports mixins.

# Jelly
# Jelly is a tool for turning XML into executable code.

# mac OSX OSA:
# https://developer.apple.com/library/prerelease/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/index.html

# APIS:
# contacts,mail,... Google's API Node JS Client
# https://github.com/unconed/TermKit

# later see Rhino + node ECMS 6

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

# https://github.com/whitequark/coldruby

class JavascriptEmitter < Emitter
  require 'json'

  def setter var,val
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

  def emit_method_call obj,meth,params,native=false
    params=[obj]+params if obj
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
