import ast
import os
import sys
import ast_import

def import_kast_to_python(kast_file,py_file_name="test/output.py"):
    print("import_kast_to_python "+kast_file)
    my_ast= ast_import.parse_file(kast_file)
    import ast_export
    # ast_writer.dump_xml(my_ast)

    # import codegen
    from astor import codegen
    source = codegen.to_source(my_ast)
    source=source.replace(".new(","(") #hack
    source=source.replace(".+(","+(") #hack
    source=source.replace(".!=","!=") #hack
    source=source.replace(".!()","==False") #hack
    source=source.replace("!(","(") #hack
    source=source.replace("?(","(") #hack
    source=source.replace("from ParserTestHelper import *","") #hack


    print(source)
    if py_file_name:
        py_file=open(py_file_name,"w")
        py_file.write(source)
        py_file.close()

    my_ast=ast.fix_missing_locations(my_ast)
    # x=ast.dump(my_ast, annotate_fields=False, include_attributes=False)
    # print("\n".join(x.split("),")))
    # code=compile(my_ast, 'file', 'exec')
    # ast_import.emit_pyc(code)
    # exec(code)
    # print(exec(code))#, glob, loc)

    # code=compile(my_ast, kast_file, 'exec')#flags=None, dont_inherit=None
    # TypeError: required field 'lineno' missing from stmt
    # no, what you actually mean is "tuple is not a statement" LOL WTF ;)
    # exec(code)
    return my_ast


# schema_file='kast.xsd'
# kast_file='test.pyast.xml'
kast_file='test_mini.pyast.xml'
# kast_file='test_full.pyast.xml'
# kast_file='test.xast'
# kast_file='test.kast.xml'
# kast_file='kast.yml'

folder="/Users/me/dev/ai/english-script/test/rast/"
out_folder="/Users/me/dev/ai/english-script/angelos/test/"

# kast_file="/Users/me/dev/ai/english-script/test/rast/number_test.rb.kast"
# kast_file="/Users/me/dev/ai/english-script/test/rast/function_test.rb.kast"
# kast_file="/Users/me/dev/ai/english-script/test/rast/parser_test_helper.rb.kast"
kast_file="/Users/me/dev/ai/english-script/test/rast/../parser_test_helper.rb.kast"
# kast_file="/Users/me/dev/ai/english-script/test/rast/mac_test.rb.kast"
# pyast_file='demo.pyast'
import_kast_to_python(kast_file)
quit()
# out_folder="/Users/me/dev/ai/english-script/test/python/"
for f in os.listdir(folder): # ls folder files !
    if not f.endswith(".kast"): continue
    if f.endswith("main.kast"): continue
    if f.endswith("extensions.rb.kast"): continue
    if f.startswith("."):continue
    kast_file=folder+f
    py_file = out_folder+ f.replace(".rb.kast", ".py")
    # if os.path.isfile(py_file):
    #     print("file exists "+py_file)
    #     continue

    import_kast_to_python(kast_file, py_file)
    # try:
    #     import_kast_to_python(kast_file,kast_file.replace("rast","python").replace(".rb.kast",".py"))
    # except Exception as e:
    #     print(e)
    #     raise e


  # if not path.isfile(path.join(mypath,f)):

