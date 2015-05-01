#include <ruby.h>
#include <stdio.h>
#include <stdlib.h>
//void *(*malloc_dummy)(size_t);
//void *malloc(size_t);
//#ifndef MAAAA:
//#define MAAAA
//void *(*malloc_dummy)(size_t) = malloc;
//#endif
// USE and KEEP #define's to emit to other VMs!!! (eg mruby, jruby, ...)

// VALUE obj, id name, int argc, VALUE *argv
#define call(s,p,argc,args) rb_funcall(s,p,argc,args)
#define call0(s,p) rb_funcall(s,p,0)
#define set(name,value) rb_ivar_set(context,id(name),value)
//#define get(name) rb_ivar_get(context,id(name))
VALUE get(char* name);
#define set_property rb_ivar_set //(VALUE obj, ID id, VALUE val)
#define get_property rb_ivar_get //(VALUE obj, ID id)
#define eval(x) rb_eval_string_protect(x,&error);
//#define eval(x) rb_eval_string(x);
//void pi(int i){printf("%d",i);}
//void pf(char* x){printf("%s",x);}
void p(VALUE x);
VALUE s(char* str);
//#define puts(x) rb_p(s(x))
//#define p safe_print //rb_p
//#define s(x) rb_str_new2(x)
#define cat(s,x) rb_str_cat2(s,x) //(VALUE str, const char* ptr)
#define id rb_intern //ID rb_intern(const char*)
#define sym(x) ID2SYM(rb_intern(x))//  VALUE ID2SYM(ID id)
//ID SYM2ID(VALUE symbol)
//INT2FIX() :: for integers within 31bits.
//if > 32bit: INT2NUM() :: for arbitrary sized integer.  Bignum
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
#define define_class rb_define_class //VALUE rb_define_module(const char *name)
#define define_method rb_define_method //void rb_define_method(VALUE klass, const char *name,VALUE (*func)(), int argc)
//#define RUBY_METHOD_FUNC(func) ((VALUE (*)(ANYARGS))(func))

#define pf printf

#define define_const rb_define_const //  void rb_define_const(VALUE klass, const char *name, VALUE val)
#define define_global_const rb_define_global_const //  void rb_define_global_const(const char *name, VALUE val)
#define define_c_variable rb_define_variable //void rb_define_variable(const char *name, VALUE *var)
#define get_const rb_const_get // (VALUE obj, ID id) vs PROPERTY !?
#define get_global_variable rb_gv_get // ?
//  void rb_define_hooked_variable(const char *name, VALUE *var,VALUE (*getter)(), void (*setter)())
// VALUE (*getter)(ID id, VALUE *var);
// void (*setter)(VALUE val, ID id, VALUE *var);

//#define require(x) rb_require_safe(rb_str_new2(x),3) // 3==MAX !
#define require(x) rb_require(x)
// DATA Data_Wrap_Struct(klass, mark, free, sval)

#define include_class rb_include_module

//  switch (TYPE(obj)) {
//    case T_FIXNUM:

VALUE run(VALUE arg);
int error;
VALUE Object;
//#define Object eval("Object")
#define None Qnil //0
#define false Qfalse //0 // false in C also (i.e. 0).
#define True Qtrue //1

VALUE result;
VALUE context;

VALUE error_handler(VALUE e);
int main ( int argc, char ** argv);
