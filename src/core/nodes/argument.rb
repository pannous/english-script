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

