
class Variable
  attr_accessor :name, :type,:owner, :value, :final, :modifier     # :scope, :module, << owner

  def initialize args
    self.name    =args[:name]
    self.value   =args[:value]
    self.type    =args[:type]
    self.owner    =args[:owner]
    # self.scope   =args[:scope]
    # self.module  =args[:module]
    self.final   =args[:final]
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
    # "<Variable '#{name}' #{type}:#{value}>"
    "<Variable #{name}=#{value}>"
  end

  def to_sym
    name
  end
  #
  # def increase by=1
  #   # self.value = self.value+by # don't self modify here!!
  #   by+self.value
  # end


  def == x
    return self.value == x if not x.is_a?Variable
    super == x
    # self.name == x.name &&
    #     self.preposition== x.preposition &&
    #     self.type == x.type &&
    #     self.position == x.position &&
    #     self.default == x.default &&
    #     self.value == x.value
  end

end


class Property < Variable
  attr_accessor :name, :owner
end
