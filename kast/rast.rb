rast_unmapped_nodes=%w[Alias And Args Argument Begin BinaryOperator Bignum Break Call Case Class Const False File Fixnum Float Hash If
 Iter For Lambda List Array Block Literal Match MethodDef Module Next Nil Not Defs Newline Or Redo Rescue Retry
 Return Root Star Str Self Super Regexp Splat Symbol True Undef Until When While Yield]

# Splat: x,y,z=*array

yml=YAML::load(File.open('rast-map.yml'))
p yml
