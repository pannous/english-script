#!/usr/bin/env ruby

$use_tree=$emit
$use_tree=false

require_relative '../parser_test_helper'

class BashTest < Test::Unit::TestCase #< ParserBaseTest <  EnglishParser

  include ParserTestHelper

  def test_pipe
    parse "bash 'ls -al .'|column 1"
  end
end
