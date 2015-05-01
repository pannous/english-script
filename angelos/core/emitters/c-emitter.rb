import emitter
class NativeCEmitter < Emitter
  # def if_then_else(context, node):
  #   call(:checkCondition)
  # 
  def setter(var, val):
    if var.owner #??:
      "VALUE #{var.name}=set_property(#{var.owner},#{var},#{val.wrap});"
    else
      "VALUE #{var.name}=set(#{var.name.quoted},#{val.wrap});"


  # def norm(a):
  #   a=super.norm a
  #   if a.is_a?Numeric: a="i(#{a.to_s})"
  # 
  def map_method(meth):
    if meth=="minus": return "-"
    if meth=="plus": return "+"
    # if meth=="increase": return "++"
    # if meth=="decrease": return "--"
    meth

  def method_definition(context,node):
    function=node.value #==Function
    m="VALUE #{function.name}(VALUE arg){\n"

    for n in node.nodes:
      m+=descend context, n

    m+=";\nreturn result;" #if not function.return:
    m+="\n}"
    command="define_method(#{function.clazz},#{function.name.quoted},#{function.name},#{function.argc});"
    return m,command

  def emit_algebra(lhs,op,rhs):
    return "result=i(#{lhs.c}#{op}#{rhs.c});"
    # return "result=#{lhs}#{op}#{rhs.wrap};"

  def emit_method_call(obj,meth,params,native=false):
    set=EnglishParser.self_modifying(meth) ? obj.name+"=result=" :"result="
    # rb_thread_critical = Qtrue;
    if native  # static_cast<int> etc: return "#{set}#{meth}(#{params.values});"
    if self.methods[meth] # static_cast<int> etc: return "#{set}#{meth}(#{params.wraps});"
    if obj and ( params.empty? or params[0]==None or params[0]==obj): return "#{set}call0(#{obj.name},#{meth.id});"
    if not obj and (params.empty? or params[0]==None or params[0]==obj): return "#{set}call0(Object,#{meth.id});"
    if not obj: return "#{set}call(Object,#{meth.id},#{params.count},#{params.wraps});"
    return "#{set}call(#{obj.name},#{meth.id},#{params.count},#{params.wraps});"

  def call(obj, meth, args):
    "call(#{obj},#{meth},#{args});"

  def emit( interpretation, do_run=false):
    self.file=File("/tmp/emitted.c","w") #IO.open
    self.file.write("#include \"helpers.h\"\n")
    #  descend through Parent class emitter, Overwrite functions
    body=descend  interpretation, interpretation.root
    self.methods.each_value{|v|self.file.write("\n"+v+"\n")}
    self.file.write("VALUE run(VALUE arg){\n")
    self.file.puts body
    self.file.write("return result;\n");
    self.file.write("}")
    self.file.close
    `rm /tmp/main;`
    puts ""
    es_HOME=`echo $ENGLISH_SCRIPT_HOME`|| "/Users/me/dev/ai/english-script/"
    es_HOME.strip!
    path=es_HOME+"/src/core/emitters/"
    puts "$ENGLISH_SCRIPT_HOME="+es_HOME
    include=" -I$RUBY_DEV_HOME/.ext/include/x86_64-darwin13.2.0/ "
    include+=" -I#{es_HOME}/src/core/emitters/ " #helpers.c
    include+=" -I$ENGLISH_SCRIPT_HOME/src/core/emitters/ " #helpers.c
    include+=" -I$RUBY_DEV_HOME/include "
    command="gcc -g -Iruby #{include} -lruby /tmp/emitted.c #{path}/helpers.c -o /tmp/main"
    puts command
    ok=`#{command}`
    # puts STDERR.methods
    if $?.exitstatus!=0:
      puts "ERROR COMPILING!"
      puts $?
      exit!

    if do_run: result=`/tmp/main`
    result.strip

#     self.file.write("""
# #include <ruby.h>
# #include \"helpers.c\"
# int error;
# int main ( int argc, char ** argv) 	{
# 	ruby_init();
# 	rb_protect( run, 0, & error);// call our stuff rb_protect'ed
#  	ruby_finalize();
#  	return 0;
# }""")
