# coding: interpy "string interpolation #{like ruby}"
# encoding: utf-8
import os
import exceptions

# def print(x # debug!):
#   print x
#   print "\n"
#   x
# import builtins
import __builtin__
import shutil


def put(x):
  print(x)

def grep(xs, x):
  xs.select (lambda y: str(y).match(x) )

def say(x):
  print(x)
  exec("say '#{x}'") #mac only!

def beep():
  print("\aBEEP ")
  exec("say 'beep'")
  'beeped'

class Class:
    pass
  # not def(self):
  #   False

class Method(__builtin__.function):
    pass

class File(os.file):
  # import fileutils

  # str(def)(self):
  #   path
  path=""

  def name(self):
    return self.path

  def filename(self):
    return self.path

  def mv(self,to):
    os.rename(self.path, to)

  def move(self,to):
    os.rename(self.path, to)

  def copy(self,to):
    shutil.copyfile(self.path, to)

  def cp(self,to):
    shutil.copyfile(self.path, to)

  def contain(self,x):
    return self.path.index(x)

  def contains(self,x):
    return self.path.index(self,x)

  def delete(self):
    raise SecurityError("cannot delete files")
    #FileUtils.remove_dir(to_path, True)


class Directory(os.file): #
  # str(def)(self):
  #   path

  @classmethod
  def cd(path):
        os.chdir(path)

  def files(self):
    os.listdir(str(self)) #?

  @classmethod
  def ls(path):
    os.listdir(path)

  @classmethod
  def files(path):
    os.listdir(path)

  def contains(self,x):
    return self.files().has(x)
    #Dir.cd
    #  Dir.glob "*.JPG"
  #
  # import fileutils
  #
  # def remove_leaves(dir=".", matching= ".svn"):
  #   Dir.chdir(dir) do
  #     entries=Dir.entries(Dir.pwd).reject (lambda e: e=="." or e==":" )
  #     if entries.size == 1 and entries.first == matching:
  #       print "Removing #{Dir.pwd}"
  #       FileUtils.rm_rf(Dir.pwd)
  #     else:
  #       entries.each do |e|
  #         if File.directory? e:
  #           remove_leaves(e)




  #
  # def delete(self):
  #   raise SecurityError "cannot delete directories"
    #FileUtils.remove_dir(to_path, True)


# class Number < Numeric
# 
# def not None(self):
#   return True
#
# def None.test(self):
#   "None.test OK"
#
# def None.+ x(self):
#   x

#def None.to_s:
#  ""
#  #"None"
#
class dict:
  # filter ==  x.select{|z|z>1}

  # CAREFUL! MESSES with rails etc!!
  # alias_method :orig_index, :[]


  # Careful hash.map returns an Array, not a map as expected
  # Therefore we need a new method:
  # {a:1,b:2}.map_values{|x|x*3} => {a:3,b:6}


  # if not normed here too!!: DANGER: NOT surjective
  # def []= x,y # NORM only through getter:
  #   super[x.to_sym]=y
  #
  def __index__(self):
    if not x: return
    if isinstance(x,Symbol): return orig_index(x)  or  orig_index(str(x))
    if isinstance(x,str): return orig_index(x)
    # yay! todo: eqls {a:b}=={:a=>b}=={"a"=>b} !!
    orig_index(x)

  def contains(key):
    keys.contains(key)


class Class:
  def wrap(self):
    return str(self) #TODO!?



class list:
  def c(self):
    map(c,self).join(", ") # leave [] which is not compatible with C

  def wrap(self):
    # map(wrap).join(", ") # leave [] which is not compatible with C
    "rb_ary_new3(#{size}/*size*', #{wraps})" #values

  def wraps(self):
    map(wrap).join(", ") # leave [] which is not compatible with C

  def values(self):
    map(value).join(", ") # leave [] which is not compatible with C

  def contains_a(type):
      for a in self:
          if isinstance(a,Numeric): return True
      return False

  def drop(self,x):
    reject(x)

  def to_s(self):
    self.join(", ")

  # ifdef $auto_map:
  def method_missing(method, *args, block):
    if args.count==0: return self.map (lambda x: x.send(method ))
    if args.count>0: return self.map (lambda x: x.send(method, args) )
    # super method, *args, block

  # def matches(item):
  #   contains item
  #
  # remove: confusing!!
  def matches(regex):
    for i in self.flatten:
      m=regex.match(i.gsub(r'([^\w])', "\\\\\\1")) #escape_token(i))
      if m:
        return m
    return False

  def And(x):
    if not isinstance(x,list): self+[x]
    self+x

  def plus(x):
    if not isinstance(x,list): self+[x]
    self+x

  #EVIL!!
  # not def(self):
  #   None? not or

  #def = x  unexpected '=':
  #  is x
  #
  #def grep(x):
  #  select{|y|y.to_s.match(x)}
  #
  def names(self):
     map(to_s)

  def rest(self):
    self[1:-1] # last:-1 after index!!!

  def fix_int(i):
    if str(i)=="middle": i=count/2
    if isinstance(i,Numeric): return i-1
    i=str(i).replace_numerals.to_i
    i-1

  def character(nr):
    item( nr)

  def item(nr): # -1 AppleScript style !!! BUT list[0] !!!
    self[fix_int(nr)]

  def word(nr): # -1 AppleScript style !!! BUT list[0] !!!):
    self[fix_int(nr)]

  def invert(self):
    reverse

  def get(x):
    self[index(x)]

  def row(n):
    at(n)

  def has(x):
    index(x)

  def contains(x):
    ok=index(x)
    if ok : return at(index(x))
    else: return False

  #def to_s:
  #  "["+join(", ")+"]"
  #
