require_relative 'emitter'
class NativeCEmitter < Emitter
  # def if_then_else context, node
  #   call(:checkCondition)
  # end

  def setter var, val
    if var.owner
      "set_property(#{var.owner},#{var},#{val});"
    else
      "set(#{var.name.quoted},#{val.wrap});"
    end
  end

  def call obj, meth, args
    "call(#{obj},#{meth},#{args});"
  end

  def emit  interpretation, do_run=false
    @file=File.new("emitted.c","w") #IO.open
    # @file.write("#include <ruby.h>")
    @file.write("#include \"helpers.c\"\n")
#     @file.write("""
# #include <ruby.h>
# #include \"helpers.c\"
# int error;
# int main ( int argc, char ** argv) 	{
# 	ruby_init();
# 	rb_protect( run, 0, & error);// call our stuff rb_protect'ed
#  	ruby_finalize();
#  	return 0;
# }""")
    @file.write("VALUE run(VALUE arg){\n")
    descend  interpretation, interpretation.root
    @file.write("}")
    include="$RUBY_DEV_HOME/.ext/include/x86_64-darwin13.2.0/"
    `gcc -Iruby -I$RUBY_DEV_HOME/include -I#{include} -lruby emitted.c -o main`
    `./main` if do_run
  end

end
