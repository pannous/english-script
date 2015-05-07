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
