#!/usr/bin/env ruby

# mac OSX OSA:
# https://developer.apple.com/library/prerelease/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/index.html

# import opal
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
  import json

  def setter(var,val):
    command="var #{var}=result=#{val};"

  def map_method(meth):
    if meth=="increase": return "++"
    meth

  def list(context, node):
    l=node.value
    # if not l.contains_a TreeNode: return l
    mapped=l.map{|i| descend context,i}.join(",")
    return mapped

  def json_hash(context, node):
    # node=TreeNode.new
    e=node.content
    # DEBUG ^^
    l=node.value
    mapped=l.map_values{|i| descend context,i}
    return mapped.to_json

  def emit_method_call(obj,meth,params,native=false):
    if obj: params=[obj]+params
    set=EnglishParser.self_modifying(meth) ? params[0]+"=result=" : "result="
    command="#{set}#{meth}(#{params.join(",")})"

  def emit(interpretation, root,do_run=false):
    root||=interpretation.root
    self.file=File.open("../../build/app.js", "w") except None# ./test/unit/
    # self.file=File.open("../../../build/app.js", "w");
    # self.file=File.open("build/app.js", "w");
    if not self.file: self.file=File.open("app.js", "w")
    descend interpretation, root
    self.file.puts("console.log(result)")
    self.file.flush
    if do_run #danger 1: result=`node #{self.file}`.strip
    result=eval result except result #danger 1
    # exit 0
    return result

