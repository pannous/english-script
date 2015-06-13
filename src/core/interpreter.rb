module Interpreter

  def call_function f, args=nil
    do_send f.object, f.name, args|| f.arguments
  end

  # INTERPRET only,  todo cleanup method + argument matching + concept ('subparser ok?')
  def do_send obj0, method, args0
    return false if not interpreting? rescue
        return false if not method

    # try direct first!
    # y=y[0] if y.is_a? Array and y.count==1 # SURE??????? ["noo"].length
    if @methods.contains method # 'internal'
      method, arguments=match_arguments(method, args0)
      return @result=do_execute_block(method.body, arguments)
    end

    obj =method.owner if method.is_a? Method
    obj ||=resolve(obj0)
    # obj.map{|x| x.value}
    # obj=obj0 if obj0.is_a?Variable and self_modifying(method) #todo better!!
    args=args0
    args=args.name_or_value if args.is_a? Argument
    args=args.map { |x| x.name_or_value } if args.is_a? Array and args[0].is_a? Argument
    args=eval_string(args) rescue NoMethodError
    args.replace_numerals! if args and args.is_a? String
    # args.strip! if args and args.is_a?String NO! a + " " etc!

    if method.is_a? Method and method.owner
      return @result=method.call(*args)
    end

    method_name=(method.is_a? Method) ? method.name.to_s : method.to_s #todo bettter
    if obj.respond_to? method_name
      # OK
    elsif obj.respond_to? method_name+'s'
      method=method_name+'s'
    elsif obj.respond_to? method_name.gsub(/s$/, '')
      method=method_name.gsub(/s$/, '') rescue nil
    end

    @result=NoMethodError
    if not obj
      obj=args0
      @result=Object.send(method, args) rescue NoMethodError
      @result=args.send(method) rescue NoMethodError #.new("#{obj}.#{op}")
      @result=args[1].send(method) if has_args method, obj if (args[0]=='of') rescue NoMethodError #rest of x
    else
      if (obj==Object)
        m      =method(method_name)
        @result=m.call || :nill unless has_args method, obj, false rescue NoMethodError
        @result=m.call(args) || :nill if has_args method, obj, true rescue NoMethodError
      else
        @result=obj.send(method) unless has_args method, obj, false rescue NoMethodError
        @result=obj.send(method, args) if has_args(method, obj, true) and @result==NoMethodError rescue NoMethodError
        #SyntaxError,
      end
    end
    #todo: call FUNCTIONS!
    # puts object_method.parameters #todo MATCH!

    # => selfModify todo
    selfModify=self_modifying method
    selfModify=selfModify and (obj0||args) #and not obj0.is_a?Variable
    if selfModify
      name =(obj0||args).to_sym.to_s
      if @variables.has name
        @variables[name].value=@result #rescue nil
        @variableValues[name] =@result
      end
    end #rescue nil

    # todo : nil OK, error not!
    msg="ERROR CALLING #{obj}.#{method}(#{args})" if @result==NoMethodError
    raise NoMethodError.new(msg, method, args) if @result==NoMethodError
    # raise SyntaxError.new("ERROR CALLING #{obj}.#{op}(#{args}) : NoMethodError")
    return @result
  end

  def do_compare a, comp, b
    a   =eval_string(a) # NOT: "a=3; 'a' is 3" !!!!!!!!!!!!!!!!!!!!   Todo ooooooo!!
    b   =eval_string(b)
    a   =a.to_f if a.match(/^\+?\-?\.?\d/) and b.is_a? Numeric rescue a
    b   =b.to_f if b.match(/^\+?\-?\.?\d/) and a.is_a? Numeric rescue b
    comp=comp.strip if comp.is_a? String #what else
    if comp=='smaller'||comp=='tinier'||comp=='comes before'||comp=='<'
      return a<b
    elsif comp=='bigger'||comp=='larger'||comp=='greater'||comp=='comes after'||comp=='>'
      return a>b
    elsif comp=='smaller or equal'||comp=='<='
      return a<=b
    elsif class_words.index comp
      return a.is_a b
      # return a.is_a? b if b.is_a? Class
    elsif be_words.index comp or comp.match(/same/)
      return a.is b
    elsif comp=='equal'||comp=='the same'||comp=='the same as'||comp=='the same as'||comp=='='||comp=='=='
      return a==b # Redundant
    else
      begin
        return a.send(comp, b) # raises!
      rescue
        error('ERROR COMPARING '+ a.to_s+' '+comp.to_s+' '+b.to_s)
        return a.send(comp+'?', b)
      end
    end
  end


def do_cast x, typ
  return x.to_i if typ==Integer
  return x.to_f if typ==Float
  return x.to_i if typ==Fixnum
  return x.to_i if typ.is_a "int" #todo!
  return x.to_f if typ.is_a "number" #todo!
  return x.to_f if typ.is_a "float" #todo!
  return x.to_f if typ.is_a "real" #todo!
  return x.to_i if typ=="int"
  return x.to_s if typ.is_a "String"
  #todo!
  return x
