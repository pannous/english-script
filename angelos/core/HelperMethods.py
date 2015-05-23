
class HelperMethods:
  # def self.:
  def column(self, nr,array):
    # if not a.is_a? Array and b.is_a? Array: return self.column b,a
    all=array.map(lambda x:x.split)
    c=all.map(lambda x:x.at(nr-1))
    c

  def help(self):
      print(          "todo: Instead of pointing the user to the tests in src/test/unit/ he should be offered a proper list of things to do")

