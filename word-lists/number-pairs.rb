#!/usr/bin/env ruby
# encoding: utf-8

i=1
for l in File.readlines("english.numbers.list")
  i=i+1
  n=l.strip if i%2==0
  if i%2==1
  print "put(\"#{l.strip}\",\"#{n}\");\n" 
  next 
  end
end
  