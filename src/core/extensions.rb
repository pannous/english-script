# encoding: utf-8

# def puts x # debug!
#   print x
#   print "\n"
#   x
# end

def put x
  print x
end

def grep xs, x
  xs.select { |y| y.to_s.match(x) }
end

def say x
  puts x
  system "say '#{x}'" rescue nil #mac only!
end

def beep
  print "\aBEEP "
  system "say 'beep'" rescue nil if not $testing
  'beeped'
end


class Class
  def blank?
    false
  end
end

class File
  require 'fileutils'

  def to_s
    path
  end

  def name
    path
  end
  def filename
    path
  end

  def mv to
    FileUtils.mv(path, to)
  end

  def move to
    FileUtils.mv(path, to)
  end

  def copy to
    FileUtils.cp(path, to)
  end

  def cp to
    FileUtils.cp(path, to)
  end

  def contain x
    path.index(x)
  end

  def contains x
    path.index(x)
  end

  def delete
    raise SecurityError "cannot delete files"
    #FileUtils.remove_dir(to_path, true)
  end

  def self.list(dir)
    Dir.entries(dir)-['.','..']
  end

  def self.ls(dir)
    Dir.entries(dir)-['.','..']
  end

end

class Dir
  def to_s
    path
  end

  def self.list(dir)
    Dir.entries(dir)-['.','..']
  end

  def self.ls(dir)
    Dir.entries(dir)-['.','..']
  end

  def list
    entries(self)
  end

  def ls
    entries(self)
  end

  def files
    to_a
  end

  def contains x
    select { |f| f == x }
    #Dir.cd
    #  Dir.glob "*.JPG"
  end

  require 'fileutils'

  def remove_leaves(dir=".", matching= ".svn")
    Dir.chdir(dir) do
      entries=Dir.entries(Dir.pwd).reject { |e| e=="." or e==".." }
      if entries.size == 1 and entries.first == matching
        puts "Removing #{Dir.pwd}"
        FileUtils.rm_rf(Dir.pwd)
      else
        entries.each do |e|
          if File.directory? e
            remove_leaves(e)
          end
        end
      end
    end
  end

  def delete
    raise SecurityError "cannot delete directories"
    #FileUtils.remove_dir(to_path, true)
  end
end


# class Number < Numeric
# end

def nil.blank?
  return true
end

def nil.test
  "nil.test OK"
end

def nil.+ x
  x
end

#def nil.to_s
#  ""
#  #"nil"
#end


class Hash
  # filter ==  x.select{|z|z>1}

  # CAREFUL! MESSES with rails etc!!
  alias_method :orig_index, :[]


  # Careful hash.map returns an Array, not a map as expected
  # Therefore we need a new method:
  # {a:1,b:2}.map_values{|x|x*3} => {a:3,b:6}
  def map_values
    self.inject({}) do |newhash, (k,v)|
      newhash[k] = yield(v)
      newhash
    end
  end


  # DANGER: NOT surjective if not normed here too!!
  # def []= x,y # NORM only through getter
  #   super[x.to_sym]=y
  # end

  def [] x
    return if not x
    return orig_index(x) || orig_index(x.to_s) if x.is_a? Symbol
    return orig_index(x) || orig_index(x.to_sym) if x.is_a? String
    # yay! todo: eqls {a:b}=={:a=>b}=={"a"=>b} !!
    orig_index(x)
  end

  def contains key
    keys.contains key
  end
end

class Class
  def wrap
    return self.to_s #TODO!?
  end
end

class Array
  def c
    map(&:c).join(", ") # leave [] which is not compatible with C
  end

  def wrap
    # map(&:wrap).join(", ") # leave [] which is not compatible with C
    "rb_ary_new3(#{size}/*size*/, #{wraps})" #values
  end

  def wraps
    map(&:wrap).join(", ") # leave [] which is not compatible with C
  end

  def values
    map(&:value).join(", ") # leave [] which is not compatible with C
  end

  def contains_a type
    each{|x| return true if x.is_a?type }
    false
  end

  def drop! x
    reject! x
  end

  def to_str
    self.join(", ")
  end

  # ifdef $auto_map
  def method_missing method, *args, &block
    return self.map { |x| x.send method } if args.count==0
    return self.map { |x| x.send(method, args) } if args.count>0
    super method, *args, &block
  end

  # def matches item
  #   contains item
  # end

  # remove: confusing!!
  def matches regex
    for i in self.flatten
      m=regex.match(i.gsub(/([^\w])/, "\\\\\\1")) #escape_token(i))
      if m
        return m
      end
    end
    return false
  end

  def and x
    self+[x] if not x.is_a? Array
    self+x
  end

  def plus x
    self+[x] if not x.is_a? Array
    self+x
  end

  #EVIL!!
  def blank?
    nil? or empty?
  end

  #def = x  unexpected '='
  #  is x
  #end
  #def grep x
  #  select{|y|y.to_s.match(x)}
  #end
  def names
    map &:to_s
  end

  def rest
    self[1..-1] # last..-1 after index!!!
  end

  def fix_int i
    i=count/2 if i.to_s=="middle"
    return i-1 if i.is_a? Numeric
    i=i.to_s.replace_numerals!.to_i
    i-1
  end

  def character nr
    item nr
  end

  def item nr # -1 AppleScript style !!! BUT list[0] !!!
    self[fix_int nr]
  end

  def word nr # -1 AppleScript style !!! BUT list[0] !!!
    self[fix_int nr]
  end

  def invert
    reverse
  end

  def get x
    self[index x]
  end

  def row n
    at n
  end

  def has x
    index x
  end

  def contains x
    ok=index(x)
    ok ? at(index x) : false
  end

  #def to_s
  #  "["+join(", ")+"]"
  #end

