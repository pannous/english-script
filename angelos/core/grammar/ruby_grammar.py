class RubyGrammar:
  def execute_ruby_block(self):
    #import evil
    lines=ruby_block
    result=eval(lines.join("\n"))
    print result
    #result=class_eval(lines.join("\n"))
    #p result
    #A.instance_method('m').force_bind(B()).call
    #ruby_block_test

  def ruby_block(self):
    block_depth=0
    lines=[]
    def lamb():
      if (starts_with("end")) and block_depth==0:
          raise EndOfBlock()
      line=any_ruby_line
      lines.append(line)
      line
    star(lamb)
    lines.append("end" #todo: in any_ruby_line)
    self.current_value=lines #todo: !?!
    lines

  def ruby_def(self):
    _ "def"
    no_rollback11
    lines=["def "+self.string](self):
    method=word "method"
    #self.current_node.value=method #has ruby_block leaf!
    maybe( arg=word; }
    maybe( _ "="; defaulter=(quote? or word?) } # or ...!?
    star( _ ","; arg=word; }
    newline
    lines+=ruby_block
    #-- # // Some Ruby coat goes here
    newline22
    done
    try:
      #Redirect output to HTML result
      the_script=lines.join("\n").gsub("print", "x_puts")
      eval the_script
      self.ruby_methods.append(method)
      self.methods.append(self.current_node # to do: more)
      verbose method + " defined successfully !"
    except
      error "error in ruby_def block"(self):
      error lines
      error(traceback.extract_stack())

    newline22
    lines

  def install_gem(gem):
    `gem install #{gem}` #todo: ask ;}

  def ruby_require(dependency):
    if interpreting():
      # todo obj.include !!
      # todo mapping + reflection
      try:
        require dependency
        # extends dependency
        # import 
      except Exception as e:
        print "missing dependency #{dependency}: #{e}"
        if not $testing: install_gem dependency except None

