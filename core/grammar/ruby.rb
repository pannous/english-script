module RubyGrammar
  def execute_ruby_block
    #require 'evil'
    lines=ruby_block
    result=eval(lines.join("\n"))
    puts result
    #result=class_eval(lines.join("\n"))
    #p result
    #A.instance_method(:m).force_bind(B.new).call
    #ruby_block_test
  end


  def ruby_block
    block_depth=0
    lines=[]
    star {
      raise EndOfBlock.new if (starts_with? "end") and block_depth==0
      line=any_ruby_line
      lines<<line
      line
    }
    lines<<"end" #todo: in any_ruby_line
    @current_value=lines #todo: !?!
    lines
  end

  def ruby_def
    _ "def"
    no_rollback!
    lines=["def "+@string]
    method=word "method"
    #@current_node.value=method #has ruby_block leaf!
    maybe { arg=word; }
    maybe { _ "="; defaulter=(quote? or word?) } # or ...!?
    star { _ ","; arg=word; }
    newline
    lines+=ruby_block
    #-- # // Some Ruby coat goes here
    newline?
    done
    begin
      #Redirect output to HTML result
      the_script=lines.join("\n").gsub("puts", "x_puts")
      eval the_script
      @ruby_methods<<method
      @methods<<@current_node # to do: more
      verbose method + " defined successfully !"
    rescue
      error "error in ruby_def block"
      error lines
      error $!
    end
    newline?
    lines
  end


  def install_gem gem
    `gem install #{gem}` #todo: ask ;}
  end

  def ruby_require dependency
    install_gem dependency
    if check_interpret
      # todo obj.include !!
      # todo mapping + reflection
      include dependency rescue nil #ruby!
      extends dependency rescue nil #ruby!
      require dependency rescue nil #ruby!
    end

  end

end
