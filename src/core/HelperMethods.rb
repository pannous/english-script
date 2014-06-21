class HelperMethods
  # def self.
  def self.column a,b
    all=a.map{|x|x.split}
    c=all.map{|x|x.at b}
    c
  end

  def self.help
    puts "todo: Instead of pointing the user to the tests in src/test/unit/ he should be offered a proper list of
things to do"
  end
end
