class Function
  attr_accessor :name, :arguments, :return_type, :scope, :module, :clazz, :object, :body

  def initialize args
    self.name     =args[:name]
    self.body     =args[:body]
    self.scope    =args[:scope]
    self.clazz    =args[:class]||Object
    self.module   =args[:module]
    self.object   =args[:object]
    self.arguments=args[:arguments]||[]

    # integrate a function between x and y => object = a function (class)
    # if(self.arguments.count>0 and not self.object)
    #   if(arguments[0].preposition.empty?)
    #     self.object=arguments[0]
    #     arguments.shift
    #   end
    # end
    # scope.variables[name]=self
  end

  def to_s
     "#<Function #{name} #{args}>"
  end

  def argc
    self.arguments.count
  end

  def args
    arguments
  end

  def == x
    return false if not x.is_a? Function
    self.name==x.name &&
        self.scope==x.scope &&
        self.clazz==x.clazz &&
        self.object==x.object &&
        self.arguments==x.arguments
  end

  def call *args
    # self.context.
    # EnglishParser.call_function self,args
    scope.call_function self,args
  end

  def eval *args
    EnglishParser.call_function self,args
  end

end
