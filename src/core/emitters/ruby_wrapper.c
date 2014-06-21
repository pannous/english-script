// Wrapper for ruby bytecode apps
// INIT RUBY RUNTIME,
// LOAD+EVAL AOT compiled InstructionSequence
// test compile:
// gcc -I/System/Library/Frameworks/Ruby.framework/Versions/2.0/Headers -lruby ruby_wrapper.c -o main
// killall main || gcc -Iruby -I$RUBY_DEV_HOME/include -I$RUBY_DEV_HOME/.ext/include/x86_64-darwin13.2.0/ -lruby ruby_wrapper.c -o main && ./main &

#include <stdio.h>
#include <stdlib.h>
#include <ruby.h>
#include "vm_debug.h"
// #include <value.h>
// #include <node.h>
// #include <iseq.h>

// #define eval rb_eval_string
#define eval(x) rb_eval_string_protect(x,&error);
#define p rb_p
#define s(x) rb_str_new2(x)
#define id rb_intern
#define sym(x) ID2SYM(rb_intern(x))
#define global_variable rb_gv_get
#define pf printf

// #define s rb_string_value_cstr
// #define f rb_float_new
// #define i INT2FIX

// const char *rb_id2name(ID);
// ID rb_intern(const char*);
// ID rb_intern2(const char*, long);
// ID rb_intern_str(VALUE str);
// ID rb_check_id(volatile VALUE *);
// ID rb_to_id(VALUE);
// VALUE rb_id2str(ID);

RUBY_EXTERN VALUE rb_cISeq;
int error;

int main ( int argc, char ** argv) 	{
    ruby_set_debug_option(getenv("RUBY_DEBUG"));
	ruby_sysinit(&argc, &argv);
	RUBY_INIT_STACK;
	ruby_init();
	ruby_init_loadpath();
	setbuf(stdout, NULL); // disable buffering
	rb_protect( test_iseq, 0, & error);// call our stuff rb_protect'ed
	perror("ERROR");
	return ruby_run_node(ruby_options(argc, argv));
 	ruby_finalize();
 	return 0;
}


VALUE test_iseq(VALUE arg)
{
	VALUE v;
	// rb_require("rubygems");
	// rb_protect( (VALUE (*)(VALUE))rb_require, (VALUE) "iseq", &error);
	// perror("require 'iseq'");
	// rb_class_new_instance(argc, argv, klass);
	p(s("OK"));
	ruby_show_version();
	VALUE iseq=eval("$iseq = RubyVM::InstructionSequence.compile('puts 1+4')");
	VALUE rbc=eval("$rbc = $iseq.to_a");
	// VALUE rbc=eval("Marshal.load(File.read('out.dump'))");

	p(rbc);
	v=rb_funcall(iseq,id("eval"),0);// YAY!!!
	// p(rb_cISeq);
	pf("-----\n");
	// iseq=rb_iseq_load(rbc,0, Qnil);
	iseq=(VALUE)rb_iseq_load(rbc,rb_cISeq, Qnil);
	// iseq.h:VALUE rb_iseq_load(VALUE data, VALUE parent, VALUE opt);
	pf("+++++\n");
	pf("%lu\n\n",iseq);
	if(iseq)
		p(iseq);
	pf("///////\n");
	// rb_call(VALUE recv, ID mid, int argc, const VALUE *argv, call_type scope)
	v=rb_funcall(iseq,id("eval"),0);
	pf("-----");
	 // eval("puts 'hellou';arr = Marshal.load(File.read('out.dump'));puts arr;puts 'ok1';require 'iseq';puts ISeq;puts 'ok';x=ISeq.load arr;puts x;");
	return v;
}
