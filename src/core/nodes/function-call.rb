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
