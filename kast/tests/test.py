def a(b):
    def c(d):
        return 3 + b + d
    return c

print(a(3)(4)) # 10

def generator_side_effect_assignment_hack():
    [0 for a.value in ['hacky']]

generator_side_effect_assignment_hack()
print a.value

# a.value='3'
def lambda_hack():
    filter(lambda x:[0 for a.value in ['much hacky!']],[0])

lambda_hack()
print a.value

global x
x=8
def test_global():
    global x #NEEDS global TWICE WTF!!
    x=7
print(x) #ok

y=3
z=[0]
def test_global_hack():
    [0 for y in [1]]
    z[0]='YAY'
test_global_hack()
print y #NO!
print z