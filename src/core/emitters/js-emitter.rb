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

class JavascriptEmitter


  def setter context, node, modul, block
    var=node[:word]
    val=node[:value]||node[:expressions]
    command="var #{var}=result=#{val};"
  end

  def norm args, types, block
    args=[args] if not args.is_a? Array
    args=args.map { |a|
      a.is_a?(Argument) ? a.name_or_value : a
    }
    args
  end

  def args_match meth, args
  end

  # def self_modifying meth
  #
  # end
  def pre_map meth
    return "++" if meth=="increase"
    meth
  end
  def post_map meth
    meth
  end

  def method_call context, node, modul, block
    # puts("#{meth}(#{args.join(',')})") lol
    args     =node["arguments"]||node["object"]||node["arg"]
    meth0     =node["true_method"]||node["c_method"]
    meth = pre_map meth0
    arg_types=args_match(meth, args)
    params   =norm(args, arg_types, block)
    set=EnglishParser.self_modifying(meth0) ? params[0]+"=result=" : "result="
    meth = post_map meth
    command="#{set}#{meth}(#{params.join(",")})"
  end

  def descend context, node, modul='app', func=nil
    # put node.name
    # put "{"
    # method_call context, node, modul, func if node.name==:method_call
    case node.name
    when :method_call then
      command=method_call context, node, modul, func
    when :setter then
      command=setter context, node, modul, func
    when :algebra then
      command=algebra
    end

    puts command if command
    @file.puts command if command

    for n in node.nodes
      descend context, n, modul, func
    end
    # put "}"
  end

  def emit interpretation, root,do_run=false
    root||=interpretation.root
    @file=File.open("../../target/app.js", "w");
    descend interpretation, root
    @file.puts("console.log(result)")
    @file.flush
    result=`node #{@file}`.strip if do_run #danger 1
    result=eval result rescue result #danger 1
    # exit 0
    return result
  end
end
