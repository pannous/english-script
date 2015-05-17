require_relative 'ast-writer'
dir="/Users/me/dev/ai/english-script/test/unit/"

for file0 in Dir.entries(dir)-['.', '..','ui','programs']
  file=dir+file0
  out=File.open("/Users/me/dev/ai/english-script/test/rast/"+file0+".rast","w")
  dump_xml(file,out)
end