end

  # see resolve eval_string???
  def do_evaluate x, type=nil #  #WHAT, WHY?
    return x if not interpreting?
    begin
      return do_evaluate(x[0]) if x.is_a? Array and x.length==1
      return x if x.is_a? Array and x.length!=1
      return x.to_f if x.is_a? String and type and type.is_a? Numeric
      return x.value || @variableValues[x.name] if x.is_a? Variable
      return @variableValues[x]||@variables[x].value if @variables[x]
      return @variableValues[x] if @variableValues.contains x
      return x if x==true or x==false
      return x.to_f if x.is_a? String and type and type.is_a? Fixnum
      return x.eval_node @variableValues if x.is_a? TreeNode
      return resolve x if x.is_a? String and match_path(x)
      # ... todo METHOD / Function!
      return x.call if x.is_a? Method #Whoot
      return x if x.is_a? String
      return eval(x) if x.is_a? String # rescue x # system.jpg  DANGER? OK ^^
      return x # DEFAULT!
    rescue TypeError, SyntaxError => e
      puts "ERROR #{e} in do_evaluate #{x}"
      return x
    end
  end

  # see do_evaluate ! merge
  def resolve x
    return Dir.new x if is_dir x
    return File.new x if is_file x
    return x.value if x.is_a? Variable
    return @variableValues[x.strip] if @interpret and @variableValues.key?(x)
    x
  end


  def try_evaluate_property(x, y)
    begin #interpret !:
      @result=do_evaluate_property(x, y)
    rescue SyntaxError => e
      verbose 'ERROR do_evaluate_property'
        #@result=jeannie all if not @result
    rescue => e
      verbose 'ERROR do_evaluate_property'
      verbose e
      error e
      error $!
      #@result=jeannie all if not @result
    end
    return @result
  end

  # TODO: big cleanup!
  # see resolve, eval_string,  do_evaluate, do_evaluate_property, do_send
  def do_evaluate_property x, y
    # todo: REFLECTION / eval NODE !@!!
    return false if x.nil?
    verbose 'do_evaluate_property '+x.to_s+' '+y.to_s
    @result=nil #delete old!
    x      ='class' if x=='type' # !@!@*)($&@) NOO
    x      =x.value_string if x.is_a? TreeNode
    return @result=do_send(y, x, nil) rescue nil #try 1
    return @result=eval(y+'.'+x) rescue nil #try 1
    x=x.join(' ') if x.is_a? Array
    return @result=eval(y+'.'+x) rescue nil #try 2
    y=y.to_s #if y.is_a? Array
    return @result=eval(y+'.'+x) rescue nil #try 3
    all=x.to_s+' of '+y.to_s
    x  =x.gsub(' ', ' :')
    begin
      @result=eval(y+'.'+x) rescue nil
      @result=eval("'"+y+"'."+x) if not @result rescue SyntaxError #string method
      #@result=eval('"'+y+'".'+x) if not @result  rescue SyntaxError #string method
      @result=eval(all) if not @result rescue SyntaxError
    end
    @result
  end

  # Strange method, see resolve, do_evaluate
  def eval_string x #hackety hack for non-tree mode
    return nil if not x
    return x.to_path if x.is_a? File
    return x if x.is_a? String and x.index('/') #file, not regex!  ... notodo ...  x.match(/^\/.*[^\/]$/)
    # x=x.join(" ") if x.is_a? Array
    return x[0] if x.is_a? Array and x.count==1
    return x if x.is_a? Array
    # return x.to_s if x.is_a? Array
    do_evaluate x rescue x
  end


  def do_execute_block b, args={}
    return false if not b
    return call_function b if b.is_a? FunctionCall
    return call_function b, args if b.is_a? Function
    b=b.content if b.is_a? TreeNode
    return b if not b.is_a? String and not b.is_a? Array # OR ... !!!
    block_parser               =EnglishParser.new
    # todo : wrap in Context class
    block_parser.variables     =@variables
    block_parser.methods       =@methods
    # block_parser.classes =@classes
    # block_parser.modules =@modules
    block_parser.variableValues=@variableValues
    args                       ={arg: args} if not args.is_a? Hash
    # see match_arguments for preparation!
    for arg, val in args
      v=block_parser.variables[arg]
      if v
        v                               =v.clone
        v.value                         =val
        block_parser.variables[arg.to_s]=v # to_sym todo NORM in hash!!!
      else
        block_parser.variables[arg.to_s]=Variable.new name: arg, value: val
      end
    end
    # block_parser.variables+=args
    begin
      @result =block_parser.parse(b.join("\n")).result
    rescue
      error $!
    end
    @variableValues =block_parser.variableValues
    @result
    #do_evaluate b
  end

  def jeannie request
    jeannie_api='https://weannie.pannous.com/api?'
    params     ='login=test-user&out=simple&input='
    #raise "empty evaluation" if @current_value.blank?
    download jeannie_api+params+URI.encode(request)
  end

  # beep when it rains
  # listener
  def add_trigger condition, action
    @listeners<<Observer.new(condition, action)
  end


  def do_eval the_expression
    # subnode(statement= the_expression)
    subnode({'statement':the_expression})
    @current_value=the_expression
    begin
      @result=eval(english_to_math the_expression) #if @result.blank?
    rescue
      @result=jeannie(the_expression)
    end
    subnode result: @result # todo: via automagic
    @current_value=@result
    @current_value
  end


  # todo : why special? direct eval, rest_of_line
  def do_call_ruby_method ruby_method,args
    begin
      the_call       =ruby_method+' '+args.to_s
      print_variables=@variableValues.inject("") { |s, v| "#{v[0]}=#{v[1].is_a(String) ? '"'+v[1]+'"' : v[1]};"+s }
      @result        =eval(print_variables+ the_call)||''
      verbose the_call+'  called successfully with result '+@result.to_s
      return result
    rescue SyntaxError => e
      puts "\n!!!!!!!!!!!!\n ERROR calling #{the_call}\n!!!!!!!!!!!! #{e}\n "
    rescue => e
      puts "\n!!!!!!!!!!!!\n ERROR calling #{the_call}\n!!!!!!!!!!!! #{e}\n "
      error $!
      puts '!!!! ERROR calling '+the_call
    end
  end


  def now
    Time.now
  end

  def yesterday
    Time.now-24*60*60
  end

end
