# coding: interpy #{'ruby strings'}
from cStringIO import StringIO

fileName   ='test.kast.xml'
fileName   ='kast.yml'
schema_file='kast.xsd'

def yml2xml(builder, body, tabs=0):
    if(tabs==0 and len(body)>1): builder.write( "<module xmlns='http://angle-lang.org'>\n")
    for elem in body:
        k=elem
        v=body[k]
        val=isinstance(v,int)
        val=val or isinstance(v,float)
        val=val or isinstance(v,str)
        val=val or isinstance(v,bool)
        if val:
            builder.write( "\t"*tabs+"<#{k}>#{v}</#{k}>\n")
        else:
            builder.write( "\t"*tabs+"<#{k}>\n")
            yml2xml(builder, v, tabs+1)
            builder.write("\t"*tabs+"</#{k}>\n")
    if (tabs==0 and len(body)>1): builder.write("</module>")
    return builder


file=open(fileName)
if fileName.endswith("yml"):
    import yaml
    xml =yml2xml(StringIO(),yaml.load(file)).getvalue()
    print(xml)

def normed_kast_xml(xml_filename="test_mini.pyast.xml"):
    import lxml.etree as ET
    xsl_filename="lowercase.xslt"
    dom = ET.parse(xml_filename)
    xslt = ET.parse(xsl_filename)
    newdom = ET.XSLT(xslt)(dom)
    print(ET.tostring(newdom, pretty_print=True))
    return newdom

