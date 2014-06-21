class HelperMethods
  # def self.
  def self.column a,b
    all=a.map{|x|x.split}
    c=all.map{|x|x.at b}
    c
  end
end