end

class TrueClass
  def blank?
    false
  end
end

class FalseClass
  def blank?
    true
  end
  def wrap
    self
  end
  def c
    self
  end
end

class String

  def fix_encoding
    require 'iconv' unless String.method_defined?(:encode)
    if String.method_defined?(:encode)
      return self.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    else
      ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
      return ic.iconv(self)
    end
  end

  def c
    quoted
  end

  def quoted
    "\"#{self}\""
  end

  def id
    "id(\"#{self}\")"
  end

  def wrap
    "s(\"#{self}\")"
  end

  def value
    self  # variable
    # quoted
  end

  def name
    self
  end

  def number
    self.to_i
  end

  def in ary
    ary.has(self)
  end

  def matches regex
    if regex.is_a? Array
      regex.each { |x| z=match x;
      if z
        return x
      end
      }
    else
      match regex
    end
    return false
  end

  def stripNewline
    strip.sub(/;$/, '')
  end

  def join x
    self
  end

  # def < x
  #   i=x.is_a?Numeric
  #   if i
  #     return self.to_i<x
  #   end
  #   super.< x
  # end

  def starts_with? x
    # puts "WARNING: start_with? missspelled as starts_with?"
    if x.is_a?Array
      x.each{|y| return y if start_with? y}
    end
    return start_with? x
  end

  def show x=nil
    puts x||self
    return x||self
  end

  def contains *things
    for t in things.flatten
      return true if index(t)
    end
    return false
  end

  def fix_int i
    i=count/2 if i.to_s=="middle"
    return i-1 if i.is_a? Numeric
    i=i.to_s.replace_numerals!.to_i #if i.is_a? String
    i-1
  end

  def sentence i
    i=fix_int i
    split(/[\.\?\!\;]/)[i]
  end

  def paragraph i
    i=fix_int i
    split("\n")[i]
  end

  def word i
    i=fix_int i
    split(" ")[i]
  end

  def item i
    word i
  end

  def char i
    character i
  end

  def character i
    i=fix_int i
    self[i-1..i]
  end

  def flip
    split(" ").reverse.join(" ")
  end

  def invert
    reverse
  end

  def plus x
    self+x
  end

  def and x
    self+x
  end

  def add x
    self+x
  end

  def offset x
    index x
  end

  def - x
    self.gsub(x,"")
    # self[0..self.index(x)-1]+self[self.index(x)+x.length..-1]
  end

  def is_noun # expensive!!!
    # Sequel::InvalidOperation Invalid argument used for IS operator
    not synsets(:noun).empty? or
        not self.gsub(/s$/, "").synsets(:noun).empty? rescue false
  end

  def is_verb
    not synsets(:verb).empty? of
    not self.gsub(/s$/, "").synsets(:verb).empty?
  end

  def is_a className
    className.downcase!
    return true if className=="quote"
    return className=="string"
  end

  def is_adverb
    not synsets(:adverb).empty?
  end

  def is_adjective
    not synsets(:adjective).empty?
  end

  def examples
    synsets.flatten.map(&:hyponyms).flatten.map(&:words).flatten.uniq.map &:to_s
  end

  def blank?
    nil? or empty?
  end

  def lowercase
    downcase
  end

  def lowercase!
    downcase!
  end

  def shift n=1
    n.times{self.gsub!(/^./,"")}
    # self[n..-1]
  end

  def replace_numerals!

    gsub!(/([a-z])-([a-z])/, "\\1+\\2") # WHOOOT???
    # gsub!("last", "-1") # index trick
    gsub!("last", "0") # index trick
    gsub!("first", "1") # index trick

    gsub!("tenth", "10")
    gsub!("ninth", "9")
    gsub!("eighth", "8")
    gsub!("seventh", "7")
    gsub!("sixth", "6")
    gsub!("fifth", "5")
    gsub!("fourth", "4")
    gsub!("third", "3")
    gsub!("second", "2")
    gsub!("first", "1")
    gsub!("zero", "0")

    gsub!("4th", "4")
    gsub!("3rd", "3")
    gsub!("2nd", "2")
    gsub!("1st", "1")
    gsub!("(\d+)th", "\\1")
    gsub!("(\d+)rd", "\\1")
    gsub!("(\d+)nd", "\\1")
    gsub!("(\d+)st", "\\1")

    gsub!("a couple of", "2")
    gsub!("a dozen", "12")
    gsub!("ten", "10")
    gsub!("twenty", "20")
    gsub!("thirty", "30")
    gsub!("forty", "40")
    gsub!("fifty", "50")
    gsub!("sixty", "60")
    gsub!("seventy", "70")
    gsub!("eighty", "80")
    gsub!("ninety", "90")

    gsub!("ten", "10")
    gsub!("eleven", "11")
    gsub!("twelve", "12")
    gsub!("thirteen", "13")
    gsub!("fourteen", "14")
    gsub!("fifteen", "15")
    gsub!("sixteen", "16")
    gsub!("seventeen", "17")
    gsub!("eighteen", "18")
    gsub!("nineteen", "19")

    gsub!("ten", "10")
    gsub!("nine", "9")
    gsub!("eight", "8")
    gsub!("seven", "7")
    gsub!("six", "6")
    gsub!("five", "5")
    gsub!("four", "4")
    gsub!("three", "3")
    gsub!("two", "2")
    gsub!("one", "1")
    gsub!("dozen", "12")
    gsub!("couple", "2")

    gsub!("½", "+1/2.0");
    gsub!("⅓", "+1/3.0");
    gsub!("⅔", "+2/3.0");
    gsub!("¼", "+1/4.0");
    gsub!("¾", "+3/4.0");
    gsub!("⅕", "+1/5.0");
    gsub!("⅖", "+2/5.0");
    gsub!("⅗", "+3/5.0");
    gsub!("⅘", "+4/5.0");
    gsub!("⅙", "+1/6.0");
    gsub!("⅚", "+5/6.0");
    gsub!("⅛", "+1/8.0");
    gsub!("⅜", "+3/8.0");
    gsub!("⅝", "+5/8.0");
    gsub!("⅞", "+7/8.0");


    gsub!(" hundred thousand", " 100000")
    gsub!(" hundred", " 100")
    gsub!(" thousand", " 1000")
    gsub!(" million", " 1000000")
    gsub!(" billion", " 1000000000")
    gsub!("hundred thousand", "*100000")
    gsub!("hundred ", "*100")
    gsub!("thousand ", "*1000")
    gsub!("million ", "*1000000")
    gsub!("billion ", "*1000000000")
    self
  end


  def parse_integer
    replace_numerals!
    i=eval(self).to_i # rescue 666
    i
  end

  def parse_number
    replace_numerals!
    eval(self).to_f
  end

