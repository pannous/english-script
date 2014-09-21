//#define call rb_funcall // (VALUE recv, ID mid, int argc, ...)
// VALUE obj, id name, int argc, VALUE *argv
#define call(s,p,argc,args) rb_funcall(s,p,argc,args)
#define set_property rb_ivar_set //(VALUE obj, ID id, VALUE val)
#define get_property rb_ivar_get //(VALUE obj, ID id)
#define set(name,value) rb_ivar_set(Object,id(name),value)

// #define eval(x) rb_eval_string_protect(x,&error);
#define eval(x) rb_eval_string(x);
#define p rb_p
#define s(x) rb_str_new2(x)
#define cat(s,x) rb_str_cat2(s,x) //(VALUE str, const char* ptr)
#define id rb_intern //ID rb_intern(const char*)
#define sym(x) ID2SYM(rb_intern(x))//  VALUE ID2SYM(ID id)
//ID SYM2ID(VALUE symbol)
//INT2FIX() :: for integers within 31bits.
//INT2NUM() :: for arbitrary sized integer.  Bignum if > 32bit
// #define s rb_string_value_cstr
#define f rb_float_new
#define i INT2NUM

#define is_nil(obj) NIL_P(obj)
#define is_number(obj) FIXNUM_P(obj)
#define to_str(var) StringValue(var)
#define to_ary(obj) rb_ary_to_ary(obj) //VALUE

#define new_array   rb_ary_new //empty
#define new_array_r rb_ary_new4 //(long n, VALUE *elts)
#define new_array_c rb_ary_new3 //(long n, ...)
//rb_ary_push ... all them funcs!

#define define_class rb_define_class // VALUE rb_define_class(const char *name, VALUE super)
#define define_module rb_define_module //VALUE rb_define_module(const char *name)
#define define_method rb_define_method //void rb_define_method(VALUE klass, const char *name,VALUE (*func)(), int argc)

#define pf printf

#define define_const rb_define_const //  void rb_define_const(VALUE klass, const char *name, VALUE val)
#define define_global_const rb_define_global_const //  void rb_define_global_const(const char *name, VALUE val)
#define define_c_variable rb_define_variable //void rb_define_variable(const char *name, VALUE *var)
#define get_const rb_const_get // (VALUE obj, ID id) vs PROPERTY !?
#define get_global_variable rb_gv_get // ?
//  void rb_define_hooked_variable(const char *name, VALUE *var,VALUE (*getter)(), void (*setter)())
// VALUE (*getter)(ID id, VALUE *var);
// void (*setter)(VALUE val, ID id, VALUE *var);

// DATA Data_Wrap_Struct(klass, mark, free, sval)

#define include_module rb_include_module
//  switch (TYPE(obj)) {
//    case T_FIXNUM:

//rb_define_singleton_method
//  void rb_define_method_id(VALUE klass, ID name, VALUE (*func)(ANYARGS), int argc)
//  void rb_define_module_function(VALUE module, const char *name,VALUE (*func)(), int argc)
//  void rb_define_global_function(const char *name, VALUE (*func)(), int argc)
//rb_add_method(VALUE klass, ID mid, rb_method_type_t type, void *opts, rb_method_flag_t noex)
//void rb_add_method_cfunc(VALUE klass, ID mid, VALUE (*func)(ANYARGS), int argc, rb_method_flag_t noex);
//rb_method_entry_t *rb_add_method(VALUE klass, ID mid, rb_method_type_t type, void *option, rb_method_flag_t noex);
//lookup_method_table(VALUE klass, ID id)
//static inline rb_method_entry_t* search_method(VALUE klass, ID id, VALUE *defined_class_ptr)
//int rb_obj_respond_to(VALUE obj, ID id, int priv)
//int rb_respond_to(VALUE obj, ID id)
//static VALUE obj_respond_to(int argc, VALUE *argv, VALUE obj)

// const char *rb_id2name(ID);
// ID rb_intern(const char*);
// ID rb_intern2(const char*, long);
// ID rb_intern_str(VALUE str);
// ID rb_check_id(volatile VALUE *);
// ID rb_to_id(VALUE);
// VALUE rb_id2str(ID);

#include <ruby.h>
#ifndef MAIN
int error;
VALUE Object;
//#define Object eval("Object")
#define nil Qnil //0
#define false Qfalse //0 // false in C also (i.e. 0).
#define true Qtrue //1

VALUE run(VALUE arg);
VALUE result=nil;
int main ( int argc, char ** argv) 	{
//    ruby_set_debug_option(getenv("RUBY_DEBUG"));
//	ruby_sysinit(&argc, &argv);
//	RUBY_INIT_STACK;
//	ruby_init_loadpath();
//	setbuf(stdout, NULL); // disable buffering
	ruby_init();
	Object=eval("Object");
	result=rb_protect( run, 0, &error);// call our stuff rb_protect'ed
//  result=run(0);
	if(error)perror("ERROR");
	if(result!=0 && result!=nil && result!=false)p(result);
 	ruby_finalize();
 	return 0;
}
#endif
