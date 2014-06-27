#define eval(x) rb_eval_string_protect(x,&error);
#define p rb_p
#define s(x) rb_str_new2(x)
#define id rb_intern
#define sym(x) ID2SYM(rb_intern(x))
#define global_variable rb_gv_get
#define pf printf


// #define eval rb_eval_string


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
