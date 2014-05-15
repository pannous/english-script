def grep xs, x
  xs.select { |y| y.to_s.match(x) }
end

def say x
  puts x
  system "say '#{x}'" #mac only!
end

def beep
  print "\aBEEP "
  system "say 'beep'"
  'beeped'
end


class Class
  def blank?
    false
  end
end

class File
  def to_s
    path
  end

  def move to
    require 'fileutils'
    FileUtils.mv(path, to)
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
end

class Dir
  def to_s
    path
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

#def nil.to_s
#  ""
#  #"nil"
#end


class Hash
  def contains key
    keys.contains key
  end
end

class Array

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
    self+[x] if not x.is_a?Array
    self+x
  end

  def plus x
    self+[x] if not x.is_a?Array
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

  def fix_int i
    i=count/2 if i.to_s=="middle"
    return i-1 if i.is_a? Numeric
    i=i.to_s.replace_numerals!.to_i
    i-1
  end

  def character nr
    item nr
  end

  def item nr
    self[fix_int nr]
  end

  def word nr
    self[fix_int nr]
  end

  def invert
    reverse
  end

  def get x
    self[index x]
  end

  def contains x
    index x
  end
  #
  #def method_missing method, *args, &block
  #  return self.map{|x| x.send method} if args.count==0
  #  return self.map{|x| x.send(method,args)} if args.count>0
  #  super method, *args, &block
  #end

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
end

class String

  def matches regex
    match regex
  end

  def stripNewline
    strip.sub(/;$/,'')
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
    return start_with? x
  end

  def show x=nil
    puts self
    puts x if x
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

  def - x
    self[0..self.index(x)-1]+self[self.index(x)+x.length..-1]
  end

  def is_noun
    not synsets(:noun).empty? or
        not self.gsub(/s$/, "").synsets(:noun).empty?
  end

  def is_verb
    not synsets(:verb).empty? of
    not self.gsub(/s$/, "").synsets(:verb).empty?
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

  def replace_numerals!

    gsub!(/([a-z])-([a-z])/, "\\1+\\2")# WHOOOT???
    gsub!("last", "0") # index trick

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
    eval(self).to_i
  end

end


#class Fixnum Float
class Numeric

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
    return self<x.to_i if x.is_a?String
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
    return true if self.is_a? Integer and className=="integer" #todo move
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

  def squared
    self*self
  end
end

#return true if self==false
#return false if self==true
# class Enumerator

class Object

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

