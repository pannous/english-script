# require_relative 'rast-writer'
require_relative 'ast-writer'
dir="/Users/me/dev/ai/english-script/test/unit/"

for file0 in Dir.entries(dir)-['.', '..','ui','programs']
  file=dir+file0
  # out=File.open("/Users/me/dev/ai/english-script/test/rast/"+file0+".rast","w")
  # do_map=false
  out=File.open("/Users/me/dev/ai/english-script/test/rast/"+file0+".kast","w")
  do_map=true
  dump_xml(file,out,do_map)
end
