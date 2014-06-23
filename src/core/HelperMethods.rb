class HelperMethods
  # def self.
  def self.column nr,array
    # return self.column b,a if not a.is_a? Array and b.is_a? Array
    all=array.map{|x|x.split}
    c=all.map{|x|x.at nr-1}
    c
  end

  def self.help
    puts "todo: Instead of pointing the user to the tests in src/test/unit/ he should be offered a proper list of
things to do"
  end
end