# class TrueClass:
#   not def(self):
#     False


class FalseClass:
  # not def(self):
  #   True

  def wrap(self):
    self

  def c(self):
    self


class str:

  def c(self):
    quoted

  def quoted(self):
    "\"#{self}\""

  def id(self):
    "id(\"#{self}\")"

  def wrap(self):
    "s(\"#{self}\")"

  def value(self):
    self  # variable
    # quoted

  def name(self):
    self

  def number(self):
    int(self)

  def _in(ary):
    ary.has(self)

  def matches(regex):
    if isinstance(regex,list):
        for x in regex:
            if match(x):
                return x
    else:
      return match(regex)
    return False

  def stripNewline(self):
    strip.sub(r';$', '')

  def join(x):
    self

  # def < x:
  #   i=x.is_a?Numeric
  #   if i:
  #     return int(self)<x
  #
  #   super.< x
  #
  def starts_with(self,x):
    # puts "WARNING: start_with? missspelled as starts_with?"
    if isinstance(x,list):
        for y in list:
            if startswith(y):return y
    return startswith(x)

  def show(x=None):
    print(x or self)
    return x or self

  def contains(*things):
    for t in things.flatten:
      if index(t): return True

    return False

  def fix_int(i):
    if str(i)=="middle": i=count/2
    if isinstance(i,Numeric): return i-1
    i=str(i).replace_numerals.to_i #if i.is_a? String:
    i-1

  def sentence(i):
    i=fix_int( i)
    split(r'[\.\?\!\;]')[i]

  def paragraph(i):
    i=fix_int( i)
    split("\n")[i]

  def word(i):
    i=fix_int( i)
    split(" ")[i]

  def item(i):
    word(i)

  def char(i):
    character(i)

  def character(i):
    i=fix_int(i)
    self[i-1:i]

  def flip(self):
    split(" ").reverse.join(" ")

  def invert(self):
    reverse

  def plus(x):
    self+x

  def _and(x):
    self+x

  def add(x):
    self+x

  def offset(x):
    index (x)

  def __sub__(self,x):
    self.gsub(x,"")
    # self[0:self.index(x)-1]+self[self.index(x)+x.length:-1]

  def synsets(param):
    pass


  def is_noun(self):# expensive!!!):
    # Sequel::InvalidOperation Invalid argument used for IS operator
    return synsets('noun') or self.gsub(r's$', "").synsets('noun') # except False

  def is_verb(self):
    return synsets('verb') or self.gsub(r's$', "").synsets('verb')

  def is_a(className):
    className=className.lower()
    if className=="quote": return True
    return className=="string"

  def is_adverb(self):
    return synsets('adverb')

  def is_adjective(self):
    return synsets('adjective')

  def examples(self):
    return synsets.flatten.map('hyponyms').flatten().map('words').flatten.uniq.map('to_s')

  # def not_(self):
  #   return None or not
  def lowercase(self):
    return self.lower()

  def replace(param, param1, self):
    pass

  def shift(n=1):
        n.times(self=self.replace(r'^.',""))
        # self[n:-1]

  def replace_numerals(self):
    x=self
    x=x.replace(r'([a-z])-([a-z])', "\\1+\\2") # WHOOOT???
    # x=x.replace("last", "-1") # index trick
    x=x.replace("last", "0") # index trick
    x=x.replace("first", "1") # index trick

    x=x.replace("tenth", "10")
    x=x.replace("ninth", "9")
    x=x.replace("eighth", "8")
    x=x.replace("seventh", "7")
    x=x.replace("sixth", "6")
    x=x.replace("fifth", "5")
    x=x.replace("fourth", "4")
    x=x.replace("third", "3")
    x=x.replace("second", "2")
    x=x.replace("first", "1")
    x=x.replace("zero", "0")

    x=x.replace("4th", "4")
    x=x.replace("3rd", "3")
    x=x.replace("2nd", "2")
    x=x.replace("1st", "1")
    x=x.replace("(\d+)th", "\\1")
    x=x.replace("(\d+)rd", "\\1")
    x=x.replace("(\d+)nd", "\\1")
    x=x.replace("(\d+)st", "\\1")

    x=x.replace("a couple of", "2")
    x=x.replace("a dozen", "12")
    x=x.replace("ten", "10")
    x=x.replace("twenty", "20")
    x=x.replace("thirty", "30")
    x=x.replace("forty", "40")
    x=x.replace("fifty", "50")
    x=x.replace("sixty", "60")
    x=x.replace("seventy", "70")
    x=x.replace("eighty", "80")
    x=x.replace("ninety", "90")

    x=x.replace("ten", "10")
    x=x.replace("eleven", "11")
    x=x.replace("twelve", "12")
    x=x.replace("thirteen", "13")
    x=x.replace("fourteen", "14")
    x=x.replace("fifteen", "15")
    x=x.replace("sixteen", "16")
    x=x.replace("seventeen", "17")
    x=x.replace("eighteen", "18")
    x=x.replace("nineteen", "19")

    x=x.replace("ten", "10")
    x=x.replace("nine", "9")
    x=x.replace("eight", "8")
    x=x.replace("seven", "7")
    x=x.replace("six", "6")
    x=x.replace("five", "5")
    x=x.replace("four", "4")
    x=x.replace("three", "3")
    x=x.replace("two", "2")
    x=x.replace("one", "1")
    x=x.replace("dozen", "12")
    x=x.replace("couple", "2")

    x=x.replace("½", "+1/2.0");
    x=x.replace("⅓", "+1/3.0");
    x=x.replace("⅔", "+2/3.0");
    x=x.replace("¼", "+1/4.0");
    x=x.replace("¾", "+3/4.0");
    x=x.replace("⅕", "+1/5.0");
    x=x.replace("⅖", "+2/5.0");
    x=x.replace("⅗", "+3/5.0");
    x=x.replace("⅘", "+4/5.0");
    x=x.replace("⅙", "+1/6.0");
    x=x.replace("⅚", "+5/6.0");
    x=x.replace("⅛", "+1/8.0");
    x=x.replace("⅜", "+3/8.0");
    x=x.replace("⅝", "+5/8.0");
    x=x.replace("⅞", "+7/8.0");


    x=x.replace(" hundred thousand", " 100000")
    x=x.replace(" hundred", " 100")
    x=x.replace(" thousand", " 1000")
    x=x.replace(" million", " 1000000")
    x=x.replace(" billion", " 1000000000")
    x=x.replace("hundred thousand", "*100000")
    x=x.replace("hundred ", "*100")
    x=x.replace("thousand ", "*1000")
    x=x.replace("million ", "*1000000")
    x=x.replace("billion ", "*1000000000")
    self

  def parse_integer(self):
    self=self.replace_numerals
    i=eval(self).to_i # except 666
    i

  def parse_number(self):
    self=self.replace_numerals
    eval(self).to_f

