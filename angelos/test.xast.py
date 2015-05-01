# coding=utf-8
import xml
import xml.dom.minidom
import inspect
from xml.dom.minidom import parse
file=open("test.xast")
xml=parse(file)
print xml.toxml()
print dir(xml)
# print inspect
# print dir(inspect)