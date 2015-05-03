require_relative 'kast'
True =true
None =nil
False=false
# import

# Instance methods
include Kast
# class methods
extend Kast
@ast=Module(body=[Print(dest=None, values=[Str(s='hi')], nl=True), Print(dest=None, values=[BinOp(left=Num(n=6), op=Mult(), right=Num(n=7))], nl=True), Assign(targets=[Name(id='a', ctx=Store())], value=BinOp(left=Num(n=1), op=Add(), right=Num(n=2))), Print(dest=None, values=[Name(id='a', ctx=Load())], nl=True)])
def ast
  return @ast
end
