![ENGLISH SCRIPT](English script.png "ENGLISH SCRIPT")

This is English as a programming language.
The main purpose of this language is to make programming accessible to many more people, more fun and to facilitate programming computers via Voice.

The guiding philosophy is to have forgiving interfaces yet strict implementations.

Examples
--------
Here are some of our favorite examples from the [tests](test/unit), **working today**:

`beep three times`
(There will be a generation of programmers who will shake their heads that there ever was a programming language which did not interpret that sentence correctly.)

`assert square of [1,2 and 3] equals 1,4,9`

`assert 3rd word in 'hi my friend' is 'friend'`

`x is 2; if all 0,2,4 are smaller 5 then increase x; assert x equals 3 `

`beep every three seconds`

`counter is zero; repeat three times: add 1 to counter; done repeating; assert that the counter is 3`


`last item in 'hi','you' is equal to 'you'`


```
While Peter is online on Skype
	make a beep
	sleep for 10 seconds
Done
```

```
How to check if someone is online on Skype
	Call java Skype.checkStaus(someone)
	Return yes If Result equals "online"
	Return no otherwise
Done
```

Todo (soon):
`add one to every odd number in 1,2,3 == 2,2,4`


Language Specification
----------------------
Read the [DOSSIER](https://github.com/pannous/natural-english/tree/master/DOSSIER.md) for a more complete **language specification**, vision and some background. The grammar is not meant to be linguistically complete, but [functionality complete](https://en.wikipedia.org/wiki/Functional_completeness) and easily extendable. It is currently running in the [ruby](https://www.ruby-lang.org/en/) environment, but will soon compile to the [JVM](https://en.wikipedia.org/wiki/Java_Virtual_Machine),  [CLR](https://en.wikipedia.org/wiki/Common_Language_Runtime) and as a final aim run natively through [LLVM](https://en.wikipedia.org/wiki/LLVM).
"Premature optimization is the root of all evil." Many programming languages 'optimize' on the syntax level in order to optimize the resulting applications. Maybe [this](http://www.cs.utexas.edu/~EWD/transcriptions/EWD06xx/EWD667.html) is a mistake.

To check out the current capabilities of English Script have a look at the [tests](https://github.com/pannous/natural-english/tree/master/test/unit),
[keywords](https://github.com/pannous/natural-english/blob/master/lib/english-script/english-tokens.rb) and
[grammar](https://github.com/pannous/natural-english/blob/master/lib/english-script/english-parser.rb)


EXPERIMENT
----------
Run it and see yourself!

`git clone git@github.com:pannous/english-script.git`
`./install.sh`

**experiment** by typing

`./english-script.sh 6 plus six`

`./english-script.sh "xs be 2,3,7,9; xs that are smaller than 7"`

`./english-script.sh examples/test.e`

`./english-script.sh` (no args for shell)

`english> 6 plus six`

`english> x is 2; if all 0,2,4 are smaller 5 then increase x`

Todos
-----
* Use the abstract syntax tree to compile instead of interpret (export via XML and Lisp s-expressions)
* Better (real) function argument matching: Integrate the sine curve in the interval 1 to 10 with step size .1
* Implement event system: Beep three times whenever the disc space is over 80%
* Hook into more existing libraries (java,ifttt,rubyosa?,...)
* IntelliJ plugin
* Promote the ease of use of this language:
`set xs to all positive natural numbers smaller than 3; assert that xs.count==2 and xs' lenght equals the size of xs`

Also check out cool similar projects:
[kal](https://github.com/rzimmerman/kal)
[dogescript](https://github.com/remixz/dogescript)

This language might soon be used in our successful beloved Jeannie assistant, which has over 4 million downloads so far:
http://www.voice-actions.com

For a background story/vision/philosophy/future of this project read the [DOSSIER](https://github.com/pannous/natural-english/tree/master/DOSSIER.md)

