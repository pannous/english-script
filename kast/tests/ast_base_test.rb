ENV["RAILS_ENV"] = "test"
$testing         =true
# $emit            =true #GLOBAL!

# require "test/unit"
require 'minitest/autorun'

require_relative '../kast-parser.rb'

class AstBaseTest < Minitest::Test # Test::Unit::TestCase #< EnglishParser

  # include Exceptions
  # attr_accessor :variableValues

  # def initialize args
  #   $verbose=false if ENV['TEST_SUITE']
  #   $emit   =false if $raking #SET per test_method ! OR RUN ALL TEST THROUGH EMITTER PIPELINE!!
  #   @parser =EnglishParser.new
  #   super args
  # end
end
