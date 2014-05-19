how to integrate a function from x to y:
	default steps be 100
	step size is the length of the interval, divided by the number of steps
	let the initial value of I be x
end

while i is smaller or less then y do
  evaluate the function at point I
  add the result to the sum
  increase I by the step size
done

finally return the sum divided by the number of steps
// All comment styles are OK
#  All comment styles are OK
-- All comment styles are (Applescript style)
/* All comment styles are OK */
/* 
OK to have linebreaks??
*/

	
/* reductions:
   generating new language patterns on the fly, better than lisp macros!!
*/
let the initial value of i be x =» i=x
# ^^^ this is now a pattern!

default x be y -> x=y if x is not set
# ^^^ this is now a pattern!

