![ENGLISH SCRIPT](English script.png "ENGLISH SCRIPT")

This is English as a programming language.
The main purpose of this language is to make programming accessible to many more people, more fun and to facilitate programming computers via Voice.

The guiding philosophy is to have forgiving interfaces yet strict implementations.

Examples
--------
Here are some of our favorite examples from the [tests](test/unit), **working today**:

`assert two minus 1½ equals 0.5`

`beep three times`
(There will be a generation of programmers who will shake their heads that there ever was a programming language which did not interpret that sentence correctly.)

`assert square of [1,2 and 3] equals 1,4,9`

`assert 3rd word in 'hi my friend' is 'friend'`

`x is 2; if all 0,2,4 are smaller 5 then increase x; assert x equals 3 `

`beep every three seconds`

`last item in 'hi','you' is equal to 'you'`


```
While Peter is online on Skype
	make a beep
	sleep for 10 seconds
Done
```

```
To check if person is online on Skype:
	Skype.checkStatus(person)
	if result is "online": return yes 
	else return no
End
```

Todo (soon):
`add one to every odd number in 1,2,3 == 2,2,4`

`delete all files in my home folder that end with 'bak'`

The implicit list filter '*that*' applies the selection criterion to all elements.

`with all mails by peter: mark it as read if its subject contains 'SPAM'`

The implicit lambda variable '*it*' translates to ruby

`mails(by: Peter).each{|it| it.mark(:read) if it.subject.match('SPAM')}`


Language Specification
----------------------
Angle is a multi-paradigm programming language with [gradual typing](https://en.m.wikipedia.org/wiki/Gradual_typing).

Read the [DOSSIER](https://github.com/pannous/english-script/blob/master/DOSSIER.md) for a more complete [**language specification**](https://github.com/pannous/english-script/blob/master/DOSSIER.md), vision and some background. 

The grammar is not meant to be linguistically complete, but [functionality complete](https://en.wikipedia.org/wiki/Functional_completeness) and easily extendable. It is currently running in the 
* [ruby](https://www.ruby-lang.org/en/) and python environment, but will soon compile to the 
* [JVM](https://en.wikipedia.org/wiki/Java_Virtual_Machine) (thanks to Mirah)
* [.Net/CLR/DLR](https://en.wikipedia.org/wiki/Dynamic_Language_Runtime) (via Cecil), 
* JavaScript, and 
* run **natively**, as a final aim, maybe similar to [Vala](https://en.wikipedia.org/wiki/Vala_%28programming_language%29) or RPython

Having a [self-hosted "bootstrapped" compiler](https://en.wikipedia.org/wiki/Bootstrapping_%28compilers%29) is an important mid-term goal.

"Premature optimization is the root of all evil." Many programming languages 'optimize' on the syntax level in order to optimize the resulting applications. Maybe [this](http://www.cs.utexas.edu/~EWD/transcriptions/EWD06xx/EWD667.html) is a mistake.

To check out the current capabilities of English Script have a look at the [tests](https://github.com/pannous/english-script/tree/master/test/unit),
[keywords](https://github.com/pannous/english-script/blob/master/src/core/english-tokens.rb) and
[grammar](https://github.com/pannous/english-script/blob/master/src/core/english-parser.rb)

INSTALL
-------
`git clone git@github.com:pannous/english-script.git`

`cd english-script`

`./install.sh`

Start the shell : `./bin/angle` or `rake shell`

EXPERIMENT
----------
Run it and see yourself!

**experiment** by typing

`./bin/angle "6 plus six"`

`./bin/angle examples/test.e`

`./bin/angle` (no args to start the shell)

`⦠ 6 plus six`

`⦠ beep three times`

`⦠ x is 2; if all 0,2,4 are smaller 5 then increase x`

**Test**

Run the tests : `rake test`

Run an angle file: `rake run[examples/test.e]`

Todos
-----
* Use the abstract syntax tree to compile instead of interpret (export via XML and Lisp s-expressions)
* Better (real) function argument matching: Integrate the sine curve in the interval 1 to 10 with step size .1
* Implement event system: Beep three times whenever the disc space is over 80%
* Hook into more existing libraries (java,ifttt,rubyosa?,...)
* IntelliJ plugin
* Promote

This language might soon be used in our successful beloved Jeannie assistant, which has over 4 million downloads so far:
http://www.voice-actions.com

For a background story/vision/philosophy/future of this project read the [DOSSIER](https://github.com/pannous/natural-english/tree/master/DOSSIER.md)

