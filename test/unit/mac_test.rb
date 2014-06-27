#!/usr/bin/env ruby

$use_tree=false

require_relative '../parser_test_helper'

class MacTest < ParserBaseTest

  include ParserTestHelper

  def test_mail

  end

  def test_applescript
    skip if not ENV['APPLE']
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
    skip if not ENV['APPLE']
    variables['x']="/Users/me"
    variables['my home folder'] = "/Users/me"
    assert "/Users/me == x"
    assert "my home folder == /Users/me"
    assert "my home folder == x"
  end

  def test_files3
    skip if not ENV['APPLE']
    skip #worked once!
    init "my home folder = Dir.home"
    @parser.setter
    init "my home folder == /Users/me"
    @parser.condition
    init "/Users/me/.bashrc ok"
    p=@parser.linuxPath
    init "Dir.home"
    r=@parser.rubyThing
    parse "x := /Users/me "
    assert "my home folder == /Users/me"
    assert "/Users/me == x"
    assert "my home folder == x"
  end


  def test_variable_transitivity
    skip if not ENV['APPLE']
    parse "my home folder = Dir.home "
    parse "xs= my home folder "
    assert "xs = /Users/me" #WOW!
  end

  def test_contains_file
    skip if not ENV['APPLE']

    parse "xs= all files in Dir.home"
    p variables['xs']
    assert "xs contains .bashrc"

    parse "xs= Dir.home"
    assert "xs contains .bashrc"

    parse "xs=/Users/me"
    assert "xs contains .bashrc"

    parse "my home folder = Dir.home"
    parse "my home folder is Dir.home"
    p variables
    p variableValues
    assert{variableValues['my home folder']}
    # skip
    # assert{variables['home folder']}
  end

  def test_contains_file2
    skip if not ENV['APPLE']

    parse "my home folder = Dir.home"
    parse "xs = my home folder "
    parse "xs = files in my home folder "
    assert "xs contains .bashrc"
    skip
    parse "xs = all files in my home folder "
    parse "xs shall be all files in my home folder "
  end
end
