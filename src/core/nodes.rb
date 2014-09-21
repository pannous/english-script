
class Quote < String
  def is_a className
    return is_a?className if className.is_a?Class
    className.downcase! if className.is_a?String
    return true if className=="quote"
    return className=="string"
  end

  def self.is x
    return true if x.to_s.downcase=="string"
    return true if x.to_s.downcase=="quote"
    false
  end

  # todont!!
  def self.== x
    # true if x.name==String
    return true if x.to_s=="String"
    return true if x.to_s=="Quote"
    false
  end

  def value
    quoted
  end

end

class Function
  attr_accessor :name, :arguments, :return_type, :scope, :module, :clazz, :object, :body

  def initialize args
    self.name     =args[:name]
    self.body     =args[:body]
    self.scope    =args[:scope]
    self.clazz    =args[:class]
    self.module   =args[:module]
    self.object   =args[:object]
    self.arguments=args[:arguments]
    # scope.variables[name]=self
  end

  def == x
    return false if not x.is_a? Function
    self.name==x.name &&
        self.scope==x.scope &&
        self.clazz==x.clazz &&
        self.object==x.object &&
        self.arguments==x.arguments
  end

end

class FunctionCall

  attr_accessor :name, :arguments, :scope, :module, :class, :object

  def initialize args
    self.name     =args[:name]
    self.scope    =args[:scope]
    self.class    =args[:class]
    self.module   =args[:module]
    self.object   =args[:object]
    self.arguments=args[:arguments]
  end
end


class Argument
  attr_accessor :name, :type, :position, :default, :preposition, :value

  def initialize args
    self.name       =args[:name]
    self.preposition=args[:preposition]
    self.type       =args[:type]
    self.position   =args[:position]
    self.default    =args[:default]
    self.value      =args[:value]
    # scope.variables[name]=self
  end

  def == x
    self.name == x.name &&
        self.preposition== x.preposition &&
        self.type == x.type &&
        self.position == x.position &&
        self.default == x.default &&
        self.value == x.value
  end

  def name_or_value
    self.value||self.name
  end

  def to_sym
    self.name.to_sym
  end
end


class Variable
  attr_accessor :name, :type,:owner, :value, :final, :modifier     # :scope, :module, << owner

  def initialize args
    self.name    =args[:name]
    self.type    =args[:type]
    self.owner    =args[:owner]
    # self.scope   =args[:scope]
    # self.module  =args[:module]
    self.final   =args[:final]
    self.value   =args[:value]
    self.modifier=args[:modifier]
    # scope.variables[name]=self
  end

  def c #unwrap, for optimization
    return "NUM2INT(#{name})" if type==Numeric
    return "NUM2INT(#{name})" if type==Fixnum
    name
  end

  def wrap
    name
  end

  def to_s
     "Variable #{type} #{name}=#{value}"
  end

  def increase
    self.value = self.value+1
    self.value
  end

end


class Property < Variable
  attr_accessor :name, :owner
end
