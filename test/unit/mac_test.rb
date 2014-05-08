#!/usr/bin/env ruby

$use_tree=false
require_relative '../test_helper'

class MacTestParser<EnglishParser

  def current
    test_applescript
    # test_contains_file
    # test_variable_transitivity
  end

  def test_mail

  end

  def test_applescript
    parse "Tell application \"Finder\" to open home"
    # s "Tell application \"Finder\" to open home"
    # s 'tell app "Finder"\rdisplay dialog "Hello, world!"\rend'
    # result=applescript
    # assert_equals result,@result
    # assert result.contains "OK"
    # applescript
    # parse "Tell application 'Finder' to close every window"
  end

  def test_files
    @variables['x']="/Users/me"
    @variables['my home folder'] = "/Users/me"
    assert "/Users/me == x"
    assert "my home folder == /Users/me"
    assert "my home folder == x"
  end

  def test_files3
    s "my home folder = Dir.home"
    setter
    s "my home folder == /Users/me"
    condition
    s "/Users/me/photo.JPG ok"
    p=linuxPath
    s "Dir.home"
    r=rubyThing
    parse "x := /Users/me "
    assert "my home folder == /Users/me"
    assert "/Users/me == x"
    assert "my home folder == x"
  end


  def test_variable_transitivity
    parse "my home folder = Dir.home "
    parse "xs= my home folder "
    assert "xs = /Users/me" #WOW!
  end

  def test_contains_file
    parse "xs= all files in Dir.home"
    assert "xs contains photo.JPG"


    parse "xs= Dir.home"
    assert "xs contains photo.JPG"

    parse "xs=/Users/me"
    assert "xs contains photo.JPG"

    parse "my home folder is Dir.home"
    parse "xs shall be all files in my home folder "
    assert "xs contains photo.JPG"

  end
end

class MacTest < Test::Unit::TestCase

  def self._test x
    puts "NOT testing "+x.to_s
  end

  def initialize args
    @testParser=MacTestParser.new
    super args
  end

  def test_all
    @testParser.methods.each { |m|
      if m.to_s.start_with? "test"
        @testParser.send(m)
      end
    }
  end

  def test_current
    @testParser.current
  end

end
