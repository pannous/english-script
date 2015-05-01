// Wrapper for ruby bytecode apps
// INIT RUBY RUNTIME,
// LOAD+EVAL AOT compiled InstructionSequence
// test compile:
// gcc -I/System/Library/Frameworks/Ruby.framework/Versions/2.0/Headers -lruby ruby_wrapper.c -o main
// killall main || gcc -Iruby -I$RUBY_DEV_HOME/include -I$RUBY_DEV_HOME/.ext/include/x86_64-darwin13.2.0/ -lruby ruby_wrapper.c -o main && ./main &

#define MAIN
#include <stdio.h>
#include <stdlib.h>
#include <ruby.h>
#include "vm_debug.h"
#include "helpers.c"
// #include <value.h>
// #include <node.h>
// #include <iseq.h>


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
)
VALUE test_iseq(VALUE arg)
{
	VALUE v;
	// rb_require("rubygems");
	// rb_protect( (VALUE (*)(VALUE))rb_require, (VALUE) "iseq", &error);
	// perror("import iseq");
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
	 // eval("puts 'hellou';arr = Marshal.load(File.read('out.dump'));puts arr;puts 'ok1';import iseq';puts ISeq;puts 'ok;x=ISeq.load arr;puts x;");
	return v;
)