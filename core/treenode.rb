class TreeNode

  attr_accessor :name
  attr_accessor :value
  attr_accessor :parent
  attr_accessor :nodes
  attr_accessor :valid
  attr_accessor :startPointer
  attr_accessor :endPointer
  #attr_accessor :start_line
  #attr_accessor :end_line
  #attr_accessor :start_offset
  #attr_accessor :end_offset

  def show_node
    #true
    @valid and @nodes.empty? and @value or not @nodes.empty? # if node.valid
  end

  def blank?
    @valid and @nodes.empty? and @value or not @nodes.empty? # if node.valid
  end

  def is_leaf
    nodes.empty?
  end

  def content
    content_between startPointer, endPointer
  end

  def good_value
    # return @nodes[0].good_value if @nodes.count==1
    return @name.to_s if not @nodes.empty?
    return @name.to_s + ":" + @value.to_s
  end

  def full_value
    if value
      if $variables and ($variables[value])
        return $variables[value]
      else
        return "'#{value}'" if value.is_a? Quote
        return value
      end
    elsif @nodes.count>0
      return @nodes.map(&:full_value).join(" ")
    else
      return ""
    end
  end

  def value_string
    if @nodes.count==0
      return value.to_s if value and valid #OR NAME ??? !!! CONFUSION!!!
      return nil #no value!!
    end
    r="" # argument hack
    for n in nodes
      r=n.value.to_s+" "+r if n.is_leaf and n.value and n.valid
    end
    r.strip!
    return r
    #x=x.full_value.flip  # argument hack NEEE color= green  color of the sun => sun.green --
  end


  def eval_node variables,fallback
    $variables||=variables
    whot=full_value
    begin
      whot.gsub!("\\", "") # where from?? token?
      res=eval(whot) rescue fallback ## v0.0
      return res
    rescue SyntaxError => se
      return fallback
    end
  end

  def to_s
    good_value
  end

  def destroy
    @valid=false
    @parent.nodes.delete(self) if @parent
  end

  def initialize args={}
    @parent=nil || args[:parent]
    @parent.nodes<<self if @parent
    @nodes=[]
    @valid=false
    @value=nil || args[:value]
    @name=nil || args[:name]
  end
end
