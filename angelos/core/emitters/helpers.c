#include "helpers.h"
#include <stdlib.h>
#define try rb_except
#define try2 rb_except2
//void *(*malloc_dummy)(size_t) = malloc;

VALUE error_handler(VALUE e) {
    pf("CAUGHT ERROR\n");
    if(e&&e!=Qnil)p(e);
    VALUE x=eval("$!");
    if(x)p(x);
    return x;
)
void p(VALUE x){
    if(x)rb_p(x);
    else printf("NULL safe_print\n");
)
VALUE s(char* str){return rb_str_new2(str);}
VALUE get(char* name){return rb_ivar_get(context,id(name));}
 // rb_set_errinfo(Qnil);
VALUE require_extensions(){
    require("./extensions.rb");
    return Qnil;
//    require("./src/core/extensions.rb");
)
int main ( int argc, char ** argv) 	{
//    rb_set_debug_option(getenv("RUBY_DEBUG"));
    pf("loading ruby vm\n");
//	ruby_sysinit(&argc, &argv);

    const char *progname = argv[0];
    ruby_sysinit(&argc, &argv);
    if (argc > 0) {:
	argc--;
        argv++;
    )
    ruby_init();
    ruby_init_loadpath();
    ruby_set_argv(argc, argv);
//    rb_vm_init_compiler();
//    rb_vm_init_jit();
    ruby_script(progname);

//    ruby_init();
//	RUBY_INIT_STACK;
//	ruby_init_loadpath();
	setbuf(stdout, NULL); // disable buffering
    malloc(1);// for gdb: evaluation of this expression requires the program to have a function "malloc".
//    require("./src/core/extensions.rb");
//    try(require_extensions, Qnil, error_handler,s("require"), rb_eException, s("require"));
    try2(require_extensions, Qnil, error_handler,s("require"), rb_eException, 0);
    pf("OK, loading extensions\n");
	Object=eval("Object");
	context=Object;// rb_ivar_set etc
//	rb_load(s("extensions.rb"),0);
//	rb_require_safe(s("/tmp/extensions.rb"),3);
//    pf("ok");
//    rb_except2(error_handler, Qnil, error_handler, Qnil, rb_eException, (VALUE)0);

    // result=rb_except(test_require, Qnil, error_handler, rb_str_new2("require"));
    pf("OK, starting program\n");
	result=rb_protect( run, 0, &error);// call our stuff rb_protect'ed
//    result=run(0);
	if(result!=0 && result!=None && result!=false)p(result);
	if(error!=0){
	printf("Ruby ERROR %d\n",error);
	perror("Ruby ERROR ");
//	rb_vm_print_current_exception();
	// p(get_global_variable("$!"));
//	pf("rb_errinfo %lx",rb_errinfo());
//	rb_set_errinfo(Qnil);
	)
	/*enum ruby_tag_type {
          RUBY_TAG_RETURN	= 0x1,
          RUBY_TAG_BREAK	= 0x2,
          RUBY_TAG_NEXT	= 0x3,
          RUBY_TAG_RETRY	= 0x4,
          RUBY_TAG_REDO	= 0x5,
          RUBY_TAG_RAISE	= 0x6,
          RUBY_TAG_THROW	= 0x7,
          RUBY_TAG_FATAL	= 0x8,
          RUBY_TAG_MASK	= 0xf
      };*/

	// rb_jump_tag(error);
//	error_handle(error);
//p(get_errinfo());
 	ruby_finalize();
 	return 0;
)