end


#class Fixnum Float
class Numeric
  def c #unwrap, for optimization
    self.to_s #"NUM2INT(#{self.to_s})"
  end

  def value
    self
  end

  def wrap
    "INT2NUM(#{self.to_s})"
  end

  def number
    self
  end

  def and x
    self+x
  end

  def plus x
    self+x
  end

  def minus x
    self-x
  end

  def times x
    self*x
  end

  def < x
    return self<x.to_i if x.is_a? String
    super.< x
  end

  def blank?
    return false
  end

  def is_a clazz
    className=clazz.to_s.downcase
    return true if className=="number"
    return true if className=="real"
    return true if className=="float"
    # Integer = ALL : Fixnum = small int  AND ... Bignum = big : 2 ** (1.size * 8 - 2)
    return true if self.is_a? Integer and className=="integer" #todo move
    return true if self.is_a? Integer and className=="int" #todo move
    return true if className==self.to_s.downcase #KINDA
    return true if self.is clazz
    return false
  end

  def add x
    self+x
  end

  def increase by=1
    self+by # Can't change the value of numeric self!!
  end

  def decrease by=1
    self-by # Can't change the value of numeric self!!
  end

  def bigger? x
    self>x
  end

  def smaller? x
    self<x
  end


  def to_the_power_of x
    self**x
  end

  def to_the x
    self**x
  end

  def logarithm
    Math.log self
  end

  def e
    Math.exp self
  end

  def exponential
    Math.exp self
  end

  def sine
    Math.sin self
  end

  def cosine
    Math.cos self
  end

  def root
    Math.sqrt self
  end

  def power x
    self**x
  end

  def square
    self*self
  end

  # todo: use ^^
  def squared
    self*self
  end
end

#return true if self==false
#return false if self==true
# class Enumerator

class Object

  def class_name
    self.class.name.split('::').last || ''
  end

  def short_name
    self.class.name.split('::').last || ''
  end

  def name
    to_s
  end


  def value
    self
  end

  def number
    false
  end

  def blank?
    false
  end

  def self.throw x
    raise x
  end

  def type
    self.class
  end

  def kind
    self.class
  end

  def log *x
    puts x
  end

  def debug *x
    puts x
  end

  def is_a clazz
    className = clazz.to_s.downcase
    begin
      ok=self.is_a? clazz
      return true if ok
    rescue
      puts $!
    end
    return true if className==self.to_s.downcase #KINDA
    return true if self.is clazz
    return false
  end

  def is x
    return true if x.blank? and self.blank?
    return true if x==self
    return true if x===self
    return true if x.to_s.downcase==self.to_s.downcase #KINDA
    return true if x.is self[0] if self.is_a? Array and self.length==1
    return true if self.is x[0] if x.is_a? Array and x.length==1
    return false
  end

end

