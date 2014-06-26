#!/usr/bin/env ruby

$use_tree=$emit
$use_tree=false

require_relative '../parser_test_helper'

class BashTest < ParserBaseTest

  include ParserTestHelper

  def test_pipe
    parse "bash 'ls -al' | column 1"
  end

  # def test_selector
  #   parse "column 1 from ls -all"
  # end
end
