# CLR VIA JAVA! OK with java 8 http://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html

# VIA JRUBY + extensions OR
# via lightweight clojure approach

# Arrays.sort(rosterAsArray, (a, b) -> Person.compareByAge(a, b));
# Arrays.sort(rosterAsArray, Person::compareByAge); !!!

# There are four kinds of method references:
#                                    Kind 	Example
# Reference to a static method 	ContainingClass::staticMethodName
# Reference to an instance method of a particular object 	ContainingObject::instanceMethodName
# Reference to an instance method of an arbitrary object of a particular type 	ContainingType::methodName
# Reference to a constructor 	ClassName::new

# Object methodCaller(Object theObject, String methodName) {
#   return theObject.getClass().getMethod(methodName).invoke(theObject);
# Reflection is not the right answer to anything except "How do I write slow dodgy java code" :D
