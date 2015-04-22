ANNOTATIONS: RUBY 'NO'
# http://stackoverflow.com/questions/3157426/how-to-simulate-java-like-annotations-in-ruby/3157550#3157550
PYTHON: 
# https://www.python.org/dev/peps/pep-0484/ PYTHON 3 ONLY!!
# def haul(item: Haulable, *vargs: PackAnimal) -> Distance:
#   bla
# https://www.python.org/dev/peps/pep-0318/ OLD! : decorators  WarningWarningWarning  lol
JAVASCRIPT:
NOT SOON ECMA7 maybe http://wiki.ecmascript.org/doku.php?id=strawman%3aguards

Parrot is a virtual machine designed to efficiently compile and execute bytecode for dynamic languages. Parrot currently hosts a variety of language implementations in various stages of completion, including Tcl, Javascript, Ruby, Lua, Scheme, PHP, Python, Perl 6, APL, and a .NET bytecode translator. Parrot is not about parrots, though we are rather fond of them for obvious reasons.

# python attributes:: nice but dangerous!!
not in ruby:
[2] pry(main)> x=lambda{|z| z+1}
=> #<Proc:0x00000101147998@(pry):2 (lambda)>
[10] pry(main)> x(3)
# undefined method `x' !!
[9] pry(main)> x[3]
=> 4  # WOOT!! call with []!!!
[3] pry(main)> x.h=8
# NoMethodError: undefined method `h='
=> "call [] yield to_proc arity lambda? binding curry source_location parameters source comment"
source comment ;)

# Jython doesn't compile to bytecode the same way Java does. The bytecode does all the wonderful dynamic runtime things that CPython does, so is considerably slower than Java.
PyObject pyobject1 = Py.makeClass("AddressValueError", apyobject, AddressValueError$1);
pyframe.setlocal("AddressValueError", pyobject1);
pyobject1 = null;
Arrays.fill(apyobject, null);
pyframe.setline(37);
apyobject = new PyObject[1];
pyframe.getname("ValueError");
apyobject;
JVM INSTR swap ;
0;

#
# ParseTree is dead on ruby 1.9 and there is no plan to make it work.
#
# Because of changes to internals in 1.9, ParseTree simply can not work. I asked for hooks/options to allow us to get to the information but they never arrived.
#
# Specifically if you’re using ParseTree to access the AST of a live method/block/proc, you’re SOL. If you’re just using ParseTree to do static analysis, then you can switch to ruby_parser in about a minute of work and you’re good to go.

# NAH: https://github.com/seattlerb/rubyinline

# once you exercise the most powerful features of Ruby you understand that Python is just no match. For an example try to write a DSL in Ruby vs writing one Python, or creating function, methods, classes, etc. at run-time. It's much more straight-forward in Ruby. –  felipec Feb 15 '10 at 22:01

# You're pretty much out of luck if you want to do symbolic maths in Ruby. However, the excellent sympy project is a fully featured computer algebra system (that can perform derivatives, among other things) for Python.
# POSSIBLE but not done: http://brainopia.github.io/symbolic/ https://github.com/brainopia/symbolic

# http://www.norvig.com/python-lisp.html

#hello                           Symbol
#(make-hash-table)               Hashtable/Dictionary
#(lambda (x) (+ x x))            Function
#(defclass stack ...)            Class
#(make 'stack)                   Instance
#(open "file")                   Stream
#t, nil                          Boolean
#(), #() linked list, array      Empty Sequence
#nil                             Missing Value
#(1 2.0 "three")                 Lisp List (linked) == tupel
#(make-arrary 3 :adjustable t    Python List (adjustable array)
#  :initial-contents '(1 2 3))   Symbol
#Many (in core language)         Hashtable/Dictionary

False, None, 0, '', [ ], {} are all false
(if x y z)
(loop while (test) do (f))                    
(dotimes (i n) (f i))                         for i in range(n): f(i)
(loop for x in s do (f x))                    for x in s: f(x) ## works on any sequence
(loop for (name addr salary) in db do ...)    for (name, addr, salary) in db: ...
  (setq x y)
  (psetq x 1 y 2)
  (rotatef x y)
  (setf (slot x) y)
  (values 1 2 3) on stack
  (multiple-value-setq (x y) (values 1 2))
  == (let [x 1 y 2])











