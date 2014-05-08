#!/usr/bin/env ruby

$use_tree=false
require_relative '../test_helper'

class ListTestParser<EnglishParser
  def current
    #test_type0
    #test_list_syntax
    #test_type1
    #test_type2
    #test_type
    #test_type3
    #test_concatenation
    #test_gerunds
    #test_string_methods
    #test_select
    #test_select2
    #test_concatenation
    #test_concatenation2
  end

  def initialize

    super
  end


  def test_type0
    s "1 , 2 , 3"
    list
    s "1,2,3"
    list
    s "[1,2,3]"
    list
    s "{1,2,3}"
    list
    s "1,2 and 3"
    list
    s "[1,2 and 3]"
    list
    s "{1,2 and 3}"
    l=list
    assert l==[1, 2, 3]
  end


  def _test_list_methods
    parse "invert [1,2,3]"
    assert @result=="[3,2,1]"
  end

  def test_error
    assert "first item in 'hi,'you' is 'hi'"
  end

  def test_select2
    assert "first item in 'hi','you' is 'hi'"
    assert "second item in 'hi','you' is 'you'"
    assert "last item in 'hi','you' is 'you'"
  end


  def test_select3
    assert "1st word of 'hi','you' is 'hi'"
    assert "2nd word of 'hi','you' is 'you'"
    assert "3rd word of 'hi','my','friend' is 'friend'"
  end


  def test_select4
    assert "first word of 'hi','you' is 'hi'"
    assert "second word of 'hi','you' is 'you'"
    assert "last word of 'hi','you' is 'you'"
  end

  def test_select5
    #assert "numbers are 1,2,3. second number is 2"
    #assert "my friends are a,b and c. my second friend is b"
    #assert "first character of 'h','i','v' is 'h'"
    #assert "second character of 'h','i','v' is 'i'"
    #assert "last character of 'h','i' is 'i'"
  end

  def test_list_syntax
    assert("1,2 is [1,2]")
    assert("1,2 is {1,2}")
    assert("[1,2] is {1,2}")
    assert("1,2 and 3 is [1,2,3]")
    assert("1,2,3 is the same as [1,2,3]")
    assert("1,2 and 3 is the same as [1,2,3]")
  end

  def test_concatenation
    parse "x is 1,2,3;y=4,5,6"
    assert(@variables['x']== [1, 2, 3]);
    assert(@variables['y'].count== 3);
    s "x + y"
    z=algebra
    assert @result.length==6
  end

  def test_concatenation2
    parse "x + y"
    assert @result.length==6
    parse "x is 1,2
       y is 3,4
       z is x + y"
    assert(@variables['z']== [1, 2, 3, 4]);
    assert("x and y == [1,2,3,4]")
    assert("x and y == 1,2,3,4");
    assert("x + y == 1,2,3,4");
    assert("x plus y == [1,2,3,4]");
  end

  def test_type1
    s "class of 1,2,3"
    evaluate_property
    assert @result==Array
    s "class of [1,2,3]"
    expression0
    assert @result==Array
    parse "class of 1,2,3"
    assert @result==Array
  end


  def test_type2
    parse "x=1,2,3;class of x"
    assert @result==Array
  end


  def test_type
    parse "x=1,2,3;"
    assert "type of x is Array"
  end

  def test_type3
    parse "x be 1,2,3;y= class of x"
    assert @variables['y']==Array
    assert("type of x is Array")
    assert("class of x is Array")
    assert("kind of x is Array")
    assert("y is Array")
  end

  def test_map
    assert("square 1,2 and 3 == 1,4,9")
    assert("square of 1,2 and 3 == 1,4,9")
    assert("square every number in 1,2,3 ==1,4,9")
    assert("add one to every number in 1,2,3 ==2,3,4")
    assert("square every number in 1,'a',3 ==1,9")
  end


end

class ListTest < Test::Unit::TestCase

  def self._test x
    puts "NOT testing "+x.to_s
  end

  def initialize args
    @testParser=ListTestParser.new
    super args
  end

  def test_all
    @testParser.methods.each { |m|
      if m.to_s.start_with? "test"
        begin
          @testParser.send(m)
        rescue => e
          puts "NOT PASSING: "+m.to_s
          @testParser.error e
        end
      end
    }
  end

  def test_current
    @testParser.current
  end

end