#class Fixnum Float
class Numeric:
  def c(self): #unwrap, for optimization):
    return str(self) #"NUM2INT(#{self.to_s})"

  def value(self):
    self

  def wrap(self):
    "INT2NUM(#{self.to_s})"

  def number(self):
    self

  def _and(x):
    self+x

  def plus(x):
    self+x

  def minus(x):
    self-x

  def times(x):
    self*x

  def less(self,x):
    if isinstance(x,str): return self<int(x)
    super.__lt__(x)

  def is_blank(self):
    return False

  def is_a(clazz):
    className=str(clazz).lower()
    if className=="number": return True
    if className=="real": return True
    if className=="float": return True
    # int = ALL : Fixnum = small int  AND :. Bignum = big : 2 ** (1.size * 8 - 2)
    if isinstance(self,int) and className=="integer": return True #todo move
    if isinstance(self,int) and className=="int" : return True
    if className==str(self).lower() : return True#KINDA
    if self.isa(clazz): return True
    return False

  def add(x):
    self+x

  def increase(by=1):
    self+by # Can't change the value of numeric self!!

  def decrease(by=1):
    self-by # Can't change the value of numeric self!!

  def bigger(self,x):
    self>x

  def smaller(self,x):
    self<x

  def to_the_power_of(x):
    self**x

  def to_the(x):
    self**x

  def logarithm(self):
    Math.log( self)

  def e(self):
    Math.exp (self)

  def exponential(self):
    Math.exp (self)

  def sine(self):
    Math.sin (self)

  def cosine(self):
    Math.cos (self)

  def root(self):
    Math.sqrt( self)

  def power(x):
    self**x

  def square(self):
    self*self

  # todo: use ^^
  def squared(self):
    self*self


#if self==false: return True
#if self==True: return false
# class Enumerator

class Object:
  def value(self):
    self

  def number(self):
    False

  # not def(self):
  #   False

  def throw(self, x):
    raise x

  def type(self):
    self.__class__

  def kind(self):
    self.__class__

  def log(*x):
    print( x)

  def debug(*x):
    print(x)

  def is_a(self,clazz):
    if self is clazz: return True
    try:
      ok=isinstance(self,clazz)
      if ok: return True
    except Exception as e:
      print(e)

    className = str(clazz).lower()
    if className==str(self).lower(): return True#KINDA

    if self.is_(clazz): return True
    return False

  def is_(self,x):
    if not x and not self: return True
    if x==self: return True
    if x is self: return True
    if str(x).lower()==str(self).lower(): return True#KINDA
    if isinstance(self,list) and self.length==1 and x.is_(self[0]): return True
    if isinstance(x,list) and x.length==1 and self.is_(x[0]):  return True
    return False