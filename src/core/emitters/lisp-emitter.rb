# F# like other Oca ML variants adds only UGLYNESS!

# http://stackoverflow.com/questions/913671/are-there-lisp-native-code-compilers
# http://clojure.org/special_forms#var Not to be confused with Clozure CL.
# http://www.infoq.com/presentations/clojure-scheme -> native!#
# fasl == bytecode -> NATIVE
# gsc Gambit v4.7.5 Scheme -> NATIVE !! gsc
# gcl - GNU Common Lisp compiler
# ccl http://ccl.clozure.com/docs/ccl.html Clozure CL Not to be confused with clojure

# Native?? Even if you get all that straightened out, you still lack a good
# standard lib. This is what really killed the project for me. Read up
# on C++ linking sometime. Trying to get something like .JARs or .net
# assemblies working on a native level is a nightmare to say the least.

# clojure -> jvm , .net, js, native, YAY!!!


# (class bla [(package 'com.pannous') (implements com.bla.XYZ)])
# really?? YES, HASHES TO THE RESCUE / to_json !!!!!

# (class bla {package 'com.pannous' implements 'com.bla.XYZ} (
#   (defn k ^public ^void [^int a]())
# ))

# EEEK needs makros :  NO reflection Etc etc ... --
# http://stackoverflow.com/questions/1112709/when-you-extend-a-java-class-in-clojure-and-define-a-method-of-the-same-name-as
# (def SomeNewClass
# (proxy [DefaultHandler] []
# (startElement
# [uri local qname atts]
# (println (format "Saw element: %s" qname)))))
#
# You're right about what it does. The proxy statement makes a new class, the equivilent of this Java code:
#
# public class SomeNewClass extends DefaultHandler {
#     public void startElement(String uri,
#                      String localName,
#                      String qName,
#                      Attributes attributes) {
#         System.out.println(*stuff*);
#     }
# }